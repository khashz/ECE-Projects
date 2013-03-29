/* 
 * File:   Resistor.h
 * Author: hossei50
 *
 * Created on November 7, 2012, 11:29 AM
 */

#ifndef RESISTOR_H
#define	RESISTOR_H

#include <string>
#include <iostream>
using namespace std;

class Resistor
{
private:
    double resistance; // resistance (in Ohms)
    string name; // C++ string holding the label
    int endpointNodeIDs[2]; // IDs of nodes it attaches to
    Resistor* next;
  
public:
    // initial constructor so it doesnt stop the allocation of the array
    Resistor(string _name,double _resistance,int _endpoints[2]);
    // endpoints_ holds the node indices to which this resistor connects
    
    ~Resistor();
    
    // returns the name of the resistor
    Resistor* getNext();
    
    // sets the next value of the resistor
    void setNext(Resistor* nr);
    
    // returns the name
    string getName(); 
    
    // returns the resistance
    double getResistance(); 
    
    //sets the name of the resistor
    void setName(string name_);
    
    void setResistance (double resistance_);
    
    // you *may* create either of the below to print your resistor
    void printRes();
    void specialprint(); 
    friend ostream& operator<<(ostream&,const Resistor&);
};

ostream& operator<<(ostream&,const Resistor&);

#endif	/* RESISTOR_H */

