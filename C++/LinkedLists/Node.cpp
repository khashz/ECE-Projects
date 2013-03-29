#include <cstdlib>
#include <iostream>
#include "Node.h"
#include "Resistor.h"
#include "ResistorList.h"


//CONSTRUCTOR FOR CLASS NODE
Node:: Node(){
    numRes = 0; 
    nodeID = 0;
    next = NULL;
}

//CONSTRUCTOR FOR CLASS NODE
 Node :: Node(int id){
        numRes = 0; 
        nodeID = id;
        next = NULL;
}
 
 //CONSTRUCTOR FOR CLASS NODE
 Node :: Node(int id, Node* np){
        numRes = 0; 
        nodeID = id;
        next = np;
 }

//returns the next value in the linked list
Node* Node::getNext(){
    return next;
}

//sets the next Node* in the node linked list
    void Node::setNext(Node* nN){
        next = nN;
    }

//returns the next value in the linked list
 Resistor* Node::getRes(){
     return head;
 }

 //insert a resistor at the end of the list
void Node::insertRes(string _name,double _resistance,int _endpoints[2]){
    // now we either have p pointing to the node that already exists, or false if that doesnt exist
    // if it isnt NULL, resistor with that value exists
    if (head == NULL){
        head = new Resistor(_name, _resistance, _endpoints);
        }
    else { //header is not null
        Resistor* pointer = head;

        while(pointer->getNext() != NULL){
            pointer = pointer->getNext();
        }
        //create the new Resistor
        //set the last element in our current list's next equal to n, the new resistor
        pointer->setNext(new Resistor(_name, _resistance, _endpoints));
    }   
}

Resistor* Node::findResistor(string Label){
    Resistor *p = head;
    while (p != NULL){
        //if it finds it
        if (p->getName() == Label){
            //return a pointer to the resistor if it was found
            return p;
        }
        p = p->getNext();
    }
    //return null if not found
    return NULL;
}

bool Node::searchResistorandChange(string Label, double _resistance) {
    Resistor *p = head;
    while (p != NULL){
        //if it finds it
        if (p->getName() == Label){
            p->setResistance(_resistance);
            return true;
        }
        p = p->getNext();
    }
    return false;
}
 
//prints out the resistor information
void Node::printR() const{
    Resistor *p = head;
    while (p != NULL){
        p->printRes();
        p = p->getNext();
    }
}

//updates the nodeID
void Node::updateNodeID(int newID){
    nodeID = newID;
}

//returns the number for resistors inside the node
int Node::getNodeID(){
    return nodeID;  
}

//returns the number of resistor in the Resistors in the node
int Node::getnumRes(){
    return numRes;
}

//updates numRes
void Node::updatenumRes(){
     numRes++;
}

//updates numRes
void Node::decnumRes(){
     numRes--;
}

// prints the whole node
// nodeIndex is the position of this node in the node array.
void Node::print() const{
    if (this != NULL){
    cout << "Connections at node " << nodeID << ":  " << numRes << " resistor(s)" << endl;
    }
}


//DESTRUCTOR FOR CLASS NODE
Node :: ~Node(){
    delete head;
    head = NULL;
    delete next;
    next = NULL;
}
