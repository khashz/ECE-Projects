/* 
 * File:   NodeList.h
 * Author: hossei50
 *
 * Created on November 7, 2012, 11:31 AM
 */

#ifndef NODELIST_H
#define	NODELIST_H

#include <string>
#include <iostream>
#include "Node.h"
#include "Resistor.h"

class NodeList {
private:
    Node* head ;  
     
public:
        
    // default constructor
    NodeList();
    
    // deconstructor will delete head
    ~NodeList() ;
    
    //accepts a node ID and returns a pointer to the corresponding Node, or Null if it does not exist
    Node* findNode(int Nid) ;
    
    // checks to see if that resistor exists
    bool findResis(string label);
    
    // insert a resistor into the the node, parameters nodeID and resistor info
    Node* makeNode(int nodeID);
    
    //determine if a resistor with a given label exists in any of the nodes
    bool searchNode( string  ) ;
    
    //change the resistance of a resistor by name (or return failure)
    bool changeResist(string _label, double resistance, double & old_res);
    
    // prints all the nodes and resistors
    void print() const;
    
    bool getPoints(Node*& node1, Resistor*& prev1, Resistor*& that1, Node*& node2, Resistor*& prev2, Resistor*& that2, string& label);
    
    // delete a resistor by name (or return failure)
    void delthis(string label);
           
    //delete all the nodes in the list
    void deleteAllnodes();

    Node* retHead();
    
} ;



#endif	/* NODELIST_H */

