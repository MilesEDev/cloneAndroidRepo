package com.example.quadrants

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import com.example.quadrants.ui.theme.QuadrantsTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            QuadrantsTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    MainPage()
                }
            }
        }
    }
}

@Composable
fun MainPage(modifier: Modifier = Modifier) {
    Column(modifier=Modifier.fillMaxHeight()) {


        Row(modifier = Modifier.fillMaxWidth().weight(1f).background(Color.Green))
        {
            Box(modifier = Modifier
                .weight(1f)
                .background(Color.Magenta).fillMaxWidth().fillMaxHeight())
            {
                Text(text = "header")
            }
            Box(modifier = Modifier
                .weight(1f)
                .background(Color.Red).fillMaxWidth().fillMaxHeight())
            {
                Text(text = "header")
            }




        }
        Row(modifier = Modifier.fillMaxWidth().weight(1f).background(Color.Green)) {
            Box(modifier = Modifier
                .weight(1f)
                .background(Color.Blue).fillMaxWidth().fillMaxHeight())
            {
                Text(text = "header")
            }

            Box(modifier = Modifier
                .weight(1f)
                .background(Color.LightGray).fillMaxWidth().fillMaxHeight())
            {
                Text(text = "header")
            }
        }
    }
}



@Preview(showBackground = true)
@Composable
fun QuadrantsPreview() {
    QuadrantsTheme {
        MainPage()
    }
}