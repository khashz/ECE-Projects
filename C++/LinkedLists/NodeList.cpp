
#include <iostream>
#include <string>
#include "Node.h"
#include "NodeList.h"
#include "ResistorList.h"
using namespace std;


// default constructor
NodeList::NodeList() {
    head = NULL;
}

// deconstructor will delete head
NodeList::~NodeList() {
    delete head;
    head = NULL;
}

//accepts a node ID and returns a pointer to the corresponding Node, or Null if it does not exist
Node* NodeList::findNode(int Nid) {
    Node* p = head;
    while (p != NULL){
        //if it finds it
        if (p->getNodeID() == Nid){
            return p;
        }
        p = p->getNext();
    }
    return NULL;
}

// insert a resistor into the the node, parameters nodeID and resistor info
Node* NodeList::makeNode(int nodeID){
    // if the header is null
    if (head == NULL){
        head = new Node(nodeID);
        return head;
    }
    else{ //if head is not null
        Node* checker = head;
        while (checker != NULL){
            if (checker->getNodeID() == nodeID){
                return checker;
            }
            checker = checker->getNext();
        }
            Node* point = head;
            Node* prevp = NULL;
            while (point != NULL && (point->getNodeID() < nodeID)){
                  prevp = point;
                  point = point->getNext();
            }
            if (prevp == NULL){ // if our node is smaller than first node entered
                head = new Node(nodeID, point);
                return head;
            }
            else if (point != NULL && prevp != NULL){ // if our node to be inserted is in the middle
                prevp->setNext(new Node(nodeID,point));
                return (prevp->getNext());
            }
            else { // Node at the end
                Node* n = new Node(nodeID);
                prevp->setNext(n);
                return n;
            } 
   }
}

//change the resistance of a resistor by name (or return failure)
bool NodeList::changeResist(string _label, double _resistance, double & old_res){
    Node* p = head;
    
    
    if (p== NULL) return false;
    if (p->getRes() == NULL) return false;
    
    old_res = head->getRes()->getResistance();
    int counter = 0;
    //goes through every node
    while (p != NULL){
        
        //accesses the ResistorList
            //checks the entire resistor list
        if(p->searchResistorandChange(_label, _resistance) && counter != 2){
            //return true if it was able to change
            counter++;
         }
        else {
              //advances to the next node
              p = p->getNext();
        }
    }
    //if failed
    if (counter == 2) return true;
    else return false;
}

//finds the resistor with the given name
bool NodeList::findResis(string label){
    Node* p = head;
        while (p != NULL){
            if (p->findResistor(label) != NULL){
                return true;
            }
            else {
                p = p->getNext();
            }
        }
    return false;
}

                
// prints all the nodes and resistors
void NodeList::print() const{
    Node* p = head;
    while ( p!= NULL){
        // goes and prints out all the resistors inside the node
        p->print(); // node form
        p->printR(); // goes and prints all the resistors in the node
        // implements the node
        p = p->getNext();
    }
}

bool NodeList::getPoints(Node*& node1, Resistor*& prev1, Resistor*& that1, Node*& node2, Resistor*& prev2, Resistor*& that2, string& label){
    Node* nde = head;
    int i = 0;
    // loop through all the nodes
    while (nde != NULL){
        Resistor *res = nde->getRes();
        Resistor *prevp = NULL; 
        while (res != NULL){
            // check through the resistor list in that node for the target resistance
            
            if (res->getName() == label && i == 1){
                that2 = res;
                prev2 = prevp;
                node2 = nde;
                i++;
                return true;
            }
            
            if (res->getName() == label && i != 1){
                that1 = res;
                prev1 = prevp;
                node1 = nde;
                i++; 
            }
            prevp = res;
            res = res->getNext();
        }
        nde = nde->getNext();
    }
    return false;
}

//delete all the nodes in the list
void NodeList::deleteAllnodes(){
    delete head;
}

Node* NodeList::retHead(){
    return head;
}
