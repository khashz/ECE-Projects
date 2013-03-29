/**
 * @file storage.c
 * @brief This file contains the implementation of the storage server
 * interface as specified in storage.h.
 *
 * performs all of the sending and receiving with the server,
 * also performs a standard error check on the commands given from client
 *
 */
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include "storage.h"
#include "utils.h"
#include "loghelp.h"
#include <errno.h>

// if this is a one, we have successfully connected
int didConnect;
// if this is a one, we have successfully authenticated
int didAuthenticate; 

/**
 * @brief receives a string and checks whether it's valid. Standard given according to the M2 document
 * @param string , string to perform error check on
 * @return return 0 for success, 1 for failure
 */
int tablecheck(char *string){
	int counter = strlen(string);
	int i;
	for (i = 0; i<counter; i++){
		if (!((string[i] >= 'a' && string[i] <= 'z') || (string[i] >= 'A' && string[i] <= 'Z')  || (string[i] >= '0' && string[i] <= '9'))) {
			// return failure
			return 1;	
		}
	}
	return 0;
}

/**
 * @brief receives a string and checks whether it's valid. Standard given according to the M2 document
 * @param string is what we want to make sure is a valid key type
 * @return return 0 for success, 1 for failure
 */
int keycheck(char *string){
	int counter = strlen(string);
	int i;
	for (i = 0; i<counter; i++){
		if (!((string[i] >= 'a' && string[i] <= 'z') || (string[i] >= 'A' && string[i] <= 'Z') || (string[i] >= '0' && string[i] <= '9'))) {
			// return failure
			return 1;	
		}
	}
	return 0;
}

/**
 * @brief receives a string and checks whether it's valid. Standard given according to the M2 document
 * @param string is what we want to make sure is a valid value type
 * @return return 0 for success, 1 for failure
 */
int valuecheck(char *string){
	int counter = strlen(string);
	int i;
	for (i = 0; i<counter; i++){
		if (!((string[i] >= 'a' && string[i] <= 'z') || (string[i] >= 'A' && string[i] <= 'Z') || (string[i] >= '0' && string[i] <= '9') || (string[i] == ' '))) {
			// return failure
			return 1;	
		}
	}
	return 0;
}



// void* storage_connect(const char *hostname, const int port)
/**
 * @brief performs a basic error check and after everything has passed, passes the information onto server via sendall
 * after the execution of this function, we will be conencted with our server
 * @param hostname is the name of the host we want to connect with
 * @param port is the port number we want to connect with
 * @param return 0 for success, -1 for failure
 */
void* storage_connect(const char *hostname, const int port)
{
	if (hostname == NULL){
		errno = ERR_INVALID_PARAM;
		return NULL;
	}
	// Create a socket.
	int sock = socket(PF_INET, SOCK_STREAM, 0);
	if (sock < 0)
		return NULL;

	// Get info about the server.
	struct addrinfo serveraddr, *res;
	memset(&serveraddr, 0, sizeof serveraddr);
	serveraddr.ai_family = AF_UNSPEC;
	serveraddr.ai_socktype = SOCK_STREAM;
	char portstr[MAX_PORT_LEN];
	snprintf(portstr, sizeof portstr, "%d", port);
	int status = getaddrinfo(hostname, portstr, &serveraddr, &res);
	if (status != 0)
		return NULL;

	// Connect to the server.
	status = connect(sock, res->ai_addr, res->ai_addrlen);
	if (status != 0){
    		didConnect = 0;
    		errno = ERR_CONNECTION_FAIL;
       		return NULL;
   	 }
	//I chose to put a logging call after the user connects because that signifies the
    	//start of the user interaction with the server. With this log, it is possible to see
   	//the exact starting timestamp of the user-server interaction. This will enable the
    	//programmer to accurately debug any problems as you can zero in on the suspect timeframe.
	
    	char log1[60];
    	sprintf(log1, "The Client connected to the server\n");
    	logger(clientlog, log1);

	didConnect = 1;
	return (void*) sock;
}


/**
 * @brief performs a basic error check and after everything has passed, passes the information onto server via sendall
 * after the execution of this function, we will be authenticated with the server
 * @param username the name of our server we want to join
 * @param passwd the password for the server network
 * @param conn a pointer to the connection status of the server
 * @return return 0 for success, -1 for failure
 */
int storage_auth(const char *username, const char *passwd, void *conn)
{
	// if we have not Connected, do not execute. Also raise the error
	if (didConnect != 1){
		errno = ERR_CONNECTION_FAIL;
		return -1;
	}

	// Connection is really just a socket file descriptor.
	int sock = (int)conn;

	// Send some data.
	char buf[MAX_CMD_LEN];
	memset(buf, 0, sizeof buf);
	char *encrypted_passwd = generate_encrypted_password(passwd, NULL);
	snprintf(buf, sizeof buf, "AUTH %s %s\n", username, encrypted_passwd);
	if (sendall(sock, buf, strlen(buf)) == 0 && recvline(sock, buf, sizeof buf) == 0) {
		if (strcmp("Failed", buf)== 0){
			errno = ERR_AUTHENTICATION_FAILED;
			return -1;		
		}
		didAuthenticate = 1;
		return 0;
	}

	return -1;
}

/**
 * @brief performs a basic error check and after everything has passed, passes the information onto server via sendall
 * after the execution of this function, we will have the values found inside the table 
 * @param table name of the table we want to get from
 * @param key name of the key
 * @param record is the struct holding the configuration parameters of everything inside the configuration file 
 * @param conn a pointer to the connection status of the server
 * @return return 0 for success, -1 for failure
 */
int storage_get(const char *table, const char *key, struct storage_record *record, void *conn)
{
	// if we have not Connected, do not execute. Also raise the error
	if (didConnect != 1){
		errno = ERR_CONNECTION_FAIL;
		return -1;
	}
	if (didAuthenticate != 1){
		errno = ERR_NOT_AUTHENTICATED;
		return -1;
	}

	if (table == NULL || conn == NULL ){
		errno = ERR_INVALID_PARAM;
		return -1;
	}

	// parse the values to see if its correct
	if (tablecheck(table) == 1 || keycheck(key) == 1){
		errno = ERR_INVALID_PARAM;
		return -1;
	}

	// Connection is really just a socket file descriptor.
	int sock = (int)conn;

	// Send some data.
	char buf[MAX_CMD_LEN];
	memset(buf, 0, sizeof buf);
	snprintf(buf, sizeof buf, "GET %s %s\n", table, key);
	if (sendall(sock, buf, strlen(buf)) == 0 && recvline(sock, buf, sizeof buf) == 0) {

		if (strcmp("table_fail", buf)== 0){
			errno = ERR_TABLE_NOT_FOUND;
			return -1;		
		}
		else if (strcmp("key_fail", buf)== 0){
			errno = ERR_KEY_NOT_FOUND;
			return -1;		
		}
		strncpy(record->value, buf, sizeof record->value);
		didAuthenticate = 1;
		return 0;
	}

	return -1;
}


/**
 * @brief performs a basic error check and after everything has passed, passes the information onto server via sendall
 * after the execution of this function, we will have set a key along with its values inside the database
 * @param table name of the table we want to set to
 * @param key name of the key we want to set
 * @param record is the struct holding the configuration parameters of everything inside the configuration file 
 * @param conn a pointer to the connection status of the server
 * @return return 0 for success, -1 for failure
 */
int storage_set(const char *table, const char *key, struct storage_record *record, void *conn)
{
	// if we have not Connected, do not execute. Also raise the error
	if (didConnect != 1){
		errno = ERR_CONNECTION_FAIL;
		return -1;
	}
	if (didAuthenticate != 1){
		errno = ERR_NOT_AUTHENTICATED;
		return -1;
	}
	if (table == NULL || key == NULL  || conn == NULL ){
		errno = ERR_INVALID_PARAM;
		return -1;
	}

	// parse the values to see if its correct
	if (tablecheck(table) == 1 || keycheck(key) == 1 ){
		errno = ERR_INVALID_PARAM;
		return -1;
	}
	// Connection is really just a socket file descriptor.
	int sock = (int)conn;

	// Send some data.
	char buf[MAX_CMD_LEN];
	memset(buf, 0, sizeof buf);
	if(record != NULL){
		snprintf(buf, sizeof buf, "SET %s %s %s\n", table, key, record->value);
	}
	else if(record == NULL){
		snprintf(buf,sizeof buf, "SET %s %s null\n", table, key);
	}
	if (sendall(sock, buf, strlen(buf)) == 0 && recvline(sock, buf, sizeof buf) == 0) {
		if (strcmp("table_fail", buf)== 0){
			errno = ERR_TABLE_NOT_FOUND;
			return -1;		
		}
		else if (strcmp("key_fail", buf)== 0){
			errno = ERR_KEY_NOT_FOUND;
			return -1;		
		}
		else if (strcmp("unknown", buf)== 0){
			errno = ERR_UNKNOWN;
			return -1;		
		}
		else if (strcmp("invalid_param", buf)== 0){
			errno = ERR_INVALID_PARAM;
			return -1;
		}
		else {
			return 0;
		}

	}

	return -1;
}

/**
 * @brief performs a basic error check and after everything has passed, passes the information onto server via sendall
 * after the execution of this function, we will have all of the keys that pass the operations inside predicates
 * @param table name of the table we want to query from
 * @param key a member address of the pointer for the string of keys
 * @param  max_keys is the max number of keys storage query is supposed to return
 * @param conn a pointer to the connection status of the server
 * @return return 0 for success, -1 for failure
 */
int storage_query(const char *table, const char *predicates, char **keys, const int max_keys, void *conn){
	// if we have not Connected, do not execute. Also raise the error
	if (didConnect != 1){
		errno = ERR_CONNECTION_FAIL;
		return -1;
	}
	if (didAuthenticate != 1){
		errno = ERR_NOT_AUTHENTICATED;
		return -1;
	}

	if (table == NULL || keys == NULL || predicates == NULL || conn == NULL ){
		errno = ERR_INVALID_PARAM;
		return -1;
	}

	// parse the values to see if its correct
	if (tablecheck(table) == 1){
		errno = ERR_INVALID_PARAM;
		return -1;
	}

	// Connection is really just a socket file descriptor.
	int sock = (int)conn;

	// Send some data.
	char buf[MAX_CMD_LEN];
	memset(buf, 0, sizeof buf);
	snprintf(buf, sizeof buf, "QUERY %s %s\n", table, predicates);
	if (sendall(sock, buf, strlen(buf)) == 0 && recvline(sock, buf, sizeof buf) == 0) {
			if (strcmp("table_fail", buf)== 0){
				errno = ERR_TABLE_NOT_FOUND;
				return -1;
			}
			else if (strcmp("invalid_param", buf)== 0){
				errno = ERR_INVALID_PARAM;
				return -1;
			}

		int i = 0;
		char* output = NULL;
		char buf_copy[100];
		//printf("Keys that match:%s..",buf);
		if(buf[0] == '\0') return 0;
		strncpy(buf_copy,buf,strlen(buf));
		output = strtok(buf_copy, ",");
		while (output != NULL){
			keys[i] = malloc((strlen(output)+1));
			strcpy(keys[i],output);
			output = strtok(NULL, ",");
			i++;
			if(*output == '*') {
				keys[i] == NULL;
				break;
			}
		}
		return i;
	}
}


/**
 * @brief performs a basic error check and after everything has passed, disconnects from the server
 * @param conn a pointer to the connection status of the server
 * @return return 0 for success, -1 for failure
 */
int storage_disconnect(void *conn)
{
	// if we have not Connected, do not execute. Also raise the error
	if (didConnect != 1){
		errno = ERR_INVALID_PARAM;
		return -1;
	}

	if (conn == NULL){
		errno = ERR_INVALID_PARAM;
		return -1;
	}
	// Cleanup
	int sock = (int)conn;
	close(sock);

	return 0;
}

