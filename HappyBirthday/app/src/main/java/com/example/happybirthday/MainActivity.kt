package com.example.happybirthday

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.sp
import com.example.happybirthday.ui.theme.HappyBirthdayTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            HappyBirthdayTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {

                }
            }
        }
    }
}


@Composable /*composable added to allow for composables like text to be added */
fun GreetingText(message: String ,from: String,modifier: Modifier = Modifier){

    Row {/*the row function with trailing lambda syntax to organise text in a row*/
        Text(
            /* added composable text function */
            text = message,
            fontSize = 30.sp,
            /* sp here is scalable pixel means that it will work for different
                    screen resoloutions and user prefered font sizes*/
            lineHeight = 116.sp,
            /* set to 116 so that it fills whole char size and leaves a bit
                    of white space as well between lines */
        )
        Text(
            text = from
        )
    }


}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    HappyBirthdayTheme {
        GreetingText(message = "Happy Birthday Miles", from = "leeds beckett")
    }
}