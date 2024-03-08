package com.example.marsphotos.network
import retrofit2.Retrofit
import retrofit2.converter.scalars.ScalarsConverterFactory

private const val BASE_URL =
    "https://android-kotlin-fun-mars-server.appspot.com"

private val retrofit = Retrofit.Builder()
    .addConverterFactory(ScalarsConverterFactory.create())
    .baseUrl(BASE_URL)
    .build()

object MarsAPI
{

    val retrofitService: MarsApiService by lazy{
        retrofit.create(MarsApiService::class.java)
    }

}


interface MarsApiService
{
    @GET("photos")
    suspend fun getPhotos():String

}


