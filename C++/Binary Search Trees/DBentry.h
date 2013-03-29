/* 
 * File:   DBentry.h
 * Author: hossei50
 *
 * Created on November 17, 2012, 5:37 PM
 */

#ifndef DBENTRY_H
#define	DBENTRY_H

#include <string>
using namespace std;

class DBentry {
private:
	string name;
	unsigned int IPaddress;
        bool active;

public:
	// the default constructor
	DBentry();
        DBentry (string _name, unsigned int _IPaddress, bool _active);

	// the destructor
 	~DBentry();	

	// sets the domain name, which we will use as a key.
	void setName(string _name);

	// sets the IPaddress data.
	void setIPaddress(unsigned int _IPaddress);
    
        // sets whether or not this entry is active.
        void setActive (bool _active);

        // returns the name.
	string getName() const;

	// returns the IPaddress data.
	unsigned int getIPaddress() const;

        // returns whether or not this entry is active.
        bool getActive() const;
     
        //prints out the entry
        void print();
};

#endif	/* DBENTRY_H */

