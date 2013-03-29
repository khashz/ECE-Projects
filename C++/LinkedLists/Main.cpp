/*
 * File:   Main.cpp
 * Author: hossei50
 * Khashayar Hosseinzadeh
 * Student Number: 998892266
 *
 */
#include <iostream>
#include <sstream>
#include <string>
#include <cstdlib>
#include "Rparser.h"
#include "Resistor.h"
#include "Node.h"
#include "NodeList.h"
#include "ResistorList.h"
using namespace std;
#define MAX_NODE_NUMBER 9                // max node id

int main(int argc, char** argv) {

    NodeList control;

    string line, command;
    // Set output format for double numbers; fixed point, with 1 decimal place
    cout.precision(1);
    cout.setf(ios::fixed);

    // Get first set of input, and if not EOF, start parsing it.
    // Keep parsing until EOF.

    cout << "> ";         // Prompt for input
    getline (cin, line);  // Get a line from standard input
    while ( !cin.eof () ) {
        // cout << line << endl;       // Uncomment to make sample session output.

        // Put the line in a linestream for parsing
        // Making a new sstream for each line so flags etc. are in a known state
        stringstream lineStream (line);
        lineStream >> command;

        if (lineStream.fail ()) {
            // No command entered. We'll call that unknown command.
            cout << "Error: unknown command\n";
        }
        else if (command == "add") {
            // performs the add by calling the helper function
            parse_add(lineStream, control);

        }
        else if (command == "changeR") {
            string label;
            double resistance;
            // if a successful input was read
            if (parse_change (lineStream, &label, &resistance, control)){
                doChangeR(label, resistance, control);
            }
        }
        else if (command == "find") {
            string label;
            if (parse_find (lineStream, &label)){
                doFind(label, control);
            }
        }
        else if (command == "list") {
            if (parse_list (lineStream)){
                doListall(control);
            }
        }
        else if (command == "clear") {
            if (parse_clear (lineStream)){
                doClearall(control);
            }
        }
        else if (command == "remove") {
            string label;
            if (parse_remove(lineStream, &label)){
                doRemove(control, label);
            }
        }
        else {
            cout << "Error: unknown command\n";
        }
        cout << "> ";          // Prompt for input
        getline (cin, line);
    }  // End input loop until EOF.

    return 0;
}

/*

 HELPER FUNCTIONS

 */


// doAdd function - adds a new resistor with the given information
// and connects it to the specified nodes
bool doAdd(string label, double resistance, int node1, int node2, NodeList& control){
    int nodeIdArray[2];
    nodeIdArray[0] = node1;
    nodeIdArray[1] = node2;
    if (node1 != node2){
        if (control.findResis(label)){
            cout << "Error: resistor " << label << " already exists" <<endl;
            return false;
        }
        Node* p1 = control.makeNode(node1);
        Node* p2 = control.makeNode(node2);
        
        p1->insertRes(label, resistance, nodeIdArray);
        p2->insertRes(label, resistance, nodeIdArray);
        //update the resistor count inside the node list
        p1->updatenumRes();
        p2->updatenumRes();
        return true;
    }
    else {
        cout << "Error: cannot connect a node to itself" <<endl;
        return false;
    }
    
}

// doChangeR - changes the resistance of the named resistor to the newly-specified R,
// prints an error if resistor cannot be found
// returns true or false if successful or not
bool doChangeR(string label, double resistance, NodeList& control){
    // get the old_res value
    double old_res;
    if (control.changeResist(label, resistance, old_res)){
        cout << "Changed: resistor " << label << " from " << old_res << " Ohms to " << resistance << " Ohms" <<endl;
        return true;
    }
    else {
        cout << "resistor " << label << " cannot be found" <<endl;
        return false;
    }
    
}


// doFind - finds a resistor and prints out its information
// returns true or false if it can be found
bool doFind(string label, NodeList& control){
    Node* node = control.retHead();
    while (node != NULL){
        Resistor* res = node->getRes();
        while (res != NULL){
            if (res->getName() == label){
                cout << "Found:"; 
                res->specialprint();
                return true;
            }
            res = res->getNext();
        }
        node = node->getNext();
    }
    cout << "Error: resistor " << label << " cannot be found"<<endl;
    return false;
 }
    
  
// doListall function - lists all nodes with their attached resistors
void doListall (NodeList& control){
    Node* node = control.retHead();
    while (node != NULL){
        node->print();
        Resistor* res = node->getRes();
        while (res != NULL){
            res->printRes();
            res = res->getNext();
        }
        node = node->getNext();
    }
 }
//doClearall function, clears all the information to its initial state
void doClearall (NodeList& control){
    Node *temp1 = (control.retHead());
    Node *temp2 = NULL;
    // loop through nodes
    if(control.retHead() == NULL){
        return;
    }
    while (temp1 != NULL){
        Resistor *remp1 = control.retHead()->getRes();
        Resistor *remp2 = NULL;
        // loop through resistors
        while (remp1 != NULL){
            remp2 = remp1;
            remp1 = remp1->getNext();
            delete remp2;
        }
        temp2 = temp1;
        temp1 = temp1->getNext();
        delete temp2;
    }   
}

void doRemove(NodeList& control, string label){
    Resistor* prev1;
    Resistor* prev2;
    Resistor* that1;
    Resistor* that2;
    Node* node1;
    Node* node2;
    // this function basically returns the node, the previous resistor pointer and the resistor pointer that the target is in
    // so for target 1:   its in Node 1..... prevp -> that1(target)
    // so each case has a different implementation, depending on the location of the target resistance
    if(control.getPoints(node1, prev1, that1, node2, prev2, that2, label)){
        cout<<"Removed: resistor " << label<<endl;
    }
    else {
        cout << "Error: resistor " <<label<< " cannot be found"<<endl;
        return;
    }
    // if the 
    if (prev1 == NULL){
        Resistor* res = node1->getRes();
        res = res->getNext();
        if (that1 == NULL) return;
        delete that1;
        node1->decnumRes();
    } 
    else if (prev1 != NULL){
        prev1->setNext(that1->getNext());
        if (that1 == NULL) return;
        delete that1;
        node1->decnumRes();
    }
    if (prev2 == NULL){
        Resistor* res1 = node1->getRes();
        res1 = res1->getNext();
        if (that2 == NULL) return;
        delete that2;
        node2->decnumRes();
    }
    else if (prev2 == NULL){
        prev2->setNext(that2->getNext());
        if (that2 == NULL) return;
        delete that2;
        node2->decnumRes();
    }
}