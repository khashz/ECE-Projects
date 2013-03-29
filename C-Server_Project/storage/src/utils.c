/**
 * @file
 * @brief This file implements various utility functions that 
 * can be used by the storage server and client library.
 */

#define _XOPEN_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include "utils.h"
#include "loghelp.h"


int sendall(const int sock, const char *buf, const size_t len)
{
	size_t tosend = len;
	while (tosend > 0) {
		ssize_t bytes = send(sock, buf, tosend, 0);
		if (bytes <= 0)
			break; // send() was not successful, so stop.
		tosend -= (size_t) bytes;
		buf += bytes;
	};

	return tosend == 0 ? 0 : -1;
}

/**
 * In order to avoid reading more than a line from the stream,
 * this function only reads one byte at a time.  This is very
 * inefficient, and you are free to optimize it or implement your
 * own function.
 */
int recvline(const int sock, char *buf, const size_t buflen)
{
	int status = 0; // Return status.
	size_t bufleft = buflen;

	while (bufleft > 1) {
		// Read one byte from scoket.
		ssize_t bytes = recv(sock, buf, 1, 0);
		if (bytes <= 0) {
			// recv() was not successful, so stop.
			status = -1;
			break;
		} else if (*buf == '\n') {
			// Found end of line, so stop.
			*buf = 0; // Replace end of line with a null terminator.
			status = 0;
			break;
		} else {
			// Keep going.
			bufleft -= 1;
			buf += 1;
		}
	}
	*buf = 0; // add null terminator in case it's not already there.

	return status;
}

/**
 * @brief takes a line passed in from the read configuration function and stores it in the appropriate structs
 * @param line is each line inside the config file
 * @param params is the struct that will hold the entire config file... split into arrays
 * @param host is the counter used through each function call -used for error checking
 * @param port is the counter used through each function call -used for error checking
 * @param user is the counter used through each function call -used for error checking
 * @param pass is the counter used through each function call -used for error checking
 * @return returns 0 for success, -1 for failure
 */
int process_config_line(char *line, struct config_params *params, int *host,int *port,int *user,int *pass)
{
	// Ignore comments.
	if (line[0] == CONFIG_COMMENT_CHAR || line[0] == ' ' || line[0] == '\t' || line[0] == '\n')
		return 0;
	// Extract config parameter name and value.
	char name[MAX_CONFIG_LINE_LEN];
	char value[MAX_CONFIG_LINE_LEN];
	int items = sscanf(line, "%s %s\n", name, value);
	// Line wasn't as expected.
	if (items != 2)
		return -1;
	// Process this line.
	if (strcmp(name, "server_host") == 0) {
		if (*host == 1)
			return -1;
		*host = 1;
		strncpy(params->server_host, value, sizeof params->server_host);
	} else if (strcmp(name, "server_port") == 0) {
		if (*port == 1)
			return -1;
		*port = 1;
		params->server_port = atoi(value);
	} else if (strcmp(name, "username") == 0) {
		if (*user == 1)
			return -1;
		*user = 1;
		strncpy(params->username, value, sizeof params->username);
	} else if (strcmp(name, "password") == 0) {
		if (*pass == 1)
			return -1;
		*pass = 1;
		strncpy(params->password, value, sizeof params->password);
	} else if (strcmp(name, "table") == 0) {
		int i;
		for (i = 0; i < MAX_TABLES; i++) {
			if ((strcmp(params->table[i], value) == 0))
				return -1;
		}
		params->index++;
		// save for the table name array 
		strncpy(params->table[params->index],value, MAX_TABLE_LEN);
		// from here on, we save into the new struct
		// over here we have the entire line, we have to save it into our tableInfo

		// this statement saves each name into the struct, with its index
		strncpy(params->tableInfo[params->index].table_names,value, MAX_TABLE_LEN);

		




// ###################################################################   start of weylin's config
		char* split_on_space = NULL;   
    		char* split_on_com = NULL;

   		char line2[MAX_CONFIG_LINE_LEN];
    		char value[MAX_CONFIG_LINE_LEN];
    		char value_type[MAX_CONFIG_LINE_LEN];
    		char *result = NULL;

    		int k = 1;
    		int j = 0;

   		int counter = 0;

		//Code Fragment removes the first two parts of line and stores it in line2
    		split_on_space = strtok(line, " ");
    		while (split_on_space != NULL)
    		{
        		if (k != 1 && k != 2)
        		{
            		//for first case, uses strcpy instead of strcat so it doesnt copy garbage values.
            			if(j == 0)
            			{
                			strcpy(line2, split_on_space);
                			j++;
            			}
            			else strcat(line2, split_on_space);
        		}
        		k++;
        		split_on_space = strtok(NULL, " ");
    		}

    		split_on_com = strtok(line2, ",");
    		j = 0;

		//At this point, there is no spaces in the input.
		int incrementer_for_name = 0;
    		while (split_on_com != NULL)
    		{
        		sscanf(split_on_com, "%[^':']%s", value,value_type);
			// at this point, each iteration holds the name
        		//printf("%s\n", value);
			strncpy(params->tableInfo[params->index].name_for_column[incrementer_for_name], value, strlen(value));
			if (value_type[0] != ':') return -1;
			if (value_type[1] == '\0') return -1;
			memmove(value_type, value_type+1, strlen(value_type));
        		//moves the string one over to get rid of the colon character

        		//Error checking to make sure value_type == to int or char
        	if (strncmp(value_type,"char", 4) == 0)
       		 {

            	int i;
            	for(i=3; i<strlen(value_type); i++)
            	{
                	if(value_type[i]== '[')
                    		result = &value_type[i+1];
            	}
            	if (result == NULL)
            	{
                	//return error
                	return -1;
            	}	

            	while (*result != ']' || result == NULL)
            	{
               	 	if (isdigit(*result) == 0 )
                    		counter++;
                	result++;
            	}


            	if ((counter != 0))
            	{
                	//input isnt valid, return error
                	return -1;
            	}
        	}
       	 	else if ((strcmp(value_type,"int") != 0) && (strcmp(value_type, "+int") != 0) && (strcmp(value_type, "-int")) != 0)
        	{
            		return -1;
        	}

        	//At this point, all input is valid.
        	//printf("%s\n", value_type);
		strncpy(params->tableInfo[params->index].type_for_name[incrementer_for_name], value_type, strlen(value_type));
  		//Go to next string separated by comma
        	split_on_com = strtok(NULL, ",");
		incrementer_for_name++;
    	}	
// ###################################################################	end of weylin's config	
	}
	else {
		// Ignore unknown config parameters.
	}
	return 0;
}

/**
 * @brief opens and reads the entire config file, parsing and storing them to structs used in other files
 * @param config_file is the name of the config file being parsed
 * @param params is a structure that holds everything inside the configuration file
 * @return returns 0 for success, -1 for failure
 */
int read_config(const char *config_file, struct config_params *params){
	int error_occurred = 0;
	//Below variables are used in process_config_line to check for duplicity of parameters
	int mulhost = 0;
	int mulport = 0;
	int muluser = 0;
	int j = 0;
	int mulpass = 0;
	params->index = -1;
	int i = 0;
	int error_occured = 0;
	// Open file for reading.

	FILE *file = fopen(config_file, "r");
	if (file == NULL)
		error_occured = 1;
	// Process the config file.
	while (!error_occurred && !feof(file)) {
		// Read a line from the file.
		char line[MAX_CONFIG_LINE_LEN];
		char *l = fgets(line, sizeof line, file);

		// Process the line.
	if (l == line){
		int temp = process_config_line(line, params, &mulhost, &mulport, &muluser, &mulpass);

	//process_config_line(line, params, &mulhost, &mulport, &muluser, &mulpass);
	if (temp == -1)
		error_occurred = 1;
	}

	else if (!feof(file))
		error_occurred = 1;

	}
	if (error_occurred == 1) return -1;
	
return error_occurred ? -1 : 0;
}

/**
 * @brief either writes to stdout, a file or does nothing according to the LOGGING constant set in the loghelp.h file
 * @param file is a pointer to the file created to log to
 * @param message is what we want to write to either the file, stdout or 
 * @return nothing
 */
void logger(FILE *file, char *message)
{
	if (LOGGING==2){
	fprintf(file,"%s",message);
	fflush(file);
	}
	else if (LOGGING == 1) {
		printf("%s",message);
	}
}

char *generate_encrypted_password(const char *passwd, const char *salt)
{
	if(salt != NULL)
		return crypt(passwd, salt);
	else
		return crypt(passwd, DEFAULT_CRYPT_SALT);
}

