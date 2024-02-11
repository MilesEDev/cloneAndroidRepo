package com.example.quadrants

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.FontWeight.Companion.Bold
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.quadrants.ui.theme.QuadrantsTheme
import kotlin.io.encoding.Base64

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


        Row(modifier = Modifier
            .fillMaxWidth()
            .weight(1f)
            .background(Color.Green))
        {
            Box(contentAlignment = Alignment.Center, modifier = Modifier
                .weight(1f)
                .background(Color(0xFFEADDFF))
                .fillMaxWidth()
                .fillMaxHeight()
                .padding(16.dp))

            {
                Column() {
                    Box(contentAlignment = Alignment.Center,
                        modifier = Modifier.fillMaxWidth()) {
                        Text(


                            text = "Text composable",

                            fontWeight = Bold,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.padding(bottom = 16.dp)
                        )
                    }


                    Text(

                        text =
                        "Displays text and follows the recommended Material Design guidelines.",
                        textAlign = TextAlign.Justify
                    )
                }




            }
            Box(contentAlignment = Alignment.Center, modifier = Modifier
                .weight(1f)
                .background(Color(0xFFD0BCFF))
                .fillMaxWidth()
                .fillMaxHeight()
                .padding(16.dp))

            {
                Column() {
                    Box(contentAlignment = Alignment.Center, modifier = Modifier.fillMaxWidth()) {
                        Text(


                            text = "Text composable",

                            fontWeight = Bold,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.padding(bottom = 16.dp)
                        )
                    }


                    Text(

                        text =
                        "Displays text and follows the recommended Material Design guidelines.",
                        textAlign = TextAlign.Justify
                    )
                }




            }




        }
        Row(modifier = Modifier
            .fillMaxWidth()
            .weight(1f)
            .background(Color.Green)) {
            Box(contentAlignment = Alignment.Center, modifier = Modifier
                .weight(1f)
                .background(Color(0xFFB69DF8))
                .fillMaxWidth()
                .fillMaxHeight()
                .padding(16.dp))

            {
                Column() {
                    Box(contentAlignment = Alignment.Center, modifier = Modifier.fillMaxWidth()) {
                        Text(


                            text = "Text composable",

                            fontWeight = Bold,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.padding(bottom = 16.dp)
                        )
                    }


                    Text(

                        text =
                        "Displays text and follows the recommended Material Design guidelines.",
                        textAlign = TextAlign.Justify
                    )
                }




            }

            Box(contentAlignment = Alignment.Center, modifier = Modifier
                .weight(1f)
                .background(Color(0xFFF6EDFF))
                .fillMaxWidth()
                .fillMaxHeight()
                .padding(16.dp))

            {
                Column() {
                    Box(contentAlignment = Alignment.Center, modifier = Modifier.fillMaxWidth()) {
                        Text(


                            text = "Text composable",

                            fontWeight = Bold,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.padding(bottom = 16.dp)
                        )
                    }


                    Text(

                        text =
                        "Displays text and follows the recommended Material Design guidelines.",
                        textAlign = TextAlign.Justify
                    )
                }




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