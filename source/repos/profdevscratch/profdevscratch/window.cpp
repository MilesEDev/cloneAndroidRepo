#include "window.h"
#include "SDL.h"
#include <string>
window::window(){

	mywindow = SDL_CreateWindow("", 500,50,800,500,SDL_WINDOW_SHOWN||SDL_WINDOW_OPENGL);
	size = std::make_pair(800, 500);
	pos = std::make_pair(500, 50);
	title = "";
}

window::window(int xsize, int ysize)
{
	
	mywindow = SDL_CreateWindow("", 500, 50, xsize, ysize, SDL_WINDOW_SHOWN || SDL_WINDOW_OPENGL);
	size = std::make_pair(xsize, ysize);
	pos = std::make_pair(500, 50);
	title = "";
}

window::window(int xsize, int ysize,std::string title) 
{
	mywindow =SDL_CreateWindow(title.c_str(), 500, 50, xsize, ysize, SDL_WINDOW_SHOWN || SDL_WINDOW_OPENGL);
	size = std::make_pair(xsize, ysize);
	pos = std::make_pair(500, 50);
	this->title = title;
}

window::window(int xsize, int ysize, int xpos, int ypos,std::string title)
{
	mywindow = SDL_CreateWindow(title.c_str(), xpos, ypos, xsize, ysize, SDL_WINDOW_SHOWN || SDL_WINDOW_OPENGL);
	size = std::make_pair(xsize, ysize);
	pos = std::make_pair(xpos, ypos);
	this->title = title;
}

void window::setSize(int x, int y)
{
	SDL_SetWindowSize(mywindow, x, y);
}

void window::setPos(int x, int y)
{
	SDL_SetWindowPosition(mywindow, x, y);
}

std::pair<int, int> window::getWindowPos() 
{
	return pos;
}
std::pair<int, int> window::getWindowSize() 
{
	return size;
}
std::string window::getTitle() 
{
	return title;
}
void window::setTitle(std::string newTitle) 
{
	title = newTitle;

}
SDL_Window* window::getSDLWindow()
{

	return mywindow;
}



