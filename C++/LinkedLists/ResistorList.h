/* 
 * File:   ResistorList.h
 * Author: hossei50
 *
 * Created on November 7, 2012, 11:30 AM
 */

#ifndef RESISTORLIST_H
#define	RESISTORLIST_H

#include "Resistor.h" 
#include <iostream>
#include <string>

class ResistorList{   // simple linked list node
        Resistor* header; 
public:
        
    ResistorList(){
        header = NULL;
    }
    ~ResistorList();
     
    //return list
    Resistor* getHead();
      
} ;

#endif	/* RESISTORLIST_H */

