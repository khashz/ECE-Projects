/* 
 * File:   Node.h
 * Author: hossei50
 *
 * Created on November 7, 2012, 11:28 AM
 */

#ifndef NODE_H
#define	NODE_H


#include "ResistorList.h"
#include "Resistor.h"
#define MAX_RESISTORS_PER_NODE 5
#define MAX_RESISTORS 20
#define MAX_NODE_NUMBER 9
#define MAX_RESISTOR_NAME_LEN 20

class Node
{
private:
    
    // nodeID of this individual node
    int nodeID; 
    
    // Resistor class
    Resistor *head;
      
    //points to the next node in the linked list
    Node *next;
    
    
    
    //total resistors in the node
    int numRes;
    
public:
    //Constructors
    Node();
    Node(int);
    Node(int, Node* np);
    
    //Deconstructor
    ~Node();
    
    //returns the next value in the linked list
    Node* getNext();
    
    //sets the next Node* in the node linked list
    void setNext(Node* nN);
    
    //pointer to our resistor linked list
    Resistor* getRes();
    
    Resistor* findResistor(string Label);
    
    //insert resistor
    void insertRes(string _name,double _resistance,int _endpoints[2]);

    //search and change
    bool searchResistorandChange(string Label, double _resistance);
    
    //returns the ResistorList array
    ResistorList& retResist();
    
    //prints out all the resistors in the linked list of the node
    void printR() const;
    
    //updates the nodeID
    void updateNodeID(int );
    
    //returns the nodeID of that node
    int getNodeID();
    
    //returns the number of resistor in the Resistors in the node
    int getnumRes();
    
    //returns the number of resistor in the Resistors in the node
    void updatenumRes();
    
    void decnumRes();
    
    // prints the whole node
    // nodeIndex is the position of this node in the node array.
    void print() const;
    
};

#endif	/* NODE_H */

