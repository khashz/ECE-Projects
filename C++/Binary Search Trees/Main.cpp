/* 
 * File:   main.cpp
 * Author: hossei50
 *
 * Created on November 17, 2012, 4:38 PM
 */

#include <cstdlib>
#include "DBentry.h"
#include "TreeDB.h"
#include "TreeNode.h"
#include <iostream>
#include <sstream>
#include <string>

using namespace std;

int main(int argc, char** argv) {
    // action command, read from the user
    string line;  // Prompt for input
    cout << "> ";
    getline(cin, line);
     string command;
    // "tree" will be our database for our BST
    TreeDB tree;
    while ( !cin.eof () ) { // while end of file is not reached
        stringstream hello(line);
        hello >> command;
   // performs insert command, takes in a name, IPadd, status and inserts it into
   // our BST if it does not already exist
        if(command == "insert"){
            // declaration of the variables followed by the cin read
            string name;
            hello >> name;
            // IPaddress
            unsigned int IPaddress;
            hello >> IPaddress;
            // status
            string active;
            hello >> active;
            //get the true and false format
            bool inputforActive;
            if (active == "active"){
                inputforActive = true;
            }
            else {
                inputforActive = false;
            }
            //creates the new DBentry type to pass into function
            if ((tree.recursiveFind(tree.getRoot(), name)) == NULL){
                DBentry *entry = new DBentry(name, IPaddress, inputforActive);
                tree.insert(entry);
            }
            else {
                cout<<"Error: entry already exists"<<endl;
            }
        }
  // performs the find command, based on the given string name
        else if (command == "find"){
            string name;
            hello >> name;
            tree.find(name);
        }
  // performs the remove of an element command based on the given string name
        else if (command == "remove"){
            string name;
            hello >> name; 
            // if this find function DN return null, we have the desired
            // in our BST
            if ((tree.recursiveFind(tree.getRoot(), name)) != NULL){
                tree.remove(name);
                cout << "Success"<<endl;
            }
            else { // if the function returns null, no match!
                cout <<"Error: entry does not exist"<<endl;
            }  
        }
  // performs the printall command, lists all elements in ascending order (preorder)
        else if (command == "printall"){
            tree.print(tree.getRoot());
        }
  // performs the printprobe command based on the string inputted
        else if (command == "printprobes"){
            string name;
            hello >> name; 
            int count = 0;
            DBentry *holder = tree.recursiveFind(tree.getRoot(),name);
            
            if (holder){ // found the element
                tree.printProbes(tree.getRoot(), name, count);
                cout<<count<<endl;
            }
            else { // if the function returns null, no match!
                cout <<"Error: entry does not exist"<<endl;
            }  
        }
  // removes all the elements in our BST
        else if (command == "removeall"){
            // using the remove function, we destroy the BST
            while (tree.getRoot()){
                // one by one destroys the 
                tree.remove(tree.getRoot()->getEntry()->getName());
            }
            cout<<"Success"<<endl;
        }
  // counts all of the entries in our data base that are currently active
        else if (command == "countactive"){
            tree.countActive();
        }
  // updates the current status of the inputted string's status
        else if (command == "updatestatus"){
            string name;
            hello >> name;
            // status
            string active;
            hello >> active;
            //get the true and false format
            bool inputforActive;
            if (active == "active"){
                inputforActive = true;
            }
            else {
                inputforActive = false;
            }
            
            DBentry *holder = tree.recursiveFind(tree.getRoot(),name);
            
            if (holder){ // found the element
                tree.getRoot()->getEntry()->setActive(inputforActive);
                cout << "Success"<<endl;
            }
            else { // if the function returns null, no match!
                cout <<"Error: entry does not exist"<<endl;
            } 
        }
  // unrecognized command
        else{
            cout << "Error: unknow command"<<endl;
        }
  // reprompt for input
        cout << "> ";
        getline(cin, line);
    }
    
    return 0;
}
