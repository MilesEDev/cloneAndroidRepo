package com.example.affirmations

import android.os.Bundle
import android.widget.Toast
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
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.window.Dialog
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


    @Composable
    fun MainPage(modifier: Modifier = Modifier) {

    }

    @Preview(
        showBackground = true,
        showSystemUi = true,
        name = "My Preview"
    )
    @Composable
    fun AffirmationsPreview() {
        AffirmationsTheme {
            MainPage()
        }
    }

    @Composable
    fun AffirmationsApp() {
        AffirmationList(
            affirmationList = Datasource().loadAffirmations()
        )
    }

    fun changeShowVar(showPop: Boolean): Boolean {
        if (showPop == true) {
            return false;
        } else {
            return true;
        }


    }

    @Composable
    fun PopUp(
        affirmation: Affirmation,
        modifier: Modifier = Modifier,
        showPop: MutableState<Boolean>
    ) {
        val text = stringResource(affirmation.stringResourceID)
        val duration = Toast.LENGTH_SHORT

        val toast = Toast.makeText(this, text, duration) // in Activity
        Dialog(onDismissRequest = {})
        {
            ShowBasic(affirmation, modifier, showPop)
            toast.show()
        }
    }


    @Composable
    @OptIn(ExperimentalMaterial3Api::class)
    fun ShowBasic(
        affirmation: Affirmation,
        modifier: Modifier = Modifier,
        showPop: MutableState<Boolean>
    ) {

        Card(modifier = modifier, onClick = { showPop.value = changeShowVar(showPop.value) })
        {
            Column {
                Image(
                    painter = painterResource(affirmation.imageResourceID),
                    contentDescription = stringResource(affirmation.stringResourceID),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(194.dp),
                    contentScale = ContentScale.Crop


                )
                Text(
                    text = LocalContext.current.getString(affirmation.stringResourceID),
                    modifier = Modifier.padding(15.dp),
                    style = MaterialTheme.typography.headlineSmall
                )

            }

        }


    }

    @Composable
    fun AffirmationCard(affirmation: Affirmation, modifier: Modifier = Modifier) {
        val showPop = remember { mutableStateOf(false) }
        if (showPop.value == true) {
            PopUp(affirmation, modifier, showPop)
        } else {
            ShowBasic(affirmation = affirmation, modifier, showPop)
        }

    }

    @Composable
    fun AffirmationList(affirmationList: List<Affirmation>, modifier: Modifier = Modifier) {
        LazyColumn(modifier = modifier)
        {
            items(affirmationList)
            { affirmation ->
                AffirmationCard(
                    affirmation = affirmation,
                    modifier = Modifier.padding(8.dp)
                )
            }
        }
    }

    @Preview
    @Composable
    private fun AffirmationCardPreview() {
        AffirmationCard(Affirmation(R.string.affirmation1, R.drawable.image1))
    }
}