#include <math.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "node.cuh"
#include "cuda.h"
#include "curand.h"
#include "curand_kernel.h"
class network
{

private:
public:
    int inputNeurons = 0;
    int outputNeurons = 0;
    int hiddenNeurons = 0;
    int* neuronCounts;
    int hiddenLayers = 0;
    int totalLayers = 0;
    double* biases;
    double* costDerivativeVector;
    const double LEARNING_RATE = 0.001;
    double* desiredOutcome;
    int* taskCount;
    int totalTaskCount =0;
    bool classification = true;
    node*** networkStructure;
    int batchCount; 
    double* deriv;
    
	

	__host__
	network();
	
    __device__
    void addNeuronObjects();
	
	__device__ __host__
	double sigmoid(double x);

    __device__
    void populateNetworkStructFixed(unsigned int seed);

    __device__
    void generateWeights(node* toGetWeight,int weightID,int layers,curandState_t &state);

    __device__
    void generateBias(node* toGetWeight, int weightID,int layers, curandState_t &state);
    __device__
    void forwardPropagate(int layer);
  
    __device__
    void activateNeuron(int size,node* neuron,int layer);

    __device__
    void displayActivations();

    __device__
    void setDesiredOutcome(int pos, double replace); 
    __device__
    void calcDefaultDeriv();
    __device__
    double derivativecost(double activation, double desiredOutcome);
    __device__
    double softMaxSingle(double allExp, int numeriator);
    __device__
    double allExpOutput();
    __host__
    double backPropagation();
    __device__
    void calcBackDerivToCost(int layer, int weightID, int neuronPos, node* neuron);
    __device__
    double derivativeSigmoid(double x);
    __device__
    void calcReplacementDerivs(int layer); 
    __device__
    void calcBackOneLayer(int layer); 
    __device__
    double getSingleDeriv(double newDeriv);

    __device__
     void performWeightsandBiasUpdates();
};

