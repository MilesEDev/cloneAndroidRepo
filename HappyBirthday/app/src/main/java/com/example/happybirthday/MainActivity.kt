package com.example.happybirthday

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
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
                    GreetingText(message = "Happy Birthday Miles", from = "leeds beckett") /*added
                    greeting text here in on create function which is called for the device not
                    the preview so display will now go on device.*/

                }
            }
        }
    }
}


@Composable /*composable added to allow for composables like text to be added */
fun GreetingText(message: String ,from: String,modifier: Modifier = Modifier){


    Column(
        verticalArrangement = Arrangement.Center,/*centers the columb on the page on the main axis
        which for columb is the y axis as columbs go up to down */
        modifier = modifier.padding(8.dp),/* here the modifier sent into the composable function
        will maintain its prior state however with changes to the padding which pushes elements
        to correct position dp is used here as sp factors in prefered font size which is irrelevant
        for padding in this case the padding is used to center the columb on the x axis*/
    ) {/*this makes the text go into a columb format with trailing lambda syntax used*/
        Text(
            /* added composable text function */
            text = message,
            fontSize = 100.sp,
            /* sp here is scalable pixel means that it will work for different
                    screen resoloutions and user prefered font sizes*/
            lineHeight = 116.sp,
            /* set to 116 so that it fills whole char size and leaves a bit
                    of white space as well between lines */
            textAlign = TextAlign.Center/* this centers the happy birthday text inside the columb
            that we have created*/
        )
        Text(
            text = from,
            fontSize = 36.sp,
            modifier = modifier.padding(16.dp)/* this adds some padding
            to add some room between the greeting and the side of the phone page*/
            .align(alignment = Alignment.End)/*this continues the modifer edits so that the alignment
            of the from statement is at the right hand side of the page*/



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