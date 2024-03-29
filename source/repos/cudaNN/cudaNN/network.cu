#include "network.cuh"
#include <iostream>



 
network::network()
{
    //cutting out for ease of testing

    std::cout << "how many layers will be hidden layers" << std::endl;
    std::cin >> hiddenLayers;
    neuronCounts = new int[hiddenLayers + 2];
    std::cout << "how many neurons will be in the input layer" << std::endl;
    std::cin >> inputNeurons;
    neuronCounts[0] = inputNeurons;
   
    for (int i = 1; i < hiddenLayers+1; i++)
    {
        std::cout << "how many neurons will be in the hidden layers" << std::endl;
        std::cin >> hiddenNeurons;
        neuronCounts[i] = hiddenNeurons;
    }
    std::cout << "how many neurons will be in the output layer" << std::endl;
    std::cin >> outputNeurons;
    neuronCounts[hiddenLayers+1] = outputNeurons;

    /*
    inputNeurons = 5;
    hiddenNeurons = 8;
    hiddenLayers = 3;
    outputNeurons = 5;*/
    totalLayers = hiddenLayers + 2;
    int* neuronCountsCopy = neuronCounts;
    cudaMalloc(&neuronCounts, totalLayers * sizeof(int));
    cudaMemcpy(neuronCounts, neuronCountsCopy, totalLayers * sizeof(int), cudaMemcpyHostToDevice);
    ;
    desiredOutcome = new double[outputNeurons];
    double* desiredOutcomeCopy = desiredOutcome;
    cudaMalloc(&desiredOutcome, outputNeurons * sizeof(double));
    cudaMemcpy(desiredOutcome, desiredOutcomeCopy, outputNeurons * sizeof(double), cudaMemcpyHostToDevice);
    taskCount = new int[totalLayers];
    for (int i = 0; i < totalLayers-1; i++)
    {
        taskCount[i] = neuronCountsCopy[i] * neuronCountsCopy[i + 1];
        taskCount[i] = taskCount[i] + neuronCountsCopy[i + 1];
        totalTaskCount = totalTaskCount + taskCount[i];
    }
    int* taskCountCopy = taskCount;
    cudaMalloc(&taskCount, totalLayers * sizeof(int));
    cudaMemcpy(taskCount, taskCountCopy, totalLayers * sizeof(int), cudaMemcpyHostToDevice);

}

void network::addNeuronObjects()
{
    networkStructure = new node **[totalLayers];
    for (int layer = 0; layer < totalLayers; layer++)
    {
        node** localList = new node*[neuronCounts[layer]];

        for (int nodeID = 0; nodeID < neuronCounts[layer]; nodeID++)
        {
            node* newNode = new node();
            newNode->setWeightsSize(neuronCounts[layer + 1]);
            localList[nodeID] = newNode;
            
        }

        networkStructure[layer] = localList;

    }
}


double network::sigmoid(double x)
{
	
	double result;
	result = 1 / (1 + exp(-x));
	return result;
}

void network::populateNetworkStructFixed(unsigned int seed)
{


    
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    int offset = 0;
    curandState_t state;
    curand_init(seed, 0, 0, &state);
    int total = totalTaskCount;
    int count = 0;
    
    double weight;
    for (int taskID = index; taskID < totalTaskCount; taskID = taskID + stride)
    {
        //unsigned int seed = time(NULL);
        count = 0;
        offset = 0;
        for (int layer = 0; layer < totalLayers; layer = layer +1)
        {
            count = count + taskCount[layer];
            if (taskID < count)
            {
                int localID = taskID - offset;
                int neuron = (localID / neuronCounts[layer+1]);
                int weightID = localID % neuronCounts[layer + 1];
                if (neuron > (neuronCounts[layer]-1))
                {
                    
                    node* nodeUpdate = networkStructure[layer + 1][weightID];
                    generateBias(nodeUpdate, weightID,layer ,state);
                }
                else
                {
                    
                    node* nodeUpdate = networkStructure[layer][neuron];
                    generateWeights(nodeUpdate, weightID, layer,state);
                }
                offset = offset + taskCount[layer];
                break;

            }
            offset = offset + taskCount[layer];
        }
    }

}

void network::generateWeights(node* toGetWeight,int weightID,int layers, curandState_t &state)
{

    double weight;
    int weightCount = neuronCounts[layers + 1];

    double range = sqrt((float) weightCount);
    double MAX = RAND_MAX;
   // for (int i = 0; i < 10; i++)
   // {
         weight = (double)fmod((double)curand(&state), (double)MAX);
   
   // }
    weight = weight / MAX;
    printf("pre-range set %f             ", weight);
    weight = (double) fmod((double) weight, (double) range);
    printf("%f             \n", weight);
   
    int flip =  curand(&state)%2;
    if (flip)
    {
        weight = weight * -1;
    }
    toGetWeight->updateWeight(weightID,weight);
}

void network::generateBias(node* toGetWeight, int weightID, int layers, curandState_t &state)
{
   
    int weightCount = neuronCounts[layers + 1];
    double range = sqrt((float) weightCount);
    int MAX = RAND_MAX;
    double bias = (double)fmod((double)curand(&state), (double)MAX);
    bias = bias / MAX;
    bias = (double)fmod((double)bias, (double)range);
    int flip = curand(&state) % 2;
    if (flip)
    {
        bias = bias * -1;
    }
    toGetWeight->updateBias(bias);
}

void network::forwardPropagate(int layer)
{

    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;

  
    int weightID;
    int neuron;
    node* targetObj;
   
    
    for (int taskID = index; taskID < taskCount[layer]; taskID = taskID + stride)
    {
        neuron = taskID / neuronCounts[layer] ;
        
        weightID = taskID % neuronCounts[layer+1];
        node* neuronObj = networkStructure[layer][neuron];
        targetObj = networkStructure[layer + 1][weightID];
        if (weightID ==0)
        {
            neuronObj->setActivated(sigmoid(neuronObj->getActivation()));
        }
        if (neuron < neuronCounts[layer])
        {
            targetObj->addToRawForwardSum(neuronObj->getActivation() * neuronObj->getWeight(weightID));
        }
        else
        {
            targetObj->addToRawForwardSum(neuronObj->getActivation()*neuronObj->getBias());
        }


    }
      
    
    
}

void network::activateNeuron(int size,node* neuron,int layer)
{
  
    if (neuron->returnPopulationCount() == size)
    {
        if (layer < totalLayers - 2)
        {
            neuron->setActivation(sigmoid(neuron->getRawForwardSum()));
            neuron->setActivated(true);
        }
        else
        {
            neuron->setActivation(neuron->getRawForwardSum());
        }
    }
    

}

void network::displayActivations()
{
    int total = totalLayers;
    for (int layers = 0; layers < total; layers = layers+1)
    {
        int count = neuronCounts[layers];
        printf("____________________________________________\n");
        for (int countID = 0; countID < count; countID = countID + 1)
        {
            printf("%f              ", networkStructure[layers][countID]->getActivation());
        }

    }
}

void network::setDesiredOutcome(int pos, double replace)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for (int outcomeID = index; outcomeID < neuronCounts[totalLayers - 1]; outcomeID = outcomeID + stride)
    {
        
        desiredOutcome[outcomeID] = 0;
        if (outcomeID == pos)
        {
            desiredOutcome[outcomeID] = replace; 
        }
    }
    
}

void network::calcDefaultDeriv()
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    double derivCost;
    if (threadIdx.x == 0)
    {
        deriv = new double[totalLayers];
    }
    __syncthreads(); 
    for (int nodeID = index; nodeID < neuronCounts[totalLayers - 1]; index + stride)
    {
        node* neuron = networkStructure[totalLayers - 1][nodeID];
        if (classification == true)
        {
            double allExp = allExpOutput();
            derivCost = derivativecost(softMaxSingle(allExp, nodeID), desiredOutcome[nodeID]);
        }
        else
        {
            derivCost = derivativecost(neuron->getActivation(), desiredOutcome[nodeID]);
        }
        deriv[nodeID] = derivCost;
    }
}

double network::derivativecost(double activation, double desiredOutcome)
{
    return(2 * (activation - desiredOutcome));
}

double network::softMaxSingle(double allExp, int numeriator)
{
    return exp(networkStructure[totalLayers - 1][numeriator]->getActivation()) / allExp;
}

double network::allExpOutput()
{
    double expOutput = 0;
    for (int outputs = 0; outputs < neuronCounts[totalLayers - 1]; outputs++)
    {
        double activation = networkStructure[totalLayers - 1][outputs]->getActivation();
        expOutput = expOutput + exp(activation);
    }
    return expOutput;
}

double network::backPropagation()
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    

}

void network::calcBackDerivToCost(int layer, int weightID, int neuronPos, node* neuron)
{
    
     node* nextNeuron = networkStructure[layer + 1][weightID];
     double score = neuron->getWeight(weightID) * derivativeSigmoid(nextNeuron->getRawForwardSum()) * deriv[weightID];
     atomicAdd(&deriv[neuronPos],score);
    
    
}

double network::derivativeSigmoid(double x)
{
    return(1 - sigmoid(x));
}

void network::calcReplacementDerivs(int layer)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for (int weightID = index; weightID < neuronCounts[layer + 1]; weightID = weightID + stride)
    {
        int neuron = weightID / neuronCounts[layer + 1];
        node* neuronObj = networkStructure[layer][neuron];
        calcBackDerivToCost(layer, weightID, neuron, neuronObj);
    }
}

void network::calcBackOneLayer(int layer)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for (int taskID = index; taskID < taskCount[layer]; taskID = taskID + stride)
    {
        int neuron = taskID / neuronCounts[layer];
        int weightID = taskID % neuronCounts[layer + 1];
        node* neuronObj = networkStructure[layer][neuron];
        node* targetObj = networkStructure[layer+1][neuron];
        double newDeriv = getSingleDeriv(weightID);
        if (neuron < neuronCounts[layer])
        {
            double weightAdd = neuronObj->getActivation() * derivativeSigmoid(targetObj->getRawForwardSum()) * newDeriv;
            neuronObj->updateWeightUpdate(weightAdd, weightID, 0);
        }
        else
        {
            double newBias = 1 * derivativeSigmoid(targetObj->getRawForwardSum()) * newDeriv;
            targetObj->updateBiasUpdates(0,newBias);
        }
      
    }
    
}

double network::getSingleDeriv(double newDeriv)
{
    return newDeriv;
}

void network::performWeightsandBiasUpdates()
{
    /*
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    
    for (int taskID = index; taskID < totalTaskCount; taskID = taskID + stride)
    {
        for (int layer = 0; layer < totalLayers; layer++)
        {
            if (taskID < taskCount[layer])
            {

            }
        }
    }
    */
}


