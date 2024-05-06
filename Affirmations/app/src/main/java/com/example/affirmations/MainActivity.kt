package com.example.affirmations

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.example.affirmations.ui.theme.AffirmationsTheme
import com.example.affirmations.model.Affirmation
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import javax.sql.DataSource
import com.example.affirmations.data.Datasource

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AffirmationsTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    AffirmationsApp()
                }
            }
        }
    }
}

@Composable
fun MainPage(modifier: Modifier = Modifier) {

}

@Preview(showBackground = true,
    showSystemUi = true,
    name = "My Preview")
@Composable
fun AffirmationsPreview() {
    AffirmationsTheme {
        MainPage()
    }
}
@Composable
fun AffirmationsApp()
{
    AffirmationList(
        affirmationList = Datasource().loadAffirmations()
    )
}
@Composable
fun AffirmationCard((affirmation: Affirmation, modifier: Modifier = Modifier)
{
    val showPop = remember { mutableStateOf(false) }
    if (showPop.value == true) {
        PopUp()
    } else {
        ShowBasic()
    }
}

@Composable
fun AffirmationList(affirmationList: List<Affirmation>,modifier: Modifier = Modifier)
{
    LazyColumn(modifier = modifier)
    {
        items(affirmationList)
        {
            affirmation->
            AffirmationCard(
                affirmation = affirmation,
                modifier = Modifier.padding(8.dp)
            )
        }
    }
}
@Preview
@Composable
private fun AffirmationCardPreview()
{
    AffirmationCard(Affirmation(R.string.affirmation1,R.drawable.image1))
}
