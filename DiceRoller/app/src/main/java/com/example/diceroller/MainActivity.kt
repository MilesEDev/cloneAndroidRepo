package com.example.diceroller

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.diceroller.ui.theme.DiceRollerTheme
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.Spacer
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.getValue

import androidx.compose.runtime.setValue
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.sp

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            DiceRollerTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    DoubleRoll()

                }
            }
        }
    }
}

@Composable
fun DiceWithButtonAndImage(modifier: Modifier = Modifier,result: MutableState<Int>) {


    val imageResource = when (result.value) {
        1 -> R.drawable.dice_1
        2 -> R.drawable.dice_2
        3 -> R.drawable.dice_3
        4 -> R.drawable.dice_4
        5 -> R.drawable.dice_5
        else -> R.drawable.dice_6
    }
    Column(
        modifier=modifier,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Image(
            painter = painterResource(imageResource),
            contentDescription = result.toString()

        )


    }
}
fun RandomRoll(result: MutableState<Int>,result2: MutableState<Int>): String
{
    result.value = (1..6).random()
    result2.value = (1..6).random()
    if(result.value == result2.value)
    {
        return "you rolled a double ${result2.value}"
    }
    else
    {
        return ""
    }
}
@Composable fun DoubleRoll(modifier: Modifier = Modifier) {


    val displayDouble = remember { mutableStateOf("") }
    val result = remember { mutableStateOf(1) }
    val result2 = remember { mutableStateOf(1) }
    Column(verticalArrangement = Arrangement.Center)
    {
        Row()
        {
            Column(modifier.weight(0.5f)) {
                DiceWithButtonAndImage(result = result)
            }
            Column(modifier.weight(0.5f)) {
                DiceWithButtonAndImage(result = result2)
            }
        }

        Button(onClick = { displayDouble.value = RandomRoll(result,result2)}, modifier = Modifier.align(alignment = Alignment.CenterHorizontally)) {
            Text(stringResource(R.string.roll))
        }

        Text(text = displayDouble.value,modifier = Modifier.align(alignment = Alignment.CenterHorizontally), fontSize = 30.sp, fontWeight = FontWeight.Bold,
            textDecoration = TextDecoration.Underline)


    }
}
