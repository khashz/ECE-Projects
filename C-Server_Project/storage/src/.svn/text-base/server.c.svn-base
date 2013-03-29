/**
 * @file
 * @brief This file implements the storage server.
 *
 * The storage server should be named "server" and should take a single
 * command line argument that refers to the configuration file.
 * 
 * The storage server should be able to communicate with the client
 * library functions declared in storage.h and implemented in storage.c.
 *
 * At the bottom of the server file, we have implemented all of the functions
 * needed for our database, along with the query function
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <string.h>
#include <assert.h>
#include <signal.h>
#include "utils.h"
#include "loghelp.h"
#include <errno.h>

#define MAX_SIZE_LENGTH 800

/**
 * @brief A struct a linked list to store the table's configuration paramaters. 
 */
struct table {

	struct key* head;
	struct table* back;
	struct table* next;
	char name[MAX_TABLE_LEN];
    char col_name[MAX_COLUMNS_PER_TABLE][MAX_COLNAME_LEN];
    char col_type[MAX_COLUMNS_PER_TABLE][10];
    int number_records;

};

/**
 * @brief A struct to store EACH table's paramters
 */
struct temp_table_info {

	char col_name[MAX_COLUMNS_PER_TABLE][MAX_COLNAME_LEN];
    char col_type[MAX_COLUMNS_PER_TABLE][10];
	char col_value[10][800];
	char operators[10][10];
	
};

/**
 * @brief Simply stores the next key in the list and the value (each key is a struct)
 */
struct key {

	char name[MAX_KEY_LEN];
	struct key* next;
	struct key* back;
	char value[MAX_VALUE_LEN];
    char value_per_col[MAX_COLUMNS_PER_TABLE][100];

};

/**
 * @brief A header for our database
 */
struct head{

	struct table* head;

};




#define MAX_LISTENQUEUELEN 20   ///< The maximum number of queued connections.



struct table* create_table_bare(char* name_table, struct table_info *temp);//changed in m3
struct table *find_table(char* name, struct head* head);
struct key *find_key(char* name, struct table* table);

struct table* create_table(char* name_table, char* name_key, char* value);
struct key* create_key(char*name_key, char* value, struct temp_table_info* temp);//changed in m3
void insert_table(struct table* new_table, struct head* head);
void insert_key(struct key* new_key, struct table* table);
void delete_table(struct table* target_table, struct table* table);
void delete_key(struct key* target_key, struct table* table);
int set_function(char *table_name, char *key_name ,char *value, struct head* head, struct temp_table_info* temp);//changed in m3
int get_function(char *table_name, char *key_name, char *value, struct head* head);


///PARSING///
int compare_formats(struct temp_table_info* temp_info, struct table* target_table);
int query_parser(char* line, struct temp_table_info* temp_info);
int input_parser(char* line, struct temp_table_info* temp_info);
int compare_query_format(struct temp_table_info* temp_info, struct table* target_table);

//Query functions//
struct key* check_key(struct key* target_key, int index_col,char* operators, char* type, char* value);
int table_query(struct table* target_table, struct temp_table_info* col_info, struct key* key_array[50]);

// if this is a one, we have successfully authenticated
int didAuthenticate; 

/**
 * @brief Handle command takes in a sentence from the client and performs accordingly
 *
 * @param sock The socket connected to the client.
 * @param cmd The command received from the client.
 * @param log a pointer to the pointer of the declaration of the file to log
 * @param params a pointer to the struct holding the properties inside the config file 
 * @param head a pointer to the head of our database
 * @return Returns 0 on success, -1 otherwise.
 */
int handle_command(int sock, char *cmd, FILE** log, struct config_params *params, struct head* head)
{

    char statement1[200];
    sprintf(statement1, "Processing command '%s'\n",cmd);
    struct temp_table_info* temp_info = malloc (sizeof(struct temp_table_info));
    logger(*log, statement1);

    char command[1000];
    sscanf(cmd, "%s", command);

        if (strcmp(command, "AUTH") == 0){
           char first[100];
           char usernameRead[100];
           char password[100];
           // the first %s  just bypasses the first task
           sscanf(cmd, "%s %s %s", first, usernameRead, password);

           if ((strcmp(usernameRead, params->username) == 0) && (strcmp(password, params->password) == 0)){
        	   sendall(sock, "Successful", strlen("Successful"));
        	   sendall(sock, "\n", 1);
		   didAuthenticate = 1;
        	   return 0;
           }
           else {
        	   errno = ERR_AUTHENTICATION_FAILED;
        	   // send back failed sign
        	   sendall(sock, "Failed", strlen("Failed"));
        	   sendall(sock, "\n", 1);
        	   return -1;
           }
        }
        else if (strcmp(command, "GET") == 0){
		if (didAuthenticate != 1){
			errno = ERR_NOT_AUTHENTICATED;
			return -1;
		}
        	char *s = cmd;
        	char first[100];
        	char table[100];
        	char key[100];
        	// reads the first string in cmd and then moves the pointer
        	sscanf(s, "%s", first);
        	s=s+strlen(first)+1;

        	// reads the second string in cmd and then moves the pointer
        	sscanf(s, "%s", table);
        	if (strcmp(table, "\n")==0){
        		errno = ERR_INVALID_PARAM;
        		 sendall(sock, "Failed", strlen("Failed"));
        		 sendall(sock, "\n", 1);
               	 return -1;
        	}

        	s=s+strlen(table)+1;

        	// reads the third string in cmd and then moves the pointer
        	sscanf(s, "%s", key);
        	if (strcmp(key, "\n")==0){
        	    errno = ERR_INVALID_PARAM;
        	    sendall(sock, "Failed", strlen("Failed"));
        	    sendall(sock, "\n", 1);
        	    return -1;
        	}
        	s=s+strlen(key)+1;

        	struct storage_record temp;
        	char tempString[MAX_SIZE_LENGTH];
        	strncpy(tempString, s, MAX_VALUE_LEN);
        	// since i increment the s pointer, right here s has the value of 'value'
            	// call your function with these variables

// return 0 for success, 1 for key not found, 2 table not found 
		int temper = get_function(table,key,tempString,head);
           if (temper == 0){
        	   sendall(sock, tempString, strlen(tempString));
        	   sendall(sock, "\n", 1);
        	   return 0;
           }
	   else if (temper == 1){
			   sendall(sock, "key_fail", strlen("key_fail"));
        	   sendall(sock, "\n", 1);
        	   errno = ERR_KEY_NOT_FOUND;
        	   return -1;
	   }
           else if (temper == 2){
	   	   sendall(sock, "table_fail", strlen("table_fail"));
        	   sendall(sock, "\n", 1);
		   errno = ERR_TABLE_NOT_FOUND;
        	   return -1;
	   }
        }
        else if (strcmp(command, "SET") == 0){
		if (didAuthenticate != 1){
			errno = ERR_NOT_AUTHENTICATED;
			return -1;
		}	
        	char *s = cmd;
        	char first[100];
        	char table[100];
        	char key[100];
        	sscanf(s, "%s", first);
        	s=s+strlen(first)+1;
        	sscanf(s, "%s", table);
        	if (strcmp(table, "\n")==0){

        		errno = ERR_INVALID_PARAM;
        		sendall(sock, "Failed", strlen("Failed"));
        		sendall(sock, "\n", 1);
        		return -1;

        	}

	       	s=s+strlen(table)+1;

        	sscanf(s, "%s", key);
        	if (strcmp(key, "\n")==0){
        		errno = ERR_INVALID_PARAM;
        		sendall(sock, "Failed", strlen("Failed"));
        		sendall(sock, "\n", 1);
        		return -1;
        	}
        	s=s+strlen(key)+1;
        	printf("value in S:%s\n",s);
        	struct storage_record temp;
        	char tempString[MAX_SIZE_LENGTH];
        	strncpy(tempString, s, MAX_VALUE_LEN);
        	printf("value in tempString:%s\n",tempString);
        	char tempString2[MAX_SIZE_LENGTH];
        	strncpy(tempString2, tempString, MAX_VALUE_LEN);
        	
		// check if user input is in the proper format
        	if(strcmp(tempString,"null")){
        		if(input_parser(tempString, temp_info) == -1){
        			sendall(sock, "invalid_param", strlen("invalid_param"));
        			sendall(sock, "\n", 1);
        			errno = ERR_INVALID_PARAM;;
        			return -1;
        		}
        	}

		// return 0 for success, 1 for key not found, 2 table not found, 3 unknown
		// also checks formats of supplied input with table format
		int temper = set_function(table,key,tempString2,head, temp_info);
        	if (temper == 0){
        	   sendall(sock, tempString , strlen(tempString));
        	   sendall(sock, "\n", 1);
        	   return 0;
           	}
        	else if (temper == 1){
        	    sendall(sock, "key_fail", strlen("key_fail"));
        	    sendall(sock, "\n", 1);
		    errno = ERR_KEY_NOT_FOUND;
        	    return -1;
        	}
		else if (temper == 2){
        	    sendall(sock, "table_fail", strlen("table_fail"));
        	    sendall(sock, "\n", 1);
		    errno = ERR_TABLE_NOT_FOUND;
        	    return -1;
        	}
		else if (temper == 3){
        	    sendall(sock, "unknown", strlen("unknown"));
        	    sendall(sock, "\n", 1);
        	    errno = ERR_UNKNOWN;
        	    return -1;
        	}
		else if (temper == 4){
				sendall(sock, "invalid_param", strlen("invalid_param"));
				sendall(sock, "\n", 1);
				errno = ERR_INVALID_PARAM;;
				return -1;
		    }
        }
	else if (strcmp(command, "QUERY") == 0){ // format received "QUERY %s %s\n"
		if (didAuthenticate != 1){
			errno = ERR_NOT_AUTHENTICATED;
			return -1;
		}
		int h;
		struct key* key_array[50];
		for(h=0; h < 50; h++) key_array[h] = NULL;
		char *s = cmd;
		char first[100];
		char table[100];
		char key[100];
		char tempString[100];
		sscanf(s, "%s", first); // holds query
		s=s+strlen(first)+1;
		sscanf(s, "%s", table); // holds the table name
		s=s+strlen(table)+1;
		strncpy(tempString,s,100);

		// now the variable 's' holds the sentence of the predicates

		// call function that parses predicate and puts it into temp_table_info struct
		if(query_parser(s,temp_info) == -1) {
			sendall(sock, "invalid_param", strlen("invalid_param"));
			sendall(sock, "\n", 1);
			errno = ERR_INVALID_PARAM;
			return -1;
		}

		struct table* target_table = find_table(table, head);

		if(target_table == NULL){
			sendall(sock, "table_fail", strlen("table_fail"));
			sendall(sock, "\n", 1);
			errno = ERR_TABLE_NOT_FOUND;
			return -1;
		}
		// function #2 make call to function that checks if column types/names/values match and are the correct format
		if(compare_query_format(temp_info, target_table) == -1){
			sendall(sock, "invalid_param", strlen("invalid_param"));
			sendall(sock, "\n", 1);
			errno = ERR_INVALID_PARAM;
			return -1;
		}

		int temper; //make this equal to the function call for query
		int v= 0;
		// do the query command, return all of the keys in one array of pointers
		while(key_array[v] != NULL){
			key_array[v] = NULL;
			v++;
		}
		temper = table_query(target_table,temp_info, key_array);
		char all_the_keys[MAX_SIZE_LENGTH];
		int p = 0;
		while(all_the_keys[p] != '\0'){
			all_the_keys[p] = '\0';
			p++;
		}
		p=0;
		while(key_array[p] != NULL){
			if(p == 0) {
				strcpy(all_the_keys, key_array[p]->name);
				strcat(all_the_keys,",");
				if(key_array[p+1] == NULL) strcat(all_the_keys, "*");
			}
			else {
				strcat(all_the_keys, key_array[p]->name);
				strcat(all_the_keys,",");
				if(key_array[p+1] == NULL) strcat(all_the_keys, "*");

			}
			p++;
		}


		if (temper == 0){ // for success
			sendall(sock, all_the_keys, strlen(all_the_keys));
			sendall(sock, "\n", 1);
			return 0;
		}
		else if (temper == 1){
			sendall(sock, "key_fail", strlen("key_fail"));
			sendall(sock, "\n", 1);
			errno = ERR_KEY_NOT_FOUND;
			return -1;
		}
		else if (temper == 2){
			sendall(sock, "table_fail", strlen("table_fail"));
			sendall(sock, "\n", 1);
			errno = ERR_TABLE_NOT_FOUND;
			return -1;
		}
	}
    return 0;
}

/**
 * @brief Start the storage server.
 *
 * - starts the connection and ports
 *
 * - it opens the file to log, processes the time output
 * - creates the tables and keys for the database
 * - processes the config file
 * - calls handle command 
 * @return returns 0 for success, -1 for failure
 */
int main(int argc, char *argv[])
{

	FILE* serverlog;
	time_t temp_time;
    	struct tm * ti;
    	char store1 [90];
    	struct head* head = malloc (sizeof (struct head));
	

  	time ( &temp_time );
  	ti = localtime( &temp_time );

   	strftime (store1, 90 ,"Server-%Y-%m-%d-%H-%M-%S.log",ti);
   	if (LOGGING == 2) {
    		serverlog = fopen(store1 ,"a+");
    	}

	// Process command line arguments.
	// This program expects exactly one argument: the config file name.
	assert(argc > 0);
	if (argc != 2) {
		printf("Usage %s <config_file>\n", argv[0]);
		exit(EXIT_FAILURE);
	}
	char *config_file = argv[1];

	// Read the config file.
	struct config_params params;
	int status = read_config(config_file, &params);
	if (status != 0) {
		printf("Error processing config file.\n");
		exit(EXIT_FAILURE);
	}
	/*int hi;
	for (hi = 0; hi <= 3; hi++){
			printf("table name: %s name1: %s name2: %s type1: %s type2: %s  \n", 
				params.tableInfo[hi].table_names,
				params.tableInfo[hi].name_for_column[0],
				params.tableInfo[hi].name_for_column[1],
				params.tableInfo[hi].type_for_name[0], 
				params.tableInfo[hi].type_for_name[1]
			);
	} */



	int i = 0;
	int j = 0;
	for (params.table[i];i<=params.index;i++) {
		char file_name[MAX_TABLE_LEN];
		strncpy(file_name, params.table[i], sizeof params.table[i]);
		
		// make a table
		struct table* test_table = create_table_bare(params.table[i],&params.tableInfo[i]);	
    		// status = storage_set(TABLE, KEY, &r, conn);
    		insert_table(test_table, head);

/* // inputs the multiple tables into the database, needed for m2
		// open the file
		FILE *test_file = fopen(file_name, "r");
		// error check
		if (test_file == NULL) return 0;
		
		j = 0; // loop for keys in the file
		while (!feof(test_file)){
			char line2[800];
			char *li = fgets(line2, sizeof line2, test_file); // will strip the name and value
			if (li) { // loops over all of the lines in the file
				char use_da_name[100]; 
				char use_da_value[100];
				sscanf(line2,"%s %s",use_da_name, use_da_value);
				set_function(file_name,use_da_name,use_da_value,head);
				j++;
			}
		}
*/		strcpy(params.table[params.index + 1], " ");

	}




	char message2[150];
	sprintf(message2, "Server on %s:%d\n", params.server_host, params.server_port);
	logger(serverlog, message2);

	// Create a socket.
	int listensock = socket(PF_INET, SOCK_STREAM, 0);
	if (listensock < 0) {
		printf("Error creating socket.\n");
		exit(EXIT_FAILURE);
	}

	// Allow listening port to be reused if defunct.
	int yes = 1;
	status = setsockopt(listensock, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof yes);
	if (status != 0) {
		printf("Error configuring socket.\n");
		exit(EXIT_FAILURE);
	}

	// Bind it to the listening port.
	struct sockaddr_in listenaddr;
	memset(&listenaddr, 0, sizeof listenaddr);
	listenaddr.sin_family = AF_INET;
	listenaddr.sin_port = htons(params.server_port);
	inet_pton(AF_INET, params.server_host, &(listenaddr.sin_addr)); // bind to local IP address
	status = bind(listensock, (struct sockaddr*) &listenaddr, sizeof listenaddr);
	if (status != 0) {
		printf("Error binding socket.\n");
		exit(EXIT_FAILURE);
	}

	// Listen for connections.
	status = listen(listensock, MAX_LISTENQUEUELEN);
	if (status != 0) {
		printf("Error listening on socket.\n");
		exit(EXIT_FAILURE);
	}

	char table_name[100];	
	FILE* fp;
	int temp_counter = 0;

// Listen loop.
	int wait_for_connections = 1;
	while (wait_for_connections) {
		// Wait for a connection.
		struct sockaddr_in clientaddr;
		socklen_t clientaddrlen = sizeof clientaddr;
		int clientsock = accept(listensock, (struct sockaddr*)&clientaddr, &clientaddrlen);
		if (clientsock < 0) {
			printf("Error accepting a connection.\n");
			exit(EXIT_FAILURE);
		}
		char message3[150];
		sprintf(message3, "Got a connection from %s:%d.\n", inet_ntoa(clientaddr.sin_addr), clientaddr.sin_port);
		logger(serverlog, message3);

		// Get commands from client.
		int wait_for_commands = 1;
		do {
			// Read a line from the client.
			char cmd[MAX_CMD_LEN];
			int status = recvline(clientsock, cmd, MAX_CMD_LEN);
			if (status != 0) {
				// Either an error occurred or the client closed the connection.
				wait_for_commands = 0;
			} else {
				// Handle the command from the client.
				 int status = handle_command(clientsock, cmd, &serverlog, &params, head);
				if (status != 0)
					wait_for_commands = 0; // Oops.  An error occured.
			}
		} while (wait_for_commands);
		
		// Close the connection with the client.
		close(clientsock);

		char message4[150];
		sprintf(message4, "Closed connection from %s:%d.\n", inet_ntoa(clientaddr.sin_addr), clientaddr.sin_port);
		logger(serverlog, message4);
		
	}
	
	// Stop listening for connections.
	close(listensock);
	if (LOGGING == 2){
			fclose(serverlog);
	}
	return EXIT_SUCCESS;
}



/**
 * @brief a function to find the table stored inside of our database
 * @param name of the table
 * @param head structure of the head to the database
 * @return struct of the table if found, or null if not found
 */
struct table *find_table(char* name, struct head* head){

	if(head->head == NULL) return NULL;//nothing in list
	struct table* probe = head->head;

	do{
		if(!strcmp(probe->name, name)) return probe;//found match, return pointer to table
		if(probe->next == NULL) return NULL;//reached end of list, exit
		probe = probe->next;//traverse through list

	}while(1);//runs endlessly, assumes return will exit eventually (when reaching end of list)
	
	return NULL;
}

/**
 * @brief function to find the key stored inside of our database
 * @param name of the table
 * @param head structure of the head to the database
 * @return struct of the table if found, or null if not found
 */
struct key *find_key(char* name, struct table* table){

	if(table->head == NULL) return NULL;//nothing in list

		struct key* probe = table->head;
		int i = 0;

		do{
			if(!strcmp(probe->name, name)) return probe;//found match, return pointer to table
			if(probe->next == NULL) return NULL;//reached end of list, exit
			probe = probe->next;//traverse through list

		}while(i == 0);//runs endlessly, assumes return will exit eventually (when reaching end of list)

		return NULL;

}

/*currently not used
struct table* create_table(char* name_table, char* name_key, char* value){


	struct table* new = (struct table *) malloc(sizeof(struct table));


	//set values of table
	strcpy(new->name,name_table);
	new->next = NULL;
	new->back = NULL;
	new->number_records = 1;
	new->head = (struct key*) malloc(sizeof(struct key));

	//set values of key
	strcpy(new->head->name,name_key);
	new->head->next = NULL;
	new->head->back = NULL;
	strcpy(new->head->value, value);

	return new;//return new table upon successful creation
}
*/

/**
 * @brief A function that dynamically creates a bare table given its name and table configurations
 * @param name_table name of the table
 * @param table_info information for each table inside the config file
 * @return struct to the table created
 */
struct table* create_table_bare(char* name_table, struct table_info *temp){

	struct table* new = (struct table *) malloc(sizeof(struct table));

	//set values of table
	strcpy(new->name,name_table);
	new->next = NULL;
	new->back = NULL;
	new->number_records = 1;
	new->head = NULL;
	
	int i = 0;
	while(temp->name_for_column[i][0] != '\0'){

		strcpy(new->col_name[i],temp->name_for_column[i]);
		i++;
	}
	i = 0;
	while(temp->type_for_name[i][0] != '\0'){

		strcpy(new->col_type[i],temp->type_for_name[i]);
		i++;
	}
	return new;//return new table upon successful creation
}


/**
 * @brief A function that dynamically creates a key given its key name, value.
 * @param name_key name of the key
 * @param value value to place inside the key
 * @param temp struct of the table info
 * @return struct to the key created
 */
struct key* create_key(char*name_key, char* value, struct temp_table_info* temp){



	struct key* new = (struct key*) malloc(sizeof(struct key));

	//set values of key
	strcpy(new->name,name_key);
	new->next = NULL;
	new->back = NULL;
	strcpy(new->value, value);
	
	int i = 0;
	while(temp->col_value[i][0] != '\0'){
		strcpy(new->value_per_col[i],temp->col_value[i]);	
		i++;
	}
	
	return new;
}


/**
 * @brief a function that inserts a table (new_table) inside of our database. Also inserts it into our structs
 * @param new_table a struct pointing to the table
 * @param head a struct pointing to the head of our database
 * @return nothing
 */
void insert_table(struct table* new_table, struct head* head){

	if(head ->head == NULL){
		head ->head = new_table;
		return;
	}

	struct table* probe = head->head;

	do{
		if(probe->next == NULL){
			probe->next = new_table;
			new_table->back = probe;

			return;
		}

		probe = probe->next;

	}while(1);

}


/**
 * @brief a function that inserts a key (new_key) inside of our database. Also inserts it into our structs
 * @param new_key a struct to the new key
 * @param table a struct to the table
 * @return nothing
 */

void insert_key(struct key* new_key, struct table* table){

	if(table->head == NULL){
			table->head = new_key;
			return;
		}

	int i = 0;
	struct key* probe = table->head;

	do{
		if(probe->next == NULL){
			probe->next = new_key;
			new_key->back = probe;

			return;
		}

		probe = probe->next;

	}while(i == 0);

}

/*
void delete_table(struct table* target_table, struct table* table){

	if(target_table->back == NULL){

		if(target_table->next == NULL){
			table->head = NULL;
			//delete all the keys in the table ####TO IMPLEMENT LATER####
			free(target_table);
			return;
		}
		else if(target_table->next != NULL){
			head = target_table->next;
			head->back = NULL;
			//delete all the keys in the table ###TO IMPLEMENT LATER###
			free(target_table);
			return;
		}

	}else if(target_table->back != NULL){

		if(target_table->next == NULL){
			target_table->back->next = NULL;
			//delete keys
			free(target_table);

			return;
		}
		else if(target_table->next != NULL){
			target_table->back->next = target_table->next;
			target_table->next->back = target_table->back;
			//delete keys
			free(target_table);
			return;
		}
	}
}*/

/**
 * @brief function that deletes the key from the linked list and sets the next/back value of respective keys in the list
 * @param target_key is the key to be deleted
 * @param table is the table the key is contained in
 * @return nothing
 */
void delete_key(struct key* target_key, struct table* table){

	if(target_key->back == NULL){

		if(target_key->next == NULL){
			table->head = NULL;
			free(target_key);
			return;
		}
		else if(target_key->next != NULL){
			table->head = target_key->next;
			table->head->back = NULL;
			free(target_key);
			return;
		}

	}else if(target_key->back != NULL){

		if(target_key->next == NULL){
			target_key->back->next = NULL;
			free(target_key);
			return;
		}
		else if(target_key->next != NULL){
			target_key->back->next = target_key->next;
			target_key->next->back = target_key->back;
			free(target_key);
			return;
		}
	}
}


/**
 * @brief a function that sets the value of a key based on the value sent. Function is called from handle_command
 * @param table_name name of the table we must set into
 * @param key_name name of the key to input
 * @param value value to be set
 * @param head header to the database (head of table chain)
 * @param temp a struct that contains the format of the input, used to check if the format matches the table's format
 * @return 0 for success, 1 for key not found, 2 table not found, 3 unknown, 4 invalid format of input (types do no match columns)
 */
int set_function(char *table_name, char *key_name ,char *value, struct head* head, struct temp_table_info* temp){

	if (head->head == NULL) {
		errno = ERR_TABLE_NOT_FOUND;
		return 2;
	}
	else {
		struct table* target_table = find_table(table_name, head);
		if(target_table == NULL) {
			errno = ERR_TABLE_NOT_FOUND;
			return 2;
		}
		else{
			if(strcmp(value, "null")){
				if(compare_formats(temp, target_table) == -1) return 4;
			}
			struct key* target_key = find_key(key_name, target_table);

			if(target_key == NULL){

				if(!strcmp(value,"null") || !strcmp(value,"NULL") || value == NULL){
					errno = ERR_KEY_NOT_FOUND;
					return 3;
				}
				else {
					if(target_table->number_records < MAX_RECORDS_PER_TABLE){
						struct key* new_key = create_key(key_name, value,temp);
						insert_key(new_key, target_table);
						return 0;
					}
					else{
						errno = ERR_UNKNOWN;
						return 3;
					}
				}
			}
			else if(target_key != NULL){

				if(!strcmp(value,"null") || !strcmp(value,"NULL") || value == NULL){

					delete_key(target_key, target_table);
					return 0;
				}
				else{//changed from simple stcpy of value
					delete_key(target_key, target_table);
					struct key* new_key = create_key(key_name, value,temp);
					insert_key(new_key, target_table);
					return 0;
				}
			}

		}
	}

return -1;

}


/**
 * @brief a function to get (retreive a value) from our database. Function is called from handle_command
 * @param table_name name of the table we must get from
 * @param key_name name of the key to retreive from
 * @param value returns the value inside 
 * @param head header to the database 
 * @return 0 for success, 1 for key not found, 2 table not found 
 */
int get_function(char *table_name, char *key_name, char *value, struct head* head){
		
	if(head->head == NULL){
		errno = ERR_TABLE_NOT_FOUND;
		return 2;
	}
	else{

		struct table* target_table = find_table(table_name, head);
		if(target_table == NULL){
			errno = ERR_TABLE_NOT_FOUND;
			return 2;
		}
		else{
			struct key* target_key = find_key(key_name, target_table);

			if(target_key == NULL){
				errno = ERR_KEY_NOT_FOUND;
				return 1;
			}
			else{
				strcpy(value, target_key->value);
				return 0;
			}
		}

	}

return -1;
}

/**
 * @brief function that compares if the format of the input (for storage_query) matches the columns/types of the table's format
 * @param temp_info a pointer to a struct that contains the format of the input sent
 * @param target_table contains the format of the table, this is compared with the temp provided in temp_info
 * @return returns -1 for failure, and 0 for success
 */
int compare_query_format(struct temp_table_info* temp_info, struct table* target_table) {
    int i = 0;
    while (temp_info->col_name[i][0] != '\0') {
        int found_match = 0;
        int x = 0;
        while ((target_table->col_name[x][0] != '\0') && !found_match) {
            if (!strcmp(target_table->col_name[x],temp_info->col_name[i])) found_match = 1;
            if(found_match){

            	if(!strcmp(temp_info->col_type[i],"int") && (!strcmp(target_table->col_type[x],"+int") || !strcmp(target_table->col_type[x],"-int") || !strcmp(target_table->col_type[x],"int"))){

            	}else if(!strcmp(temp_info->col_type[i], "char") && !strncmp(target_table->col_type[x],"char",4)){

            		char value[3];

            		value[0] = target_table->col_type[x][5];
            		value[1] = target_table->col_type[x][6];
            		value[2] = '\0';

            		int max_len = atoi(value);
            		if(strlen(temp_info->col_value[i]) > max_len) return -1;

            	 }
            	 else{

            		 return -1;//found no correct matches in type (no char/int)

            	 }
            }

            x++;
        }
        if(!found_match) return -1;
        i++;
    }
    return 0;
}

/**
 * @brief function that compares the formats of the user's input with the expected format in the table (used for storage_set)
 * @param temp_info contains the format of the columns/types/values of the user input 
 * @param target_table contains the format of the table, this is compared with the temp provided in temp_info
 * @return returns -1 for failure, and 0 for success
 */
int compare_formats(struct temp_table_info* temp_info, struct table* target_table) {
    int i = 0;
    if(strlen(temp_info->col_name) != strlen(target_table->col_name)) return -1;
    //if(strlen(temp_info->col_type) != strlen(target_table->col_type)) return -1;
    while (temp_info->col_name[i][0] != '\0' ) {
        if (strcmp(temp_info->col_name[i], target_table->col_name[i])) return -1;
        if(!strcmp(temp_info->col_type[i],"int") && (!strcmp(target_table->col_type[i],"+int") || !strcmp(target_table->col_type[i],"-int") || !strcmp(target_table->col_type[i],"int"))){

        	if(!strcmp(target_table->col_type[i],"+int")){
        		if(atoi(temp_info->col_value[i]) < 0) return -1;
        	}
        	else if(!strcmp(target_table->col_type[i],"-int")){
        		if(atoi(temp_info->col_value[i]) > 0) return -1;
        	}
        }
        else if(!strcmp(temp_info->col_type[i], "char") && !strncmp(target_table->col_type[i],"char",4)){

        	char value[3];

        	value[0] = target_table->col_type[i][5];
        	value[1] = target_table->col_type[i][6];
        	value[2] = '\0';
        	int max_len = atoi(value);

        	if(strlen(temp_info->col_value[i]) > max_len) return -1;

        }
        else{
        	return -1;
        }
        i++;
    }
    if(temp_info->col_name[i][0] == '\0' && target_table->col_name[i][0] != '\0') return -1;

    return 0;

}


/**
 * @brief a function that parses the query predicates. Function called from handle command
 * @param line to parse
 * @param temp_info stores the parsed information and format
 * @return returns -1 for failure, and 0 for success
 */
int query_parser(char* line, struct temp_table_info* temp_info) {

    char* split_on_comma = NULL;
    char col_name[300];
    char col_value[300];
    char operators;
    int p = 0;
    int i = 0;
    int j = 0;
    int counter = 0;
    int dotcheck = 0;
    int signcheck = 0;

    split_on_comma = strtok(line, ",");
    while (split_on_comma != NULL) {
        counter  = 0;
        i = 0;
        p = 0;
        int s =0;
        int filled_name = 0;
        int filled_operator = 0;
        int found_first_letter = 0;
        int found_last_letter = 0;
        int found_very_first_letter = 0;
        int save_index = 0;
        while(1){
        	if((split_on_comma[i] != '=' && split_on_comma[i] != '>' && split_on_comma[i] != '<') && !filled_name){
        		if(split_on_comma[i] != ' '){
        			col_name[s] = split_on_comma[i];
        			s++;
        		}
        		if(split_on_comma[i] == ' ' && !found_last_letter){
        			save_index = i;
        			found_last_letter = 1;
        		}
        		else if(!found_last_letter) save_index = i+1;
        	}
          	else if(!filled_name){
        		filled_name = 1;
        		col_name[s+1] = '\0';
        	}
        	if(filled_operator && filled_name && found_first_letter){
        	    col_value[p] = split_on_comma[i];
        	    p++;
        	}
        	if(filled_operator && filled_name && split_on_comma[i] != ' ' && !found_first_letter){
        		col_value[p] = split_on_comma[i];
        		p++;
        		found_first_letter = 1;
        	}
        	if(filled_name && !filled_operator){
        		operators = split_on_comma[i];
        		filled_operator = 1;
        	}
        	if(split_on_comma[i] == '\0') break;
        	i++;
        }
        if(col_name[0] == '\0') return -1;
        if(col_value[0] == '\0') return -1;
        if(operators == '\0') return -1;
        //sscanf(split_on_comma, "%s %c %[^'\n']",col_name, &operators, col_value);
        i = 0;
        while (col_value[i] != '\0')
            	{
               	 	if (isdigit(col_value[i]) == 0 ) {
               	 		if (col_value[i] != ' ' && col_value[i] != '.' && col_value[i] != '-' && col_value[i] != '+')
                    		counter++;
               	 	}
               	 	if(col_value[i] == '.') dotcheck++;
               	 	if(col_value[i] == '-' || col_value[i] == '+') signcheck++;
                	i++;
            	}
        if (counter != 0){
           //If it is a character.
           if (operators != '=')    return -1;

        }else if(counter == 0 && dotcheck > 0) return -1; // found double
        else if (operators != '>' && operators != '<' && operators != '=') return -1;
        //If counter > 0, it is a character else int.
        if (counter != 0){
            strcpy(temp_info->col_type[j], "char");
        }else if(counter == 0 && dotcheck > 0) return -1; // found double
        else strcpy(temp_info->col_type[j], "int");
        strcpy(temp_info->col_value[j], col_value);
        temp_info->operators[j][0] = operators;
        strcpy(temp_info->col_name[j], col_name);
        j++;
        split_on_comma = strtok(NULL, ",");


    }
    return 0;
}



/**
 * @brief parses the user's input for a set command and saves it's format in temp_info
 * @param line to parse
 * @param temp_info contains the saved info and format
 * @return returns -1 for failure, and 0 for success
 */
int input_parser(char* line, struct temp_table_info* temp_info)
{
    char* split_on_comma = NULL;
    char firstpart[300];
    char secondpart[300];
    int i = 0;
    int j = 0;
    split_on_comma = strtok(line, ",");

    while (split_on_comma != NULL) {
        int counter = 0;
        sscanf(split_on_comma, "%s %[^'\n]", firstpart, secondpart);
        // Add the col_name into the struct

        int dotcheck = 0;
        int signcheck = 0;
        i = 0;
        while (secondpart[i] != '\0')
            	{
               	 	if (isdigit(secondpart[i]) == 0 ) {
                            if (secondpart[i] != ' ' && secondpart[i] != '.' && secondpart[i] != '-' && secondpart[i] != '+')
                    		counter++;
               	 	}
               	 	if(secondpart[i] == '.') dotcheck++;
                	if(secondpart[i] == '-' || secondpart[i] == '+') signcheck++;
                	i++;
            	}
  	if(counter == 0){
        	//checks if number has spaces/weird symbols
        	int w = 0;
        	while(secondpart[w] != '\0'){
        		if(!isdigit(secondpart[w]) && secondpart[w] != '-' && secondpart[w] != '+') return -1;
        		w++;
        	}
        }
        //printf("%d\n", counter);
        if (counter != 0){
            strcpy(temp_info->col_type[j], "char");
        }else if(counter == 0 && dotcheck > 0) return -1; // found double
        else if(counter == 0 && signcheck > 1) return -1; //found too many pluses or minues
        else strcpy(temp_info->col_type[j], "int");
        strcpy(temp_info->col_value[j], secondpart);
        strcpy(temp_info->col_name[j], firstpart);
        j++;
        split_on_comma = strtok(NULL, ",");
    }

    return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////
//Hari's Parser Function /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////


/**
 * @brief a function that checks if the key's value satisfies the condition outlined by the operator 
 * @param target_key is the key checked
 * @param index_col holds the correct index for the key's column/value to match the provided value's type
 * @param operators condition to be checked
 * @return returns the key struct if valid, null if not
 */
struct key* check_key(struct key* target_key, int index_col,char* operators, char* type, char* value){

    if(*operators == '='){
        if(!strcmp(target_key->value_per_col[index_col],value)) return target_key;
        else return NULL;
    }
    else if(*operators == '>'){
        int key_val = atoi(target_key->value_per_col[index_col]);
        int check_val = atoi(value);

        if(key_val > check_val) return target_key;
        else return NULL;
    }
    else if(*operators == '<'){
        int key_val = atoi(target_key->value_per_col[index_col]);
        int check_val = atoi(value);

        if(key_val < check_val)return target_key;
        else return NULL;
    }
    else return NULL;

}



/**
 * @brief takes a set of conditions (col_info) and finds all the keys in the supplied table that match all the conditions
 * @param target_table a struct to the configuartion of that particular table
 * @param col_info holds the parsed conditions (from query_parser)
 * @param key_array holds the keys that satisfy all the conditions
 * @return returns -1 for failure, and 0 for success
 */
int table_query(struct table* target_table, struct temp_table_info* col_info, struct key* key_array[]){
    int p;
    int i = 0;
    int x;
    int j;
    int index_col = 0;
    int l = 0;
    int h = 0;
    struct key* Arr_Keys[100][100];

    while(Arr_Keys[l][0] != NULL){
    	h = 0;
    	while(Arr_Keys[l][h] != NULL){

    		Arr_Keys[l][h] = NULL;
    		h++;
    	}
    	l++;
    }
    h=0;
    l=0;

    while(col_info->col_name[i][0] != NULL){

        struct key* probe = target_table->head;

        x =0;
        while(target_table->col_name[x][0] != NULL){

            if(!strcmp(target_table->col_name[x],col_info->col_name[i])) index_col = x;

            x++;

        }

        j = 0;
        while(probe != NULL){

            struct key* target_key;

            target_key = check_key(probe, index_col, col_info->operators[i],col_info->col_type[i],col_info->col_value[i]);

            if(target_key != NULL){
            	Arr_Keys[i][j] = target_key;
                j++;
            }

            probe = probe->next;

        }

        i++;

    } /// filled Arr_Keys with the keys that satisfied at least one of the conditions now checking which keys match all conditions

    int w = 0;
    int g = 0;
    j = 0;
    struct key* matches_found[100][100];

    while(matches_found[l][0] != NULL){
        	h = 0;
        	while(matches_found[l][h] != NULL){

        		matches_found[l][h] = NULL;
        		h++;
        	}
        	l++;
        }
    l=0;
    h=0;

    while(Arr_Keys[0][w] != NULL){
        int p = 0;
        //only one condition pass all matches found
        if(Arr_Keys[1][0] == NULL) {
        	while(Arr_Keys[0][j] != NULL){
        	key_array[j] = Arr_Keys[0][j];
        	j++;
        	}
        	return 0;
        }
        while(Arr_Keys[1][p] != NULL){


        	if(Arr_Keys[0][w] == Arr_Keys[1][p]){

                matches_found[0][g] = Arr_Keys[1][p];
                g++;

            }
            p++;

        }
        w++;

    }

    i = 2;
    j = 0;
    x = 0;
    int only_two_pred = 1;
    while(Arr_Keys[i][j] != NULL){
        int f = 0;
        only_two_pred = 0;
        while(matches_found[x][f] != NULL){
        	p = 0;
            f = 0;
            while(matches_found[x][f]!=NULL){
                j = 0;
                while(Arr_Keys[i][j]!=NULL){

                        if(Arr_Keys[i][j] == matches_found[x][f]){

                                matches_found[x+1][p] = matches_found[x][p];
                                p++;

                        }
                        j++;

                }
                f++;

            }
            x++;

        }
        i++;

    }// after this all the matching keys should be stored in matches_found[x][~];
    int q = 0;

    if(only_two_pred){

    	while(matches_found[0][q] != NULL){
    		key_array[q] = matches_found[0][q];
    		q++;

    	}
    	return 0;
    }
    for(q = 0; q<p; q++){

        key_array[q] = matches_found[x][q];

    }
    return 0;
}





