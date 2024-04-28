package com.example.happybirthday

import androidx.compose.ui.layout.ContentScale
import androidx.compose.foundation.Image
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
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
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.happybirthday.ui.theme.HappyBirthdayTheme
import com.example.happybirthday.ui.theme.christmas
import com.example.happybirthday.ui.theme.fancy

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
                    GreetingImage(
                        message = "merry christmas",
                        from = "from leeds beckett computing")



                }
            }
        }
    }
}


@Composable /*composable added to allow for composables like text to be added */
fun GreetingText(message: String ,from: String,modifier: Modifier = Modifier){


    Column(
        verticalArrangement = Arrangement.Bottom,/*centers the columb on the vertical accsess
        as it is changing the function parameter vertical arrangement before the trailing lambda
        syntax*/
        modifier = modifier /*here the columb modifer is set to match the modifer sent in
        as a parameter*/
    ) {/*this makes the text go into a columb format with trailing lambda syntax used*/
        Text(
            /* added composable text function */

            text = message,
            fontFamily = christmas,
            fontSize = 60.sp,
            /* sp here is scalable pixel means that it will work for different
                    screen resoloutions and user prefered font sizes*/
            lineHeight = 60.sp,
            /* set to 116 so that it fills whole char size and leaves a bit
                    of white space as well between lines */
            textAlign = TextAlign.Center,/* this centers the happy birthday text inside the columb
            that we have created*/
            modifier = Modifier.padding(10.0.dp,0.dp,10.0.dp,10.dp)
            .align(alignment = Alignment.CenterHorizontally)

        )
        Text(
            text = from,
            fontSize = 24.sp,
            fontFamily = fancy,
            modifier = Modifier

                .padding(16.dp)/* this adds some padding
            to add some room between the greeting and the side of the phone page*/
                .align(alignment = Alignment.CenterHorizontally)/*this continues the modifer edits so that the alignment
            of the from statement is at the right hand side of the page*/



        )
    }



}
@Composable
fun GreetingImage(message: String, from: String,modifier: Modifier=Modifier)
{
    val image=painterResource(R.drawable.background)/*this uses the image resource uploaded
    earlier and stores it in a constant so that we can later use it*/


    Box(modifier)
    {
        Image(
            painter = image,
            contentDescription = null,/*this is set to null so that accessibility assistance does
        not try and read out the background image*/
            contentScale = ContentScale.Crop, /*this makes sure that the image is scaled to fit
            the entire screen without making it look stretched*/
            alpha = 0.5F
            /*makes the image more transparant*/



        )
        GreetingText(
            message = message,
            from = from,
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp)
        )
    }



}




@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    HappyBirthdayTheme {
        GreetingImage(message = "merry christmas",
            from = "from leeds beckett computing")
    }
}