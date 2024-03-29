#include <math.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include "cuda.h"
#include "curand.h"
#include "curand_kernel.h"


class node
{
private:
	double* weights;

	double bias = 0;


	double activation = 0;
	double rawForwardSum = 0;

	int populateCount = 0;

	volatile bool activated = false;


	double** weightUpdates;

	double* biasUpdates;

public:
	__device__
		void setWeightsSize(int weightSize);
	__device__
		void updateWeight(int weightID, double weight);
	__device__
		void updateBias(double bias);

	__device__
		double getActivation();

	__device__
		double getWeight(int weightID);
	__device__
		void setActivation(double newActivation);

	__device__
		void IncrementMergePopulation();

	__device__
		void addToRawForwardSum(double weightActivateMerge);

	__device__
		int returnPopulationCount();

	__device__
		double getRawForwardSum();

	__device__
		double getBias();

	__device__
		bool getActivated();

	__device__
		void setActivated(bool activated);
	__device__
		void setWeightUpdateBatch(int batch);
	__device__
		void updateWeightUpdate(double weight, int weightID, int batch);
	__device__
		void setBiasUpdateBatch(int batch);
	__device__
		void updateBiasUpdates(int batch, double newBias);
	__device__
	void updateWeights(int batchSize, int nextNeuronCount, double LEARNING_RATE);
	__device__
	void updateBiases(int batchSize, double LEARNING_RATE);
		
};


