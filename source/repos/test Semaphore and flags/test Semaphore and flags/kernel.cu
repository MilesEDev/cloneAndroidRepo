
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <iostream>
#include "vector"
#include "state.cuh"
#include "thrust/device_vector.h"
#include "device_atomic_functions.h"
#include <cuda.h>
#include "curand.h"
#include "curand_kernel.h"

//need to imeplent the min condition 

__device__ double globalDouble = 0;

__device__ int test = 50;

__device__ volatile int incrementor = 0;

__device__ int* arr[5];

__device__  double gpu = 5;

__device__ int Sum[7] = { 1,2,3,4,5,6,7 };

__device__ int len = 7;



__device__ int atomicJobGrab = 0;

__device__ int atomicJobGrabShift = 0;

__device__ volatile int globalFound = -1; 

__device__ state* saveState;



__device__ state* EXPStore[100];

__device__ state** EXP = EXPStore;

__device__ state* EXPReplaceStore[100];

__device__ state** EXPReplace = EXPReplaceStore;

__device__ int atomicSynch = 0; //may need to atomicCAS this instead volatile

__device__ int deviceMin =0; 

__device__ double lockValue = -1;

__device__ double threadLock = -1;

#define MAX RAND_MAX

__global__ void addToExp(unsigned int seed)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    state* newState = new state(); 
    curandState_t curState;
    curand_init(seed, index, 0, &curState);
    for (int i = index; i < 100; i = i + stride)
    {
        state* newState = new state();
        double newValue = i;
        newState->setValue(newValue);
        EXP[i] = newState;
    }

}

/*
void readEXP()
{
    for (int i = 0; i < 100; i++)
    {
        std::cout << EXP[i]->getValue() << std::endl; 
    }
}
void addToExp()
{
    state* newState = new state();
    for (int i = 0; i < 100;i++)
    {
        state* newState = new state();
        double newValue = i;
        newState->setValue(newValue);
        EXP[i] = newState;
    }


}*/
__host__
void simpleBinarySearch(unsigned int seed)
{
    //int index = blockIdx.x * blockDim.x + threadIdx.x;
    //int stride = blockDim.x * gridDim.x;
    //curandState_t curState;
    //curand_init(seed, index, 0, &curState);
    
    int startIndex = 50;
    int diff;
    state* newState = new state();
    double newValue = (double)fmod((double)rand(), (double)1000);

    newState->setValue(newValue);
    state* compare;
    state* compareNext;
    int boundaryIndex = 100;
    bool key = false;
    
    for (int i = 0; i < 100; i = i ++)
    {
        
        startIndex = 50;
       


        newValue = (double)fmod((double)rand(), (double)1000);

        newState->setValue(newValue);

        boundaryIndex = 100;
        key = false;
       
        if (newState->getValue() > EXP[startIndex]->getValue())
        {

            diff = sqrt(pow(startIndex - boundaryIndex, 2)) / 2;
            startIndex = startIndex + diff;

        }
        if (newState->getValue() <= EXP[startIndex]->getValue())
        {
            diff = sqrt(pow(startIndex - boundaryIndex, 2)) / 2;
            startIndex = startIndex - diff;
        }
        int counter = 0; 

        while (key == false)
        {
            counter = counter + 1;
            compare = nullptr;
            compareNext = nullptr;
            printf("start index %d", startIndex);
            compare = EXP[startIndex];
            if (startIndex < 99)
            {
                compareNext = EXP[startIndex + 1];
                printf("\n compare state next %f", compareNext->getValue());
            }
            printf("new state %f \n ", newState->getValue());
            printf("compare state %f \n ", compare->getValue());

            //printf("compare next state %f \n ", compareNext->getValue());
            if (newState->getValue() > compare->getValue())
            {
                if (diff > 1)
                {
                    diff = diff / 2;
                }
                startIndex = startIndex + diff;
            }
            if (newState->getValue() <= compare->getValue())
            {
                if (diff > 1)
                {
                    diff = diff / 2;
                }
                startIndex = startIndex - diff;
            }

            double compareVala = compare->getValue();
            double newStateValue = newState->getValue();

            if (newStateValue > compareVala)
            {
                
                if (compareNext==nullptr)
                {
                    printf("runs pst 1st if");
                    key = true;
                }
                else
                {
                    double compareValb = compareNext->getValue();

                    if (newStateValue <= compareValb)
                    {
                        //printf("compare done \n");
                        key = true;
                    }
                    else
                    {
                        //printf("THIS STATEMENT IS NOT FUCKING TRUE");
                    }
                }
            }
        }

        key = false;

        while (key == false)
        {

            bool Race = compare->setValue(newState->getValue());
            if (Race)
            {
                key = true;
                /*free(newState);
                free(compare);
                if (compareNext != nullptr)
                {
                    free(compareNext);
                }*/
            }
            else
            {
                startIndex = startIndex - 1;
                compare = EXP[startIndex];
            }
        }
        if (startIndex > 0)
        {
            EXP[startIndex] = compare;
            printf("\n %d done \n", i);
        }
        else
        {
            printf("\n - hit\n");
        }
    }

}
__global__
void displayEXP()
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    printf("is this even running");
    for (int i = index; i < 100; i = i + stride)
    {
        printf("%f \n", EXP[i]->getValue());
    }
      
}
/*
__global__ void binarySearch(unsigned int seed)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    curandState_t curState;
    curand_init(seed, index, 0, &curState);
    bool key = false; 
    state* comparePointer; 
    for (int i = index; i < 500; i++)
    {
        state* newState = new state(); 
        double newValue = (double)fmod((double)curand(&curState), (double)100);
        newState->setValue(newValue);
        int lastIndex;
        int startIndex = 50;
        int lenEXP = 100;

        bool greaterOrLesser;
        if (newState->getValue() > comparePointer->getValue())
        {
            startIndex = startIndex + ((lenEXP - startIndex)/2);
            greaterOrLesser = true; 
            while (greaterOrLesser == true)
            {
                comparePointer = EXP[startIndex];
                if (newState->getValue() > comparePointer->getValue())
                {
                    lastIndex = startIndex;
                    startIndex = startIndex + ((lenEXP - lastIndex)/2);

                }
                if (newState->getValue() < comparePointer->getValue())
                {
                    greaterOrLesser = false;
                
                }
            }
            while (key == false)
            {
                int addOn = 1; 
                lastIndex = lastIndex + addOn; 
                
                if (lastIndex < 0)
                {
                    break;
                }
                comparePointer = EXP[lastIndex];
                if (newState->getValue() > comparePointer->getValue())
                {
                    
                    
                    bool Race = comparePointer->safeSet(newState->getValue());
                    if (Race)
                    {
                        key = true;

                    }
                    else
                    {
                        addOn = -1;
                    }
                    
                }

            }
        }
       //reversed operation
        if (newState->getValue() < comparePointer->getValue())
        {
            startIndex = startIndex / 2;
            greaterOrLesser = false;
            while (greaterOrLesser == false)
            {
                comparePointer = EXP[startIndex];
                if (newState->getValue() < comparePointer->getValue())
                {
                    lastIndex = startIndex;
                    startIndex = startIndex/2;

                }
                if (newState->getValue() > comparePointer->getValue())
                {
                    greaterOrLesser = true;


                }
            }
            while (key == false)
            {
                int addOn = 1;
                lastIndex = lastIndex + addOn;
                comparePointer = EXP[lastIndex];

                if (newState->getValue() > comparePointer->getValue())
                {
                    
                    bool Race = comparePointer->safeSet(newState->getValue());
                    if (Race)
                    {
                        key = true;

                    }
                    else
                    {
                        addOn = -1;
                    }
                    
                }

            }
        }
    }
    
}
*/
__global__ void hitAndShift(unsigned int seed)
{
    
    curandState_t curState;
    curand_init(seed, 0, 0, &curState);
    double range = (double)fmod((double)curand(&curState), (double)MAX);
    int lenExp = 100;
    int total = (100 * 99) / 2 / 100;
    double r = range;
    //
    // Coefficients for the quadratic equation : ax ^ 2 + bx + c = 0
    int a = 1;
    int b = 1;
    double c = -2 * r * lenExp * total;

    //Solving the quadratic equation for n using the quadratic formula
    double discriminant = sqrt(pow(b, 2) - 4 * a * c);
    double n1 = (-b + discriminant) / (2 * a);
    double n2 = (-b - discriminant) / (2 * a);

    //Selecting the positive root since n must be positive]
    int n;
    if (n1 > 0)
    {
        n = n1;
    }
    else
    {
        n = n2;
    }

    //Rounding down
    int id = n;//(Daniel,Kramer,2024)

    //state* compare = EXP[id];
    //compare->setVisited(compare->getVisited());
    //compare->getTrueValue();

    

}



__global__ void testAtomicCas()

{
    double compare = 0; 
    double newValue = 5; 

    uint64_t old = atomicCAS((uint64_t*)&globalDouble, *((uint64_t*)&compare), *((uint64_t*)&newValue));

    printf("%f", globalDouble);


}


__global__ void observableState()
{
   
   
  
    int id = threadIdx.x;
    printf("yello %d \n",incrementor);
    while (id != incrementor)
    {
        printf("var %d \n", incrementor);
        //atomicCAS(&incrementor, id, 1);
       
    }
    //atomicAdd(&incrementor, 1);
    incrementor = incrementor + 1;
    printf("hello world!"); 
    
}
__global__ void randomK(unsigned int seed)
{
    double gpu2;
    curandState_t state;
    curand_init(seed, 0, 0, &state);
    for (int i = 0; i < 10; i++)
    {
        gpu2 = (double) fmod((double) curand(&state),(double)MAX);
        
        gpu2 = gpu2/MAX;
        printf("%f \n", gpu2);
    
    }
    
}

__global__ 
void runIn()
{
  
    printf("hello");
    __shared__ int s[64];
    s[1] = 5;
    //__syncthreads();
    printf("value");
    
}
__global__
void runShare()
{
    printf("hello");
    extern __shared__ int s[];
    //__syncthreads();
 
    while (s[1] != 5)
    {

    }
    printf("rar");
    printf("%d", s[1]);
}

__global__
void display()
{
    
   // thrust::device_vector<int> myvec;
    //myvec.push_back(1);
    printf("hello ther");
}

__global__ void atomAdd(int *a_d)
{
    //atomicAdd(&incrementor, 1);
    printf("%d", incrementor);
    
}

__global__ void freshKernel()
{
    int threadID = threadIdx.x;

    for (int i = 0; i < 5; i++)
    {
        if (threadIdx.x == incrementor)
        {
            incrementor = incrementor + 1;
       
        }
        __syncthreads();
    }
    printf("%d", incrementor);
}
__global__  
void raceAdd(int* testValP)
{
    
    
    __shared__ int Var1;
    
    printf("%d", Var1);

    printf("%d", test);

    int threadUpdate = *testValP;
    printf("thread updates 1 %d \n", threadUpdate);
    int threadID = threadIdx.x;
    //printf("%d this is the id", threadIdx.x);
    if (threadIdx.x == 0)
    {
        Var1 = 1;
        printf("if passed \n ");
    }
    printf("do changes occur %d",Var1);

    printf("%d \n", threadIdx.x);
    printf("hello hello hello \n");
    printf("thread updates 2 %d \n", threadUpdate);
    while (threadID != threadUpdate)
    {
        threadUpdate = *testValP;
    }
    *testValP = *testValP + 1;
    printf("loop passed \n");
 
}

__device__
int simpleBinarySearchPortion(int startIndex,int jobSize,double value,bool appendEnd)
{
    int numChecked = 0; 
    state* newState = new state();
    int originalIndex = startIndex;
    newState->setValue(value);
    state* compare;
    state* compareNext;
    int boundaryIndex = jobSize;
    int diff = (boundaryIndex-startIndex)/2;
    if (diff <= 0)
    {
        diff = 1;
    }
    bool key = false;
    while (key == false)
    {
        if ((startIndex < originalIndex || globalFound > -1) && lockValue>-1)
        {
            break;
        }
        compareNext = nullptr;

        compare = EXP[startIndex];
        if (startIndex < jobSize )
        {
            compareNext = EXP[startIndex + 1];
        }
        if (newState->getValue() > compare->getValue())
        {
            if (diff > 1)
            {
                diff = diff / 2;
            }
            
            if ((compareNext == nullptr && appendEnd)|| (compareNext->getValue() >= newState->getValue()))
            {
                printf("hello");
                key = true; 
            }
            else
            {
                startIndex = startIndex + diff;
            }

        }
        if (newState->getValue() <= compare->getValue())
        {
            if (diff > 1)
            {
                diff = diff / 2;
            }
            startIndex = startIndex - diff;
            
        }
        numChecked = numChecked+1;
        if (numChecked >= jobSize-originalIndex)
        {
            break;
        }
    }
    if (key)
    {
        saveState = new state();
        saveState->setValue(EXP[startIndex]->getValue());
        
        EXP[startIndex]->setValue(newState->getValue());
        return startIndex;
    }
    else
    {
        return -1; 
    }

}


__device__
void teamBinarySearch(int jobSize, double value)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    
    while(true)//value >-1
    { 
        int miniJobSize = (jobSize / stride);
        if (jobSize % stride > 0)
        {
            miniJobSize = miniJobSize + 1;
        }
        int old = atomicAdd(&atomicJobGrab,1);

        int startIndex = (miniJobSize * old);
        if ((startIndex+miniJobSize-1) < jobSize)
        {
            bool appendEnd = false;
            if (startIndex + miniJobSize == jobSize)
            {
                //printf("start index %d", startIndex);
                appendEnd = true;

            }
            int result = simpleBinarySearchPortion(startIndex, miniJobSize + startIndex, value, appendEnd);
            if (result >-1)
            {
                atomicJobGrab = 0;
                if (result == 0)
                {
                    int deviceMin = result;
                }
                globalFound = result;
                
                
            }
            if (globalFound >-1 || lockValue ==-1)
            {
                break;
            
            }
        }
       
    //this is where shifting will be done

    }
}

__global__ 
void copyToReplace()
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for (int i = index; i < 100; i = i + stride)
    {
        EXPReplace[i] = EXP[i];
    }
}

__device__
void shiftPortion(int startIndex, int jobSize)
{
    while (startIndex < jobSize)
    {
        if (startIndex == 0)
        {
            free(EXPReplace[startIndex]);
        }
        EXPReplace[startIndex] = EXP[startIndex + 1];
        startIndex = startIndex + 1;

    }
    atomicAdd(&atomicSynch, 1);

}

__device__
void kernalShift(int jobSize,int value)
{
    jobSize = globalFound;
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    int miniJobSize = (jobSize / stride);
    if (jobSize % stride > 0)
    {
        miniJobSize = miniJobSize + 1;
    }
    while (atomicSynch < jobSize / miniJobSize && globalFound>-1)
    {
        int old = atomicAdd(&atomicJobGrabShift, 1);
       
        
        printf("\n %d %d %d", old, atomicSynch, jobSize / miniJobSize);
        int startIndex = (miniJobSize * old);
        if ((startIndex + miniJobSize-1) < jobSize)
        {
            shiftPortion(startIndex, miniJobSize + startIndex);
        }
     
    }
    if (atomicSynch == jobSize / miniJobSize || value ==-1)
    {
        printf("%d",atomicSynch);
        EXPReplace[globalFound-1] = saveState;
        EXP = EXPReplace;
        

    }


}
__global__
void setSaveState()
{
    saveState = new state();
  

}
__device__
void checkLock(int jobsize, double value)
{
    if (threadLock == -1)
    {
        lockValue = value;//this will be a random value not 5
        atomicJobGrab = 0; 
        threadLock = threadIdx.x;
        globalFound = -1;
        atomicJobGrabShift = 0; 
        atomicSynch = 0;



    }
    if (lockValue > -1)
    {
        //do all the complex shit
        teamBinarySearch(jobsize, value);
        //lock already done
        kernalShift(globalFound-1,value);

        if (threadLock == threadIdx.x)
        {
            lockValue = -1;
           


        }
    }
}
__global__
void generate(int jobSize,unsigned int seed)
{
    curandState_t state;
    curand_init(seed, 0, 0, &state);
    for (int i = 0; i < 1; i++)
    {
        double localValue = (double)fmod((double)curand(&state), (double)100);

        if (localValue > deviceMin)
        {
            checkLock(jobSize, localValue);
        }
        printf("hopefuly this works \n%f", localValue);
    }
}

int main() 
{   
    srand(time(0));
    /*
    int a = 0, * a_d;
    cudaMalloc((void**)&a_d,sizeof(int));
    cudaMemcpy(a_d, &a, sizeof(int),cudaMemcpyHostToDevice);

    atomAdd << <1, 5 >> > (a_d);
    */
    unsigned int seed = time(NULL); 
    //testAtomicCas << <1, 1 >> > ();
    //addToExp();

    //readEXP();
    addToExp<<<1, 1>>>(seed);
    int jobsize = 100;
    copyToReplace << <1, 50 >> > ();
    
    generate<<<1, 50>>>(100,time(NULL));
    displayEXP<<<1, 1>>>();

}
