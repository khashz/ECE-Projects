#include <iostream>
#include <string>
#include "NodeList.h"
#include "ResistorList.h"
#include "Resistor.h"
using namespace std;

//accepts a name of a resistor and checks if it is already there
 ResistorList::~ResistorList(){
     
 }

//return list
Resistor* ResistorList::getHead(){
    return header;
}
