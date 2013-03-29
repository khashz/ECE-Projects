#include <iostream>
#include <cmath>
#include "easygl.h"
#include "Circle.h"
#include <stdio.h>
#include <stdlib.h>
using namespace std;


// Constructor. set up base class (Shape) and initialize rect's variables
Circle:: Circle (string _name, string _colour, float _xcen, float _ycen, float _radius) 
              : Shape (_name, _colour, _xcen, _ycen) {
    radius = _radius;
}


Circle::~Circle () {
   // No dynamic memory to delete
}


void Circle::print () const {
   Shape::print();
   // add the specific print command
   cout << "radius: " << radius <<endl;  
}

// multiply the shape's parameters with the scaling factor
void Circle::scale (float scaleFac) {
      radius *= scaleFac;
}
   
// pi r squared, area of a circle
float Circle::computeArea () const {
   // width * height
   return (PI * radius * radius);
}

// 2 pi r
float Circle::computePerimeter () const {
   return (2 * PI * radius);
}

// // draw the circle 
void Circle::draw (easygl* window) const {;
   window->gl_setcolor(getColour());
   window->gl_fillarc(getXcen(), getYcen(), radius, 0, 360);
}


bool Circle::pointInside (float x, float y) const {
    // shift center
   t_point click;
   click.x = x - getXcen();
   click.y = y - getYcen();
   
   // test whether the point lies inside the circle
   if (((x-getXcen())*(x-getXcen()) + (y-getYcen())*(y-getYcen())) > (radius*radius)) return false;
   // else true
   else return true;
}

