#include <iostream>
#include <sstream>
#include <string>
#include "Rparser.h"
#include "Resistor.h"
#include "ResistorList.h"
#include "NodeList.h"
#include "Node.h"

using namespace std;

#define MAX_NODEID_NUMBER 10000   // Largest allowed node number

// All the parse_<commandName> routines work the same way. They parse the
// arguments for the command, passed in by reference in lineStream 
// (streams MUST be passed by reference; we need the stream to be updated
// as we extract characters, plus they can be too big to copy). As the functions
// parse arguments from left to right they print an error message if there is
// a problem, and immediately return to prevent any further (possibly 
// spurious) error messages from being printed.
// If we reach the end of the routine, the line is valid and we 
// print the appropriate output for that command.


bool parse_add (stringstream& lineStream, NodeList& control) {
    int node1, node2;
    double resistance;
    string label;
    
    if (!getNode (lineStream, node1))
        return false;  // Error, skip rest of line.
    
    if (!getNode (lineStream, node2))
        return false;  // Error, skip rest of line.
    
    if (!getStringArg (lineStream, label) )
        return false;
    
    if (!getResistance (lineStream, resistance)) 
        return false;   // Error, skip rest of line.
    
    if (!checkNoExtraArgs (lineStream) )
        return false;

    if (doAdd(label, resistance, node1, node2, control)){
         cout << "Added: resistor " << label << " " << resistance  
          << " Ohms " << node1 << " -> " << node2 << endl;
    }
    return true; // if successful
}


bool parse_change (stringstream& lineStream, string* label_, double* resistance_, NodeList& control) {
    string label;
    double resistance;

    if (!getStringArg (lineStream, label) )
        return false;
    
    // receives the resistance by giving in the resistor's name
//    double old_res = getResistancefromresArray(label);
    
    if (!getResistance (lineStream, resistance) ) 
        return false;
    
    if (!checkNoExtraArgs (lineStream) )
        return false;
    
    //updates the variables so it can be called in the other function
    *label_ = label;
    *resistance_ = resistance;    
    
    return true;

}


bool parse_find (stringstream& lineStream, string* label_) {
    
    string label;
    
    if (!getStringArg (lineStream, label) )
        return false;
    
    if (!checkNoExtraArgs (lineStream) )
        return false;

    *label_ = label;
    return true;
}


bool parse_list (stringstream& lineStream) {
    
    if (!checkKeyword (lineStream, "all") ) 
        return false;
    
    if (!checkNoExtraArgs (lineStream) )
        return false;
    
    return true;
}


bool parse_clear (stringstream& lineStream) {
    
    if (!checkKeyword (lineStream, "all") )
        return false;
    
    if (!checkNoExtraArgs (lineStream) )
        return false;
    
    cout << "Deleted all resistors\n";
    return true;
}

bool parse_remove (stringstream& lineStream, string* label_) {
    string label;
    
    if (!getStringArg (lineStream, label) )
        return false;
    
    if (!checkNoExtraArgs (lineStream) )
        return false;

    *label_ = label;
    return true;
}


bool getStringArg (stringstream &lineStream, string& label) {
    
    // Attempts to parse a string from lineStream. Returns the string 
    // by reference through label. If there is an error, print a message
    // and return false. Otherwise return true.
    
    lineStream >> label;
    // No need to check for eof first, as only way this fails is EOF
    // to check if greater than 20 characters
    if (label.size() > MAX_RESISTOR_NAME_LEN){
        string newstring = label.assign(label, 0 ,19);
        label = newstring; 
    }
    if (lineStream.fail()) {
        cout << "Error: missing argument\n"; 
        return (false);
    }
    return (true);
}


bool checkKeyword (stringstream& lineStream, string keyword) {
    // Checks that the next word in lineStream is keyword.
    // Returns true if it is.
    // Prints an error message and returns false otherwise.
    
    string argument;
    
    if (!getStringArg(lineStream, argument) )
        return (false);
    
    if (argument != keyword) {
        cout << "Error: invalid argument: expected \"" << keyword << "\"" << endl;
        return (false);
    }
    
    return (true);
}


bool getNode (stringstream& lineStream, int& node) {
    
    // Reads in a node (integer in a certain range) from lineStream. 
    // Prints error messages if appropriate. Returns the node number by
    // reference, and returns true if we successfully parsed it, false 
    // otherwise.
    
    lineStream >> node;
    
    if (lineStream.fail ()) {
        // Couldn't read. Did we have bad input, or no text left in the line?
        if (lineStream.eof () ) {
            cout << "Error: missing argument\n";
        }
        else {
            cout << "Error: argument is not a number\n";
        }
        return (false);
    }
    // Read an int.  Check that it has whitespace or nothing after it (not
    // non-digit characters spliced to it, e.g. 11kk is not a number).
    else if (lineStream.peek() != ' ' && lineStream.peek() != '\t' 
             && !lineStream.eof ()) {
        cout << "Error: argument is not a number\n";
        return (false);
    }
    else if (node < 0 || node > MAX_NODEID_NUMBER) {
        cout << "Error: value " << node << " is out of permitted range 0-"
        << MAX_NODEID_NUMBER << endl;
        return (false);
    }
    
    return (true);
}


bool getResistance (stringstream& lineStream, double& resistance) {
    
    // Parses a resistance value from lineStream. Prints error messages
    // if appropriate, and returns true if the resistance was successfully
    // parsed, false otherwise.
    
    lineStream >> resistance; 
    if (lineStream.fail ()) {
        // Failed to read.  Could be bad input, or end of line. 
        if (lineStream.eof () ) {
            cout << "Error: missing argument\n";
        }
        else {
            cout << "Error: argument is not a number\n";
        }
        return (false);
    }
    // Read a double.  Check that it has whitespace or nothing after it (not
    // non-digit characters spliced to it, e.g. 11kk is not a number).
    else if (lineStream.peek() != ' ' && lineStream.peek() != '\t' 
             && !lineStream.eof ()) {
        cout << "Error: argument is not a number\n";
        return (false);
    }
    else if (resistance < 0) {
        cout << "Error: invalid resistance (negative)\n";
        return (false);
    }
    
    return (true);
}


bool checkNoExtraArgs (stringstream& lineStream) {
    
    // Returns true if there is no input left in the lineStream, 
    // false otherwise.
    
    string extraArg;
    lineStream >> extraArg;
    
    if (!lineStream.fail ()) {
        cout << "Error: too many arguments\n";
        return (false);
    }
    
    return (true);
}
