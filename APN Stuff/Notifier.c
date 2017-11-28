// Import Libs
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

/** Struct Def **/
// Events Class
struct Event {
	long id;
	char* name;
	long time;
	long latitude;
	long longitude;
	char* interests;
};

// User Class
struct User {
	long id;
	char* name;
	long* eventIDs;
	char* devID;
	long latitude;
	long longitude;
	char* interests;
};

/** Global Vars **/
struct Event* eventList;
struct User* userList;
const int BUF_SIZE = 1024;
const int EL_SIZE = 256;
int UPDATE = 0;

// Used to Build Event List
int extractEvents(int fd) {
	// Check FD
	if (fd < 0)
		return -1;

	// Reset Offset
	lseek(fd, 0, SEEK_SET);

	// Create Buffer
	int fdPointer = 0;
	char* buf = (char*)malloc(BUF_SIZE*sizeof(char));
	memset(buf, 0, BUF_SIZE*sizeof(char));

	// Fill Buffer
	int readSize = BUF_SIZE;
	char* startP = NULL;
	while(readSize == BUF_SIZE && startP == NULL) {
		readSize = read(fd, buf, BUF_SIZE);
		fdPointer += readSize;
		startP = strstr(buf, "`Event_Prod` VALUES ('");
	}

	// Handle Not Found
	if (startP == NULL)
		return -1;
	else {
		// Trace Back
		int backTrace = 0;
		while (&buf[backTrace] != startP)
			backTrace++;

		// Compute File Offset
		fdPointer -= (BUF_SIZE - backTrace);
		fdPointer += strlen("`Event_Prod` VALUES (");
		lseek(fd, fdPointer, SEEK_SET);
	}

	// Free Buffer
	free(buf);

	// Allocate New Buffer
	buf = (char*)malloc((BUF_SIZE*64)*sizeof(char));
	memset(buf, 0, (BUF_SIZE*64)*sizeof(char));

	// Read till Closure ');'
	int i = 0;
	readSize = 1;
	while(readSize == 1 && strstr(buf, ");") == NULL)
		readSize = read(fd, &buf[i++], 1);
	buf[i-1] = '\0';
	buf[i-2] = '\0';

	// Allocate for EventList
	eventList = (struct Event*)malloc(EL_SIZE*sizeof(struct Event));
	memset(eventList, 0, EL_SIZE*sizeof(struct Event));
	int EP = 0;

	// Split Into Events
	char* eventStr = buf;
	char* deliminator = buf;
	do {
		// Split
		deliminator = strstr(eventStr, "),(");
		if(deliminator != NULL)
			*deliminator = '\0';

		/** Parse an Event **/
		// Grow List

		// Get Values
		char* id_str;
		char* name_str;
		char* time_str;

		// Get ID
		id_str = strtok(eventStr, ",");
		id_str++;
		id_str[strlen(id_str) - 1] = '\0';

		// Get Time
		time_str = strtok(NULL, ",");
		strtok(NULL, ",");

		// Get Name
		name_str = strtok(NULL, ",");
		name_str++;
		name_str[strlen(name_str) - 1] = '\0';

		// Add Event
		eventList[EP].id = strtol(id_str, NULL, 16);
		eventList[EP].name = strdup(name_str);
		eventList[EP].time = strtol(time_str, NULL, 10);
		EP++;

		// Jump
		if(deliminator != NULL)
			eventStr = deliminator + strlen("),(");

	} while(deliminator != NULL);

	// Free Buffer
	free(buf);
}

// Used to Print & Free Event List (ONLY use @ the End)
void freeEvents() {
	// Iterate
	int EP = 0;
	while(eventList[EP].name != NULL) {
		// Print
		printf("===============================> Event %d\n", EP + 1);
		printf("ID:\t%ld\n", eventList[EP].id);
		printf("Name:\t%s\n", eventList[EP].name);
		printf("Time:\t%ld\n\n", eventList[EP].time);

		// Free
		free(eventList[EP].name);

		// Increment
		EP++;
	}

	// Free
	free(eventList);
}


// Used to Build User List
int extractUsers(int fd) {
	// Check FD
	if (fd < 0)
		return -1;

	// Reset Offset
	lseek(fd, 0, SEEK_SET);

	// Create Buffer
	int fdPointer = 0;
	char* buf = (char*)malloc(BUF_SIZE*sizeof(char));
	memset(buf, 0, BUF_SIZE*sizeof(char));

	// Fill Buffer
	int readSize = BUF_SIZE;
	char* startP = NULL;
	while(readSize == BUF_SIZE && startP == NULL) {
		readSize = read(fd, buf, BUF_SIZE);
		fdPointer += readSize;
		startP = strstr(buf, "`User_Prod` VALUES ('");
	}

	// Handle Not Found
	if (startP == NULL)
		return -1;
	else {
		// Trace Back
		int backTrace = 0;
		while (&buf[backTrace] != startP)
			backTrace++;

		// Compute File Offset
		fdPointer -= (BUF_SIZE - backTrace);
		fdPointer += strlen("`User_Prod` VALUES (");
		lseek(fd, fdPointer, SEEK_SET);
	}

	// Free Buffer
	free(buf);

	// Allocate New Buffer
	buf = (char*)malloc((BUF_SIZE*64)*sizeof(char));
	memset(buf, 0, (BUF_SIZE*64)*sizeof(char));

	// Read till Closure ');'
	int i = 0;
	readSize = 1;
	while(readSize == 1 && strstr(buf, ");") == NULL)
		readSize = read(fd, &buf[i++], 1);
	buf[i-1] = '\0';
	buf[i-2] = '\0';

	// Allocate for UserList
	userList = (struct User*)malloc(EL_SIZE*sizeof(struct User));
	memset(userList, 0, EL_SIZE*sizeof(struct User));
	int UP = 0;

	// Split Into Events
	char* userStr = buf;
	char* deliminator = buf;
	do {
		// Split
		deliminator = strstr(userStr, "),(");
		if(deliminator != NULL)
			*deliminator = '\0';

		/** Parse an Event **/
		// Grow List

		// Get Values
		char* id_str;
		char* name_str;
		char* eventIDs_str;
		char* devID_str;

		// Get ID
		id_str = strtok(userStr, ",");
		id_str++;
		id_str[strlen(id_str) - 1] = '\0';

		// Get Name
		name_str = strtok(NULL, ",");
		name_str++;
		name_str[strlen(name_str) - 1] = '\0';

		// Get DevID
		devID_str = strtok(NULL, ",");
		devID_str++;
		devID_str[strlen(devID_str) - 1] = '\0';
		strtok(NULL, ",");
		strtok(NULL, ",");

		// Get EventIDs
		eventIDs_str = strtok(NULL, ",");
		eventIDs_str++;
		eventIDs_str[strlen(eventIDs_str) - 1] = '\0';

		// Add User
		userList[UP].id = strtol(id_str, NULL, 16);
		userList[UP].name = strdup(name_str);
		userList[UP].eventIDs = (long*)malloc(((strlen(eventIDs_str)/13) + 1)*sizeof(long));
		memset(userList[UP].eventIDs, 0, ((strlen(eventIDs_str)/13) + 1)*sizeof(long));
		int IP = 0;
		char* idStr = strtok(eventIDs_str, "^");
		while(idStr != NULL) {
			userList[UP].eventIDs[IP] = strtol(idStr, NULL, 16);
			idStr = strtok(NULL, "^");
			IP++;
		}
		userList[UP].devID = strdup(devID_str);
		UP++;

		// Jump
		if(deliminator != NULL)
			userStr = deliminator + strlen("),(");

	} while(deliminator != NULL);

	// Free Buffer
	free(buf);
}

// Used to Print & Free Event List (ONLY use @ the End)
void freeUsers() {
	// Iterate
	int UP = 0;
	while(userList[UP].name != NULL) {
		// Print
		printf("===============================> User %d\n", UP + 1);
		printf("ID:\t%ld\n", userList[UP].id);
		printf("Name:\t%s\n", userList[UP].name);
		printf("DevID:\t%s\n", userList[UP].devID);
		int IP = 0;
		while(userList[UP].eventIDs[IP] != 0) {
			printf("E%d:\t%ld\n", IP + 1, userList[UP].eventIDs[IP]);
			IP++;
		}
		printf("\n");

		// Free
		free(userList[UP].name);
		free(userList[UP].eventIDs);
		free(userList[UP].devID);

		// Increment
		UP++;
	}

	// Free
	free(userList);
}

// DB Spin Lock
int dbSpinLock() {
	// Busy Wait
	while(1) {
		// File
		int fd = open("./bMount/DB.sql", O_RDONLY);

		// Check FD
		if (fd < 0)
			return -1;

		// Create Buffer
		int fdPointer = 0;
		char* buf = (char*)malloc(BUF_SIZE*sizeof(char));
		memset(buf, 0, BUF_SIZE*sizeof(char));

		// Fill Buffer
		int readSize = BUF_SIZE;
		char* startP = NULL;
		while(readSize == BUF_SIZE && startP == NULL) {
			readSize = read(fd, buf, BUF_SIZE);
			fdPointer += readSize;
			startP = strstr(buf, "`notification` VALUES (");
		}

		// Handle Not Found
		if (startP == NULL)
			return -1;
		else {
			// Trace Back
			int backTrace = 0;
			while (&buf[backTrace] != startP)
				backTrace++;

			// Compute File Offset
			fdPointer -= (BUF_SIZE - backTrace);
			fdPointer += strlen("`notification` VALUES (");
			lseek(fd, fdPointer, SEEK_SET);
		}

		// Free Buffer
		free(buf);

		// Read
		int val;
		int n = read(fd, &val, 1);

		// Read Again if Error
		if(n != 1)
			return -1;

		// Close
		close(fd);

		// Check
		if(val != UPDATE) {
			UPDATE = val;
			break;
		}
	}
}

// Used to Run Notifications
void notify() {
	// Loop till Update
	//if (dbSpinLock() == -1)
	//	return;

	// Open
	int fd = open("./cMount/DB.sql", O_RDONLY);
	if (fd < 0)
		return;

	/** Extract **/
	// Exctract Event List
	if (extractEvents(fd) == -1 || extractUsers(fd) == -1)
		return;

	// Compute
	long TIME = (long)time(NULL);
	int UP;
	for(UP = 0; userList[UP].name != NULL; UP++) {
		int IP;
		for(IP = 0; userList[UP].eventIDs[IP] != 0; IP++) {
			int EP;
			for(EP = 0; eventList[EP].name != NULL; EP++) {
				if(eventList[EP].id == userList[UP].eventIDs[IP]) {
					if(eventList[EP].time - TIME > 10 && eventList[EP].time - TIME < 60) {
						/** Execute APN **/
						chmod("./bashScript", S_IRWXU);
						int ret = fork();
						if(ret == 0) {
							char* args[4] = {"./bashScript", userList[UP].devID, eventList[EP].name, NULL};
							execvp("./bashScript", args);
							perror("execvp");
						}
						waitpid(ret, NULL, 0);
					}
				}
			}
		}
	}

	// Print
	freeEvents();
	freeUsers();
	printf("Time: %lu\n+++++++++++++++++================---------------->>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<\n\n", TIME);

	// Close
	close(fd);
}

// Converts interests string(separated by ^) to interests array.
char** extractInterests(char* str)
{
  char* dup = strdup(str);
	char* temp = strtok(dup, "^");
	char** interests = (char**)malloc(256*sizeof(char*));    // Remember to free this after using it!
	int i = 0;
	// If passed string is empty, return NULL
	if(!temp)
		return NULL;

	// Loop to fill up array from string(interests separated by ^)
	while(temp != NULL)
	{
		interests[i++] = strdup(temp);		// Remember to free this after using it!
		temp = strtok(NULL, "^");
	}
  free(dup);

	return interests;
}

// Compares an event's interests with a user's interests.
// Returns 1 if a match was found, 0 Otherwise.
int matchInterest(struct Event event, struct User user)
{
	int e = 0;
	int u = 0;
	// Extract interests.
	char** eI = extractInterests(event.interests);
	char** uI = extractInterests(user.interests);
	// If either one is empty, return 0(no match).
	if(eI == NULL || uI == NULL)
		return 0;

	// Loop until a match is found.
	while(eI[e] != NULL)
	{
		u = 0;
		while(uI[u] != NULL)
		{
			if(strcmp(eI[e], uI[u]) == 0)
			{
				return 1;
			}
			u++;
		}
		e++;
	}
	return 0;
}

int main() {
	// Notify
	while(1)
		notify();
}
