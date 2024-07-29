package com.example.dessertclicker.data

import androidx.annotation.DrawableRes
import com.example.dessertclicker.R

data class DessertData(val revenue:Int = 5,
                       val dessertsSold:Int =0,
                       val currentDessertIndex:Int=0,
                       val currentDessertPrice:Int=5,
                       @DrawableRes val currentDessertImageId:Int=R.drawable.cupcake)


