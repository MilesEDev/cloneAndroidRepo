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



