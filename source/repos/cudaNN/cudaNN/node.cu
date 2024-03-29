#include "node.cuh"

void node::setWeightsSize(int weightSize)
{
	weights = new double[weightSize];
}

void node::updateWeight(int weightID, double weight)
{
	weights[weightID] = weight;
}

void node::updateBias(double bias)
{
	this->bias = bias; 
}


double node::getActivation()
{
	return activation;
}

double node::getWeight(int weightID)
{
	return weights[weightID];
}

void node::setActivation(double newActivation)
{
	activation = newActivation;
}

void node::IncrementMergePopulation()
{
	atomicAdd(&populateCount, 1);
}

void node::addToRawForwardSum(double weightActivateMerge)
{
	atomicAdd(&rawForwardSum, weightActivateMerge);
}

int node::returnPopulationCount()
{
	return populateCount;
}

double node::getRawForwardSum()
{
	return rawForwardSum;
}

double node::getBias()
{
	return bias;
}

bool node::getActivated()
{
	return true;
}

void node::setActivated(bool activated)
{
	this->activated = activated;
}

void node::setWeightUpdateBatch(int batch)
{
	weightUpdates = new double*[batch];
	for (int i = 0; i < batch; i++)
	{
		weightUpdates[i] = new double[batch];
	}
	

}

void node::updateWeightUpdate(double weight, int weightID, int batch)
{
	weightUpdates[weightID][batch] = weight; 
}

void node::setBiasUpdateBatch(int batch)
{
	biasUpdates = new double[batch];
}

void node::updateBiasUpdates(int batch,double newBias)
{
	biasUpdates[batch] = newBias;
}

void node::updateWeights(int batchSize,int nextNeuronCount,double LEARNING_RATE)
{
	double averageWeight = 0;
	for (int weightID = 0; weightID < nextNeuronCount; weightID = weightID + 1)
	{
		for (int batchID = 0; batchID < batchSize; batchID++)
		{
			averageWeight = averageWeight + weightUpdates[batchID][weightID];
		}
		averageWeight = averageWeight / batchSize;
		double old_weight = getWeight(weightID);
		double new_weight = old_weight - (averageWeight * LEARNING_RATE);
		weights[weightID] = new_weight;
	}
}

void node::updateBiases(int batchSize, double LEARNING_RATE)
{
	double averageBias = 0; 
	for (int batchID = 0; batchID < batchSize; batchID++)
	{
		averageBias = averageBias + biasUpdates[batchID];
	}
	double old_bias = bias;
	double new_bias = bias - (averageBias * LEARNING_RATE);
	bias = new_bias;
}



