#include <stdio.h>
#include <ctype.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <termios.h>

#include <pwd.h>
#include <sys/types.h>

#define UP		65
#define DOWN	66
#define LEFT	68
#define RIGHT	67

#define BUFF_SIZE 256
#define COMMAND_SIZE 512

#define HEADER_HEIGHT 14

#define COLOR_RED	"\033[37;41m"
#define COLOR_GREEN	"\033[37;42m"
#define COLOR_TRANS	""

#define MAX_COLUMN 20

#define DEPTH_USER 0
#define DEPTH_PROC 1

#define clear() printf("\033[H\033[J")
#define move(x, y) printf("\033[%d;%dH", x, y)
#define print(x, y, color, format, ...)	printf("\033[%d;%dH" color format "\033[0m", x, y, ##__VA_ARGS__)

#define printUser(index, color, ...) print(HEADER_HEIGHT + 2 + index, 2, color, "%20s", ##__VA_ARGS__)

#define printProc(index, color, cmd, pid, stime) print(HEADER_HEIGHT + 2 + index, 2 + 21, color, "%-20s%c%7s%c%8s", cmd, 124, pid, 124, stime)

#define B printf("%c", 124)
#define U printf("%c", 95)
#define S printf("%c", 32)
#define R printf("\\")
//#define R printf("%c", 124)
#define L printf("/")
#define E printf(">")
#define W printf("<")
#define N printf("\n")

typedef struct Proc {
	char cmd[BUFF_SIZE];
	char pid[BUFF_SIZE];
	char stime[BUFF_SIZE];

	struct Proc* next;
} Proc;

typedef struct User {
	int id;
	char name[BUFF_SIZE];

	struct User* next;
} User;

Proc* procList = NULL;

void drawFrame() {
	int index = 0;

    printf("______                           _     _                 \n");
    printf("| ___ ＼                        | |   (_)                \n");
    printf("| |_/  / _ __   __  _    ____   | |_   _   ____   ____   \n");
    printf("|  __ / |  __| /  _  |  /  __|  | __| | | /  __| /  _ ＼ \n");
    printf("|  |    |  |  |  ( | | |  (__   | |_  | ||  (__ |   __/  \n");
    printf("＼_|    |__|  ＼__,__| ＼____|  ＼__| |_|＼____|＼____|  \n");
    printf("                                                        \n");
    printf("(_)           |  |     (_)                             \n");
    printf(" _   __ ___   |  |      _   __ ___    __   __   __   __       \n");
    printf("| | |   _  ＼ |  |     | | |   _  ＼ |  | |  | ＼ ＼/ /       \n");
    printf("| | |  | |  | |  |____ | | |  | |  | |  |_|  |  >     <        \n");
    printf("|_| |__| |__| ＼_____/ |_| |__| |__| ＼___,__|  /_/＼_＼     \n");
	printf("\n");
	printf("\n");

	printf("-NAME-----------------CMD------------------PID-----STIME----\n");
	for (index = 0 ; index < MAX_COLUMN ; ++index) {
		printf("%c" "%20s" "%c" "%20s" "%c" "%7s" "%c" "%8s" "%c" "\n", 124, "", 124, "", 124, "", 124, "", 124);
	}
	printf("------------------------------------------------------------\n");
	printf("If you want to exit , Please Type 'q' or 'Q'\n");
}

typedef struct Index {
	int begin;
	int current;
	int end;

	int size;
} Index;

User* loadUsers(Index* index) {
	User* root = NULL;
	User* cursor = NULL;

	struct passwd* pwd;

	index->size = 0;

	while ((pwd = getpwent()) != NULL) {
		if (strncmp(pwd->pw_shell, "/bin/bash", 10) == 0) {

			if (root == NULL) {
				cursor = (root = (User*) malloc(sizeof(User)));
			} else {
				cursor = (cursor->next = (User*) malloc(sizeof(User)));
			}

			strcpy(cursor->name, pwd->pw_name);
			cursor->id = pwd->pw_uid;
			cursor->next = NULL;

			index->size += 1;
		}
	}

	endpwent();

	return root;
}

void copy(char* dest, char* src) {
	int begin = 0;
	int end = strlen(src) - 1;

	for ( ; *(src + begin) == ' ' ; ++begin);
	for ( ; *(src + end) == ' ' ; --end);

	strncpy(dest, src + begin, end - begin + 1);
	dest[end - begin + 1] = '\0';
}

void releaseProcs() {
	Proc* temp = NULL;
	Proc* cursor = procList;

	while (cursor != NULL) {
		temp = cursor->next;
		free(cursor);
		cursor = temp;
	}

	procList = NULL;
}

void loadProcs(User* user, Index* index) {
	Proc* root = NULL;
	Proc* cursor = NULL;

	int field = 0;
	char* ptr = NULL;
	FILE* file = NULL;
	char buff[BUFF_SIZE] = { 0, };
	char command[COMMAND_SIZE] = { 0, };

	index->size = 0;
	index->begin = 0;
	index->current = 0;
	index->end = 19;

	releaseProcs();

	sprintf(command, "/bin/ps -u %s --no-headers -o command:20 -o \",%%p,\" -o stime:8", user->name);

	if ((file = popen(command, "r")) == NULL) {
		return;
	}

	while(fgets(buff, BUFF_SIZE, file) != NULL) {
		if (root == NULL) {
			cursor = (root = (Proc*) malloc(sizeof(Proc)));
		} else {
			cursor = (cursor->next = (Proc*) malloc(sizeof(Proc)));
		}

		field = 0;
		ptr = strtok(buff, ",");

		while (ptr != NULL) {

			switch (field++) {
				case 0:
					copy(cursor->cmd, ptr);
					break;

				case 1:
					copy(cursor->pid, ptr);
					break;

				case 2:
					copy(cursor->stime, ptr);
					cursor->stime[strlen(cursor->stime) - 1] = '\0';
					break;
			}

			ptr = strtok(NULL, ",");
		}

		cursor->next = NULL;
		index->size += 1;
	}

	pclose(file);

	procList = root;
}

bool run(int* depth, Index* userIndex, Index* procIndex, User* userList) {
	int key = 0;

	int index = 0;

	User* userCursor = NULL;
	Proc* procCursor = NULL;

	if (*depth == DEPTH_USER) {
		struct passwd* pwd;

		userCursor = userList;

		for (index = userIndex->begin ; (userCursor != NULL) && (index > 0) ; --index) {
			userCursor = userCursor->next;
		}

		for (index = 0 ; (userCursor != NULL) && (index < 20) ; ) {
			if ((userIndex->current - userIndex->begin) == index) {
				printUser(index, COLOR_RED, userCursor->name);
				loadProcs(userCursor, procIndex);
			} else {
				printUser(index, COLOR_TRANS, userCursor->name);
			}

			index += 1;
			userCursor = userCursor->next;
		}

		for ( ; index < 20 ; ++index) {
			printUser(index, COLOR_TRANS, "");
		}
	}

	procCursor = procList;

	for (index = procIndex->begin ; (procCursor != NULL) && (index > 0) ; --index) {
		procCursor = procCursor->next;
	}

	for (index = 0 ; (procCursor != NULL) && (index < 20) ; ) {
		if ((procIndex->current - procIndex->begin) == index) {
			printProc(index, COLOR_GREEN, procCursor->cmd, procCursor->pid, procCursor->stime);
		} else {
			printProc(index, COLOR_TRANS, procCursor->cmd, procCursor->pid, procCursor->stime);
		}

		index += 1;
		procCursor = procCursor->next;
	}

	for ( ; index < 20 ; ++index) {
		printProc(index, COLOR_TRANS, "", "", "");
	}

	move(HEADER_HEIGHT + MAX_COLUMN + 2 + 1 + 1, 0);
 
	switch (key = getchar()) {
		case 'q':
		case 'Q':
			return false;

		case 27:
			getchar();

			switch (key = getchar()) {
				case UP:
				case DOWN:
				case LEFT:
				case RIGHT:
					if (*depth == DEPTH_USER) {
						switch (key) {
							case UP:
								if (userIndex->current - 1 >= 0) {
									userIndex->current -= 1;

									if (userIndex->current < userIndex->begin) {
										userIndex->begin -= 1;
										userIndex->end -= 1;
									}
								}
								break;

							case DOWN:
								if (userIndex->current + 1 < userIndex->size) {
									userIndex->current += 1;

									if (userIndex->current > userIndex->end) {
										userIndex->begin += 1;
										userIndex->end += 1;
									}
								}
								break;

							case RIGHT:
								if (*depth == DEPTH_USER) {
									*depth = DEPTH_PROC;
								}
								break;
						}
					} else {
						switch (key) {
							case UP:
								if (procIndex->current - 1 >= 0) {
									procIndex->current -= 1;

									if (procIndex->current < procIndex->begin) {
										procIndex->begin -= 1;
										procIndex->end -= 1;
									}
								}
								break;

							case DOWN:
								if (procIndex->current + 1 < procIndex->size) {
									procIndex->current += 1;

									if (procIndex->current > procIndex->end) {
										procIndex->begin += 1;
										procIndex->end += 1;
									}
								}
								break;

							case LEFT:
								if (*depth == DEPTH_PROC) {
									*depth = DEPTH_USER;
								}
								break;
						}
					}
					break;

				defualt:
					break;
			}
			break;
	}

	move(HEADER_HEIGHT + MAX_COLUMN + 2 + 1 + 1, 0);
	printf("    ");

	return true;
}

int main(void) {
	User* userList = NULL;

	Index userIndex;
	Index procIndex;

	int depth = DEPTH_USER;

	struct termios oldTermios;
	struct termios newTermios;

	tcgetattr(STDIN_FILENO, &oldTermios);

	newTermios = oldTermios;

	newTermios.c_lflag &= ~(ICANON);

	tcsetattr(STDIN_FILENO, TCSANOW, &newTermios);

	clear();
	drawFrame();

	userIndex.begin = 0;
	userIndex.current = 0;
	userIndex.end = 19;

	userList = loadUsers(&userIndex);

	loadProcs(userList, &procIndex);

	while (run(&depth, &userIndex, &procIndex, userList));

	tcsetattr(STDIN_FILENO, TCSANOW, &oldTermios);

	releaseProcs();

	return 0;
}
