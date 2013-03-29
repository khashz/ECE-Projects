#include "Resistor.h"
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <string>

using namespace std;
// rIndex_ is the index of this resistor in the resistor array
// endpoints_ holds the node indices to which this resistor connects
//CONSTRUCTOR FOR CLASS RESISTOR
Resistor::Resistor(string _name,double _resistance,int _endpoints[2]){
    resistance = _resistance;
    name = _name;
    endpointNodeIDs[0] = _endpoints[0];
    endpointNodeIDs[1] = _endpoints[1];
    next = NULL;
}


// returns the name of the resistor
Resistor* Resistor::getNext(){
    return next;
}

// sets the next value of the resistor
void Resistor::setNext(Resistor* nr){
    next = nr;
}

// returns the name
string Resistor::getName(){
    return name;
}
// returns the resistance
double Resistor::getResistance(){
    return resistance;
}
//sets the resistance of the node
void Resistor::setResistance (double resistance_){
    resistance = resistance_;
}

//prints the resistor for the case of 2 spaces before the name
void Resistor::printRes(){
    cout << "  " << left << setfill (' ') << setw (20) << name << " ";
    cout << right << setfill (' ') << setw (7) << resistance << " Ohms ";
    cout << endpointNodeIDs[0] << " -> " << endpointNodeIDs[1] << endl;
}

//prints the resistor for the case of 1 space before the name
void Resistor::specialprint(){
    cout << " " << left << setfill (' ') << setw (20) << name << " ";
    cout << right << setfill (' ') << setw (7) << resistance << " Ohms ";
    cout << endpointNodeIDs[0] << " -> " << endpointNodeIDs[1] << endl;
}

//sets the name of the resistor
void Resistor:: setName(string name_){
    name = name_;
}


//DESTRUCTOR FOR CLASS RESISTOR
Resistor::~Resistor(){
    delete next;
    next = NULL;
}