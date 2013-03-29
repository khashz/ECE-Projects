/* 
 * File:   TreeNode.h
 * Author: hossei50
 *
 * Created on November 17, 2012, 5:56 PM
 */

#ifndef TREENODE_H
#define	TREENODE_H


#include "DBentry.h"

class TreeNode {
private:
    DBentry* entryPtr;
    TreeNode* left;
    TreeNode* right;

public:
    // A useful constructor
    TreeNode(DBentry* _entryPtr);

    // the destructor
    ~TreeNode();

    // sets the left child of the TreeNode.
    void setLeft(TreeNode* newLeft);

    // sets the right child of the TreeNode
    void setRight(TreeNode* newRight);

    // gets the left child of the TreeNode.
    TreeNode* getLeft() const;

    // gets the right child of the TreeNode
    TreeNode* getRight() const;

    // returns a pointer to the DBentry the TreeNode contains. 
    DBentry* getEntry() const;
    
     /*
        ############   additional functions that I created #############
     */
    
    void remove(TreeNode *&root, string name);
    
    // finds the maximum of this
    DBentry* maximum();
};

#endif	/* TREENODE_H */

