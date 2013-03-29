#include "TreeNode.h"
#include <iostream>
#include <string>
#include <cstdlib> 
using namespace std;
/* methods from the .h class
 private:
    DBentry* entryPtr;
    TreeNode* left;
    TreeNode* right;
 */

// A useful constructor
// takes in a pointer to the type DBentry, this particular node has access to that DBentry
TreeNode::TreeNode(DBentry* _entryPtr){
    entryPtr = _entryPtr;
    left = NULL;
    right = NULL;
}

// the destructor
TreeNode::~TreeNode(){
    delete entryPtr;
    delete left;
    delete right;
}

// sets the left child of the TreeNode.
void TreeNode::setLeft(TreeNode* newLeft){
    left = newLeft;
}

// sets the right child of the TreeNode
void TreeNode::setRight(TreeNode* newRight){
    right = newRight;
}

// gets the left child of the TreeNode.
TreeNode* TreeNode::getLeft() const{
    return left;
}

// gets the right child of the TreeNode
TreeNode* TreeNode::getRight() const{
    return right;
}

// returns a pointer to the DBentry the TreeNode contains. 
DBentry* TreeNode::getEntry() const{
    return entryPtr; 
}

void TreeNode::remove(TreeNode *&root, string name){
    // no BST, return false
    if (root == NULL){
        return;
    }
    // name is smaller than curr's name, go left
    // send in a recursive call to the left bst
    if (name < entryPtr->getName()){
        if (left != NULL) left->remove(left, name);
        return;
    }
    // name is greater than curr's name, go right
    // send in a recursive call to the right bst
    if (name > entryPtr->getName()){
        if (right != NULL) right->remove(right, name);
        return;
    }
    // if name = curr's value, we want to delete the this pointer
    // we now consider 4 cases
    // case (1)... no leaves
    if((left == NULL) && (right == NULL)){
    // we set the pointer that points to this node to NULL
    // and delete this node
        root = NULL;
	delete this;
    }
    // Case (2)... this node only has a right subtree:
    else if((left == NULL) && (right != NULL)){
    // we modify the pointer that points to this node to point to that
    // right subtree instead and then delete this node
        root = right;
        right = NULL;
        delete this;
    }
    // Case (3)... this node only has a left subtree:
    else if((left != NULL) && (right == NULL)) {

    // we modify the pointer that points to this node to point to that
    // left subtree instead and then delete this node
       root = left;
       left = NULL;
       delete this;

    }
    // Case (4)... this node must have both a left and a right subtree:
    else{
    // we replace the value of this node with the minimum value
    // of the right subtree and delete the node with that minimum
    // value in the right subtree
        //string _name, unsigned int _IPaddress, bool _active
       DBentry* hold = new DBentry(left->maximum()->getName(), left->maximum()->getIPaddress(),left->maximum()->getActive()); 
       left->remove(left, hold->getName());
       delete entryPtr;
       entryPtr = hold;
       return;
       //root->getLeft(); // what i want to delete
       //string m = right->getEntry()->getName();
       //right->remove(right, m) ;
       //entryPtr->setName(m);
    } 
}
// gets the maximum of that treeNode
DBentry* TreeNode::maximum(){
    if (right == NULL){
        return entryPtr;
    }
    else {
        return right->maximum();
    }
}
