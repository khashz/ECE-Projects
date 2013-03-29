#include <iostream>
#include <cmath>
#include "easygl.h"
#include "Rectangle.h"
#include <stdio.h>
#include <stdlib.h>
using namespace std;


// Constructor. set up base class (Shape) and initialize rect's variables
Rectangle:: Rectangle (string _name, string _colour, float _xcen, float _ycen, float _width, float _height) 
              : Shape (_name, _colour, _xcen, _ycen) {
    width = _width;
    height = _height;
}


Rectangle::~Rectangle () {
   // No dynamic memory to delete
}


void Rectangle::print () const {
   Shape::print();
   // add the specific print command
   cout << "width: " << width << " height: " << height<<endl;  
}

// multiply the shape's parameters with the scaling factor
void Rectangle::scale (float scaleFac) {
      width *= scaleFac;
      height *= scaleFac;
}
   
// area * height
float Rectangle::computeArea () const {
   // width * height
   return (width * height);
}

// 2w + 2l = perimeter 
float Rectangle::computePerimeter () const {
   return ((2*width) + (2*height));
}

// draw the rectangle
void Rectangle::draw (easygl* window) const {
    // instantiates the vertices
    float xleft = getXcen() - (width/2);
    float xright = getXcen() + (width/2);
    float ybottom = getYcen() - (height/2);
    float ytop = getYcen() + (height/2);
    
   window->gl_setcolor(getColour());
   window->gl_fillrect(xleft, ybottom, xright, ytop);
}


bool Rectangle::pointInside (float x, float y) const {
   // shift center
   t_point click;
   click.x = x - getXcen();
   click.y = y - getYcen();
   // check for x bound inside the rectangle
   if (abs(x-getXcen()) >= 0.5*(width)) return false;
   // check for y bound inside the rectangle
   else if (abs(y-getYcen()) >= 0.5*(height)) return false;
   else return true;
}


