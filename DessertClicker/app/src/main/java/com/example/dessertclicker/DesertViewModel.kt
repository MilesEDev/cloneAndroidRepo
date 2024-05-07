package com.example.dessertclicker

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.lifecycle.ViewModel
import com.example.dessertclicker.data.DessertData
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

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

}
