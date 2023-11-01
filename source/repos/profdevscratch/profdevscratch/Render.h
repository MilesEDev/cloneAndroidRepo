#pragma once
#include <utility>      
#include <string>       
#include <iostream>     

#include "window.h"
#include "SDL.h"

class Render
{
private:

	std::pair<float, float> penStartCordinate;
	bool fill = false;
	SDL_Window* canvas; 
	SDL_Renderer* myrenderer;
	
public:
	/**
	 * .blank constructor generates a default window and default positions for pen 
	 * 
	 */
	Render();
	/**
	* this is the constrctor for creating a renderer with user positions
	*
	* \param x this is used as x position for cordinate of pen
	* \param y this is used as y position for cordinate of pen
	*/
	Render(float x, float y);
	Render(float x, float y, window* mywindow );
	Render(window* mywindow);
	/**
	*
	* .sets the positon of the pen with provided x and y cordinates
	*
	* \param x the x cordinate of where the pen should be
	* \param y the y cordinate of where the pen should be
	*/
	void setPen(float x, float y);

	void drawTo(float x, float y);

	void linkToWindow(window* mywindow);
};

