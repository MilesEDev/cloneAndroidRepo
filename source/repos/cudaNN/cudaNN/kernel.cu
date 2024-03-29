
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include "network.cuh"
#include <iostream>


__global__
void testSig()
{
	
	
}


__global__
void newIt()
{
	node* myNode = new node();
	printf("%f", myNode->getActivation());
	myNode->setActivation(5);
	printf("%f", myNode->getActivation());
}
__global__ 
void lazyMemoryPopulate(network* myNetwork)
{
	//printf("%d", myNetwork->totalLayers);
	myNetwork->addNeuronObjects();
}
__global__
void generateWeights(network* myNetwork,unsigned int seed)
{

	myNetwork->populateNetworkStructFixed(seed);

}
__global__
void forwardProp(network* myNetwork,int layer)
{
	
	myNetwork->forwardPropagate(layer);
	printf("finished forward prop");
}
__global__
void displayKernelAct(network* myNetwork)
{
	printf("hello world");
	myNetwork->displayActivations();
}
__global__
void setInputs(network* myNetwork,double* inputs)
{
	myNetwork->setInputs(inputs);
}


int main()
{
	//network* mynetwork = new network();
	//mynetwork->sigmoid(5);
	
	network* myNetwork;

	network* myNetworkCPU = new network();


	cudaMalloc(&myNetwork, sizeof(network));
	cudaSetDeviceFlags(cudaDeviceScheduleBlockingSync);
	cudaMemcpy(myNetwork, myNetworkCPU, sizeof(network), cudaMemcpyHostToDevice);

	int total = myNetworkCPU->totalLayers;
	lazyMemoryPopulate << <1, 1 >> > (myNetwork);
	generateWeights << <1, 1>> > (myNetwork, time(NULL));
	//no inputs yet muppet
	double myList[5] = {0.54,0.32,0.23,0.74,0.82};

	setInputs << <1, 1 >> > (myNetwork, &myList);
	forwardProp << <1,1 >> > (myNetwork,0);
	

	cudaDeviceSynchronize();
	displayKernelAct << <1, 1 >> > (myNetwork);
	cudaDeviceSynchronize();
	std::cout << "all done" << std::endl;

	
}