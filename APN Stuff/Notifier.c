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
#include <math.h>
#define pi 3.14159265358979323846

/** Struct Def **/
// Events Class
struct Event {
	long id;
	char* name;
	long time;
	float latitude;
	float longitude;
	char* interests;
};

// User Class
struct User {
	long id;
	char* name;
	long* eventIDs;
	char* devID;
	float latitude;
	float longitude;
	char* interests;
};

// Log Entry
struct Ent {
	long uID;
	long eID;
};

/** Global Vars **/
struct Event* eventList;
struct User* userList;
struct Ent logs[1024];
int logCount = 0;
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
		char* interest_str;
		char* lat_str;
		char* long_str;

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

		// Get Interest
		interest_str = strtok(NULL, ",");
		interest_str++;
		interest_str[strlen(interest_str) - 1] = '\0';

		// Get Latitude
		lat_str = strtok(NULL, ",");
		lat_str[strlen(lat_str) - 1] = '\0';

		// Get Longitude
		long_str = strtok(NULL, ",");
		long_str[strlen(long_str) - 1] = '\0';

		// Add Event
		eventList[EP].id = strtol(id_str, NULL, 16);
		eventList[EP].name = strdup(name_str);
		eventList[EP].time = strtol(time_str, NULL, 10);
		eventList[EP].interests = strdup(interest_str);
		eventList[EP].latitude = atof(lat_str);
		eventList[EP].longitude = atof(long_str);
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
		printf("Time:\t%ld\n", eventList[EP].time);
		printf("Interests:\t%s\n", eventList[EP].interests);
		printf("Latitude:\t%f\n", eventList[EP].latitude);
		printf("Longitude:\t%f\n\n", eventList[EP].longitude);

		// Free
		free(eventList[EP].name);
		free(eventList[EP].interests);

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
		char* interest_str;
		char* lat_str;
		char* long_str;

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

		// Get Interest
		interest_str = strtok(NULL, ",");
		interest_str++;
		interest_str[strlen(interest_str) - 1] = '\0';

		// Get Latitude
		lat_str = strtok(NULL, ",");
		lat_str[strlen(lat_str) - 1] = '\0';

		// Get Longitude
		long_str = strtok(NULL, ",");
		long_str[strlen(long_str) - 1] = '\0';

		// Get EventIDs
		eventIDs_str = strtok(NULL, ",");
		eventIDs_str++;
		eventIDs_str[strlen(eventIDs_str) - 1] = '\0';

		// Add User
		userList[UP].id = strtol(id_str, NULL, 16);
		userList[UP].name = strdup(name_str);
		userList[UP].interests = strdup(interest_str);
		userList[UP].latitude = atof(lat_str);
		userList[UP].longitude = atof(long_str);
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
		printf("Interests:\t%s\n\n", userList[UP].interests);
		printf("Latitude:\t%f\n", userList[UP].latitude);
		printf("Longitude:\t%f\n\n", userList[UP].longitude);
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
		free(userList[UP].interests);

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

// Returns 1 if combination is found in logs.
// If not found, add entry to logs and return 0.
int logInterests(struct Event event, struct User user)
{
    // New entry with user id and event id combination
    struct Ent entry = {.uID = user.id, .eID = event.id};
    int i;
    int found = 0;
    // loop through logs to check if combination is there.
    for(i = 0; i < logCount; i++)
    {
        if((entry.uID == logs[i].uID) && (entry.eID == logs[i].eID))
        {
            found = 1;
        }
    }

    if(found == 1)
    {
        return 1;
    }
    else
    {
        logs[logCount++] = entry;
        return 0;
    }
}

void freeInterests(char** array)
{
	int i = 0;
	while(strcmp(array[i], ""))
	{
		free(array[i]);
		// array[i] = NULL;
		i++;
	}
	free(array);
	array = NULL;
}

char** extractInterests(char* str)
{
  char* dup = strdup(str);
	char* temp = strtok(dup, "^");
	char** interests = (char**)malloc(1024*sizeof(char*));    // Remember to free this after using it!
	int k;
	for(k = 0; k < 1024; k++)
	{
		interests[k] = "";
	}
	int i = 0;
	if(!temp)
	{
		free(interests);
		free(dup);
		interests = NULL;
		dup = NULL;
		return NULL;
	}

	while(temp != NULL)
	{
		interests[i++] = strdup(temp);		// Remember to free this after using it!
		temp = strtok(NULL, "^");
	}
  free(dup);
	dup = NULL;

	return interests;
}

// New Interest
int matchInterest(struct Event event, struct User user)
{
	int e = 0;
	int u = 0;
	char** eI = extractInterests(event.interests);
	char** uI = extractInterests(user.interests);
	if(eI == NULL && uI == NULL)
	{
		return 0;
	}
	if(eI == NULL && uI != NULL)
	{
		// freeInterests(eI);
		freeInterests(uI);
		return 0;
	}
	if(eI != NULL && uI == NULL)
	{
		freeInterests(eI);
		// freeInterests(uI);
		return 0;
	}

	while(strcmp(eI[e], ""))
	{
		u = 0;
		while(strcmp(uI[u], ""))
		{
			if(strcmp(eI[e], uI[u]) == 0)
			{
				freeInterests(eI);
				freeInterests(uI);
				return 1;
			}
			u++;
		}
		e++;
	}
	freeInterests(eI);
	freeInterests(uI);
	return 0;
}

double deg2rad(double deg) {
    return (deg * pi / 180);
}
double rad2deg(double rad) {
    return (rad * 180 / pi);
}
//calculate distance between the user and event using their longitutde and latitude
//return -1 if error occured
//return 1 if the event is in range
//return 0 if the event is not in range
int inRange(struct User user , struct Event event ,double range){
    if(user.longitude == 0 || event.longitude == 0 || user.latitude == 0 || event.latitude == 0){
        return -1;
    }
    double theta, dist;
    theta = user.longitude - event.longitude;
    dist = sin(deg2rad(user.latitude)) * sin(deg2rad(event.latitude)) + cos(deg2rad(user.latitude)) * cos(deg2rad(event.latitude)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60.0 * 1.1515;
    printf("Distance in miles is : %f\n",dist );
    if (dist <= range) {
        return 1;
    }
    return 0;
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
		int EP;
		for(EP = 0; eventList[EP].name != NULL; EP++) {
			if((matchInterest(eventList[EP], userList[UP]) == 1 || inRange(userList[UP], eventList[EP], 0.25) == 1) && logInterests(eventList[EP], userList[UP]) == 0) {
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

	// Print
	freeEvents();
	freeUsers();
	printf("Time: %lu\n+++++++++++++++++================---------------->>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<\n\n", TIME);

	// Close
	close(fd);
}

// Main
int main() {
	// Notify
	while(1)
		notify();
}
