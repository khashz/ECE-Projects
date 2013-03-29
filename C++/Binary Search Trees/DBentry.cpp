#include "DBentry.h"
#include <iostream>
#include <string>
#include <cstdlib>
using namespace std;
/* methods from the .h class
private:
	string name;
	unsigned int IPaddress;
        bool active;
 */

DBentry::DBentry (string _name, unsigned int _IPaddress, bool _active){
    name = _name;
    IPaddress = _IPaddress;
    active = _active;
}

// the destructor
DBentry::~DBentry(){
    name = "";
    
}

// sets the domain name, which we will use as a key.
void DBentry::setName(string _name){
    name = _name;
}

// sets the IPaddress data.
void DBentry::setIPaddress(unsigned int _IPaddress){
    IPaddress = _IPaddress;
}
    
// sets whether or not this entry is active.
void DBentry::setActive (bool _active){
    active = _active;
}

// returns the name.
string DBentry::getName() const{
    return name;
}

// returns the IPaddress data.
unsigned int DBentry::getIPaddress() const{
    return IPaddress;
}

// returns whether or not this entry is active.
bool DBentry::getActive() const{
    return active;
}

//prints out the entry
void DBentry::print(){
    string activity;
    // set the activity message based on the bool status of 'active'
    if (active){
        activity = "active";
    }
    else {
        activity = "inactive";
    }
    cout<< name << " : " << IPaddress << " : " << activity <<endl;
}