#include "TreeDB.h"
#include <iostream>
#include <string>
#include <cstdlib>
using namespace std;
/* methods from the .h class
 private:
   TreeNode* root;
   int probesCount;
*/

// the default constructor, creates an empty database.
TreeDB::TreeDB(){
    root = NULL;
    // sets the probesCount to 0
    probesCount = 0;
}

// the destructor, deletes all the entries in the database.
TreeDB::~TreeDB(){
    delete root;
}

// inserts the entry pointed to by newEntry into the database. 
// If an entry with the same key as newEntry's exists 
// in the database, it returns false. Otherwise, it returns true.
bool TreeDB::insert(DBentry* newEntry){
    // check to see if that exists
    string holder = newEntry->getName();
    if (recursiveFind(root, holder) == NULL){
        // first we have to create the new TreeNode type
        TreeNode *newtreeNode = new TreeNode(newEntry);
        // function will find the correct spot for the Treenode that we created using recursion
        insertTreeNode(newtreeNode);
        cout <<"Success"<<endl;
        probesCount++;
        return true;
    }
    else {
        cout <<"Error: entry already exists"<<endl;
        return false;
    }
    
}

// searches the database for an entry with a key equal to name.
// If the entry is found, a pointer to it is returned.
// If the entry is not found, the NULL pointer is returned.
// Also sets probesCount
//recursively searches for the entry desired
DBentry* TreeDB::find(string name){
    // function declared below will recursively check our BST
    DBentry *holder = recursiveFind(root, name);
    //prints out that DBentry's information, if its not NULL
    if (holder != NULL){
        holder->print();
        return holder;
    }
    else {
        cout <<"Error: entry does not exist"<<endl;
        return holder;
    }
}

//removes the node by calling the recursive remove function in TreeNode
bool TreeDB::remove(string name){
    // function to recursively check for the position of the desired node
    // and checks whether that node is in one of the 4 cases to remove
    root->remove(root, name);
    probesCount--;
}
   
// prints the number of searches before reaching that element, using recursiveFind technique
DBentry* TreeDB::printProbes(TreeNode* root, string name, int &count) const{
    // base case for the root not existing
    if (root == NULL) return NULL; 
    // whenever the root is not NULL, we know we have to do another search
    // so we increment the counter
    count++;
    // case for if it exists and the first elem in our BST is the desired
    if (root->getEntry()->getName() == name) return root->getEntry();
    // if name is larger than the name in our BST elem, send in recursively to the right
    else if (root->getEntry()->getName() < name) return printProbes(root->getRight(), name, count);
    // if name is smaller than the name in our BST elem, send in recursively to the left
    else return printProbes(root->getLeft(), name, count);
}
   
// computes and prints out the total number of active entries
// in the database (i.e. entries with active==true).
void TreeDB::countActive() const{
    int count = 0;
    recActivecount(root, count);
    //print out the counter
    cout << count << endl;
}

//recursively finds the node element we want with the given name
//returns the DBentry if found, if not returns NULL
DBentry* TreeDB::recursiveFind(TreeNode* root, string name){
    // base case for the root not existing
    if (root == NULL) return NULL; 
    // case for if it exists and the first elem in our BST is the desired
    if (root->getEntry()->getName() == name) return root->getEntry();
    // if name is larger than the name in our BST elem, send in recursively to the right
    else if (root->getEntry()->getName() < name) return recursiveFind(root->getRight(), name);
    // if name is smaller than the name in our BST elem, send in recursively to the left
    else return recursiveFind(root->getLeft(), name);
}

// inserts a TreeNode into our BST
void TreeDB::insertTreeNode(TreeNode *p){
        // Nothing to insert if the TreeNode given is NULL
       if (p == NULL) return;
       // base case for empty BST
       if (root == NULL) { 
             // assign it as the first case
             root = p;
             return;
        }
        // Helper function to facilitate the recursion
        insertBSTrecursive(p, root);
   }
   
   // recursively checks the BST and also adds the TreeNode
void TreeDB::insertBSTrecursive(TreeNode *p, TreeNode *r){
    // this check for the same key is irrelevant since I called my find function
    // but keeping it would do no harm
    if (p->getEntry()->getName() == r->getEntry()->getName()) return;
    //  if the inserting key is bigger than our curr's key... 
    if (p->getEntry()->getName() < r->getEntry()->getName()) {
        // check to see if we have another left elem in the curr's bst
         if (r->getLeft() == NULL) {
             // if not, set it's left to the TreeNode
              r->setLeft(p);
              return;
         }
         // if we do, recursive to curr's left
         else insertBSTrecursive(p, r->getLeft());
    }
    if (p->getEntry()->getName() > r->getEntry()->getName()) {
        // check to see if we have another right elem in the curr's bst
         if (r->getRight() == NULL) {
             // if not, set it's right to the TreeNode
              r->setRight(p);
              return;
          }
         // if we do, recursive to curr's right
          else (p, r->getRight());
    }
}

//prints out in preorder fashion
void TreeDB::print(TreeNode *root){
     if (root != NULL) {
         print(root->getLeft());
         if (root->getEntry()){
                root->getEntry()->print();
         }
         print(root->getRight());
     }
     return;
}

//returns the root
TreeNode* TreeDB::getRoot(){
       return root;
}

//recursive count of the status
void TreeDB::recActivecount(TreeNode *root, int &count) const{
    if (root != NULL) {
        // if that entry's activity is true, increment the counter
        if (root->getEntry()->getActive()){
            count++;
        }
        recActivecount(root->getLeft(), count);
        recActivecount(root->getRight(), count);
     }
}


