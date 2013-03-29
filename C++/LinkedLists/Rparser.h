/* 
 * File:   Rparser.h
 * Author: hossei50
 *
 * Created on November 7, 2012, 11:30 AM
 */

#ifndef RPARSER_H
#define	RPARSER_H


#include <string>
#include <iostream>
#include "Resistor.h"
#include "Node.h"
#include "NodeList.h"
#include "ResistorList.h"


// One function to parse each command
bool parse_add(stringstream& lineStream, NodeList& control);
bool parse_change (stringstream& lineStream, string *label, double *resistance, NodeList& control);
bool parse_find (stringstream& lineStream, string *label);
bool parse_list (stringstream& lineStream);
bool parse_clear (stringstream& lineStream);
bool parse_remove (stringstream& lineStream, string* label_);

// helper function declarations for main
bool doAdd(string label, double resistance, int node1, int node2, NodeList& control);
bool doChangeR(string label, double resistance, NodeList& control);
bool doFind(string label, NodeList& control);
void doListall(NodeList& control);
void doClearall(NodeList& control);
void doRemove(NodeList& control, string label);
int getIndexfromResIdarray(string label, double resistance, int position);
double getResistancefromresArray(string label);


// Helper functions to parse and print error messages for each 
// type of argument
bool getNode (stringstream& lineStream, int& nodde);
bool getResistance (stringstream& lineStream, double& resistance);
bool getStringArg (stringstream& lineStream, string& argument);
bool checkKeyword (stringstream& lineStream, string keyword);
bool checkNoExtraArgs (stringstream& lineStream);



#endif	/* RPARSER_H */

