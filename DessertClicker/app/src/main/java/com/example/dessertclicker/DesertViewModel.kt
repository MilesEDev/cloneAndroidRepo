package com.example.dessertclicker

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.lifecycle.ViewModel
import com.example.dessertclicker.data.DessertData
import com.example.dessertclicker.model.Dessert
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

class DessertViewModel: ViewModel() {

    private val _uiState = MutableStateFlow(DessertData())

    val uiState: StateFlow<DessertData> = _uiState.asStateFlow()


    fun shareSoldDessertsInformation(intentContext: Context) {
        val sendIntent = Intent().apply {
            action = Intent.ACTION_SEND
            putExtra(
                Intent.EXTRA_TEXT,
                intentContext.getString(R.string.share_text, uiState.value.dessertsSold,
                    uiState.value.revenue)
            )
            type = "text/plain"
        }

        val shareIntent = Intent.createChooser(sendIntent, null)

        try {
            ContextCompat.startActivity(intentContext, shareIntent, null)
        } catch (e: ActivityNotFoundException) {
            Toast.makeText(
                intentContext,
                intentContext.getString(R.string.sharing_not_available),
                Toast.LENGTH_LONG
            ).show()
        }

    }

    fun determineDessertToShow(
        desserts: List<Dessert>,

        ): Dessert {
        var dessertToShow = desserts.first()
        for (dessert in desserts) {
            if (_uiState.value.dessertsSold >= dessert.startProductionAmount) {
                dessertToShow = dessert
            } else {
                // The list of desserts is sorted by startProductionAmount. As you sell more desserts,
                // you'll start producing more expensive desserts as determined by startProductionAmount
                // We know to break as soon as we see a dessert who's "startProductionAmount" is greater
                // than the amount sold.
                break
            }
        }

        return dessertToShow
    }
    fun clickEvent(desserts: List<Dessert>)
    {
        var rev = _uiState.value.revenue
        var desprice = _uiState.value.currentDessertPrice
        var desSold = _uiState.value.dessertsSold

        _uiState.update { currentState ->
            currentState.copy(
                // Update the revenue
                revenue = rev + desprice ,
                dessertsSold = desSold+1
            )
        }
        // Show the next dessert
        val dessertToShow = determineDessertToShow(desserts)
        _uiState.update { currentState ->
            currentState.copy(
                // Update the revenue
                currentDessertImageId = dessertToShow.imageId,
                currentDessertPrice = dessertToShow.price
            )
        }
    }

}
