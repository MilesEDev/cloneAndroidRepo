#include "state.cuh"
#include <cstdint>

state::state()
{

}

double state::getPriorty(int index, int expSize)
{
	return ((index / expSize)/totalEXP);
}

double state::getTrueValue()
{
	return value / visited;
}

bool state::setValue(double newValue)
{
	this->value = newValue;
	return true;

}

double state::getValue()
{
	return value;
}

bool state::safeSet(double newValue)
{
	double newVal = newValue;
	double tempValue = value; 
	uint64_t old = atomicCAS((uint64_t*)&value,*((uint64_t*)&tempValue), *((uint64_t*)&newVal));
	double* convertDouble = (double*) &old;
	float*  convert = (float*) & old;
	printf("\n THIS IS THE VALUE %f", value);
	
	
	if (*convertDouble == tempValue)
	{
		return true;
	}
	else
	{
		return false; 
	}
}

int state::getVisited()
{
	return visited;
}

void state::setVisited(int newVisitCount)
{
	visited = newVisitCount;
}

void state::setOldValue()
{
	oldValue = value;
}



