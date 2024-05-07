package com.example.dessertclicker

import androidx.lifecycle.ViewModel
import com.example.dessertclicker.data.DessertData
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class DessertViewModel: ViewModel() {

    private val _uiState = MutableStateFlow(DessertData())

    val uiState: StateFlow<DessertData> = _uiState.asStateFlow()

}
