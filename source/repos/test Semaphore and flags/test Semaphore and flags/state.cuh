#pragma once
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "curand.h"
#include "curand_kernel.h"
#include <iostream>
class state
{
private:

	double value;

	int visited = 0;

	int totalEXP = ((100 * 99) / 2)/100;

	int oldValue;
public:
	__device__ __host__
		state();
	__device__ __host__
		double getPriorty(int index, int expSize);
	__device__ __host__ 
		double getTrueValue();
	__device__ __host__ 
		bool setValue(double newValue);
	__device__ __host__ 
		double getValue();

	__device__ 
	bool safeSet(double newValue); 
	__device__ __host__ 
	int getVisited();
	__device__ __host__
	void setVisited(int newVisitCount);
	__device__
	void setOldValue();

};

