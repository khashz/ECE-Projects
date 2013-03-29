/* 
 * File:   TreeDB.h
 * Author: hossei50
 *
 * Created on November 17, 2012, 5:56 PM
 */

#ifndef TREEDB_H
#define	TREEDB_H


#include "TreeNode.h"
#include "DBentry.h"

class TreeDB {

private:
   TreeNode* root;
   int probesCount;

public:
   // the default constructor, creates an empty database.
   TreeDB();

   // the destructor, deletes all the entries in the database.
   ~TreeDB();

   // inserts the entry pointed to by newEntry into the database. 
   // If an entry with the same key as newEntry's exists 
   bool insert(DBentry* newEntry); 

   // searches the database for an entry with a key equal to name.
   // If the entry is found, a pointer to it is returned.
   // If the entry is not found, the NULL pointer is returned.
   // Also sets probesCount
   DBentry* find(string name);

   // deletes the entry with the specified name (key)  from the database.
   // If the entry was indeed in the database, it returns true.
   // Returns false otherwise.
   // See section 6 of the lab handout for the *required* removal method.
   // If you do not use that removal method (replace deleted node by
   // maximum node in the left subtree when the deleted node has two children)
   // you will not match exercise's output.
   bool remove(string name);
	
   // deletes all the entries in the database.
   void clear(TreeNode *root);
    
   // prints the number of probes stored in probesCount
   DBentry* printProbes(TreeNode* root, string name, int &count) const;
   
   // computes and prints out the total number of active entries
   // in the database (i.e. entries with active==true), using recursion
   void countActive () const;

   // Prints the entire tree, in ascending order of key/name
   //friend ostream& operator<< (ostream& out, const TreeDB& rhs);

   /*
        ############   additional functions that I created #############
   */
   
   //recursively finds the node element we want with the given name
   //returns the DBentry if found, if not returns NULL
   DBentry* recursiveFind(TreeNode *root, string name);
   
   // inserts a TreeNode into our BST
   void insertTreeNode(TreeNode *p);
   
   // recursively checks the BST and also adds the TreeNode
   void insertBSTrecursive(TreeNode *p, TreeNode *r);
   
   //prints out in preorder fashion
   void print(TreeNode *root);
   
   //returns the TreeNode
   TreeNode* getRoot();
   
   //recursive count of the status
   void recActivecount(TreeNode *root, int &count) const;
}; 

// You *may* choose to implement the function below to help print the 
// tree.  You do not have to implement this function if you do not wish to.
ostream& operator<< (ostream& out, TreeNode* rhs);   

#endif	/* TREEDB_H */

