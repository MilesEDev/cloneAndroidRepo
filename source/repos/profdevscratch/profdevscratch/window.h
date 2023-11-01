#pragma once
#include <utility>      
#include <string>       
#include <iostream>     

#include "SDL.h"

class window {
private:
	SDL_Window* mywindow;
	std::pair<int, int> size;
	std::pair<int, int> pos; 
	std::string title;

public:
	/**
	 * .creates window through constructor when given no arguments sets default pos to 500 50
	 * sets size to 800 500 and sets up window with a blank title
	 * 
	 */
	window();
	/**
	 * takes 2 variables as x and y size and than sets a default pos for window and title as 500 50 for pos and blank title for title
	 * 
	 * \param x
	 * \param y
	 */
	window(int xsize, int ysize);
	/**
	 * .the window takes x and y size and title and uses it to create a window and than sets a default pos at 500 50 
	 * 
	 * \param xsize
	 * \param ysize
	 * \param title
	 */
	window(int xsize, int ysize,std::string title);
	/**
	 * 
	 * .the window takes in all the arguments needed to create an SDL window and than creates a window with these parameters 
	 * adding also
	 * the window shown flag
	 * 
	 * \param xpos
	 * \param ypos
	 * \param xsize
	 * \param ysize
	 * \param title
	 */
	window(int xpos, int ypos,int xsize,int ysize,std::string title);
	/**
	 * 
	 * .takes in arguments x and y to to resize window
	 * 
	 * \param x x size of window
	 * \param y y size of window
	 */
	void setSize(int x, int y);
	/**
	 * .getter method to return window size
	 * 
	 * \return size of window
	 */
    std::pair<int, int> getWindowSize();
	
	/**
	 * getter method to return window position
	 * 
	 * \return position of window
	 */
	std::pair<int, int> getWindowPos(); 
	/**
	 * 
	 * .setter method to change position of window
	 * 
	 * \param x the x position of window
	 * \param y the y position of window 
	 */
	void setPos(int x, int y);

	/**
	 * 
	 * . returns the title of the window 
	 */
	std::string getTitle();
	/**
	 * 
	 * . sets a new title for the window
	 * 
	 * \param the newtitle to change to  
	 */
	void setTitle(std::string newtitle);
	/**
	 * 
	 * .returns the sdl window poninter
	 * 
	 * \return the sdl window pointer 
	 */
	SDL_Window* getSDLWindow();
	
	
	






};
