#pragma once
#include <utility>      
#include <string>       
#include <iostream>     
#include "Render.h"


Render::Render()
{
	penStartCordinate = std::make_pair(0.0f, 0.0f);
	
}

Render::Render(float x, float y)
{
	penStartCordinate = std::make_pair(x, y);
}
Render::Render(float x, float y, window* mywindow)
{
	penStartCordinate = std::make_pair(x, y);
	canvas = mywindow->getSDLWindow();
	myrenderer = SDL_CreateRenderer(canvas, 3, 0);
}
Render::Render(window* mywindow) 
{
	penStartCordinate = std::make_pair(0.0f, 0.0f);
	canvas = mywindow->getSDLWindow();
	myrenderer = SDL_CreateRenderer(canvas, 3, 0); 
}

void Render::linkToWindow(window* mywindow) 
{
	canvas = mywindow->getSDLWindow();
	myrenderer = SDL_CreateRenderer(canvas, 3, 0);
}
void Render::setPen(float x, float y)
{
	penStartCordinate.first = x;
	penStartCordinate.second = y;
}













