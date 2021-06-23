// C program for passing value from
// child process to parent process
#include <pthread.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h> 
#include <stdlib.h> 
#include <sys/wait.h>
#define MAX 1000

char file_contents[MAX];
int counter = 0;

void print_file(char * filename)
{
    FILE *fp;
	char ch;
	fp = fopen(filename, "r"); // read mode
	if (fp == NULL)
    {
		perror("Error while opening the file.\n");
      	exit(EXIT_FAILURE);
    }
	printf("The contents of %s file are:\n", filename);
	while((ch = fgetc(fp)) != EOF)
	{
        //ch = fgetc(fp);
		//printf("%c", ch);
        file_contents[counter] = ch;
        counter = counter + 1; 
	}
    fclose(fp);
}
void parent_to_child() // Child send data and parent will receive data
{
    counter = 0;
    char filename[200];
    printf("Enter the name of the file: ");
	scanf("%s",filename);
    print_file(filename);
    
    int fd[2];
    pipe(fd);
    printf("They are strted\n");
    pid_t pid = fork();
     if(pid > 0) 
     {
         wait(NULL);
         // closing the standard input 
         close(0);
         // no need to use the write end of pipe here so close it
         close(fd[1]); 
          // duplicating fd[0] with standard input 0
         dup(fd[0]); 
         int arr[MAX];
         // n stores the total bytes read successfully
         printf("Parent start receiving data\n");
         for(int i=0; i<counter; i++)
         {
             read(fd[0], &arr[i], 1);
         }
         //int n = read(fd[0], arr, sizeof(arr));
         printf("PID\tMessage\n");
         for (int i = 0;i < counter; i++)
         {
             // printing the array received from child process
             printf("%d\t", pid);
             printf("%c\n", arr[i]); 
         }
         printf("Parent End Receiving data\n");
    } 
    else if( pid == 0 ) 
    {
        printf("Child start sending data\n");
        printf("Child end sending data\n");
        int arr[] = {1, 2, 3, 4, 5};
        // no need to use the read end of pipe here so close it
        close(fd[0]); 
         // closing the standard output
        close(1);    
        // duplicating fd[0] with standard output 1
        dup(fd[1]);
        //write(1, arr, sizeof(arr));
        for(int i=0; i< counter; i++)
        {
            write(fd[1], &file_contents[i],1);
        }
    } 
    else 
    {
        perror("error\n"); //fork()
    }
    printf("Process going to terminate\n");
}

void child_to_parent() //Parent sent and then child will receive
{
    counter = 0;
    char filename[200];
    printf("Enter the name of the file: ");
	scanf("%s",filename);
    print_file(filename);
    
    int fd[2];
    int stat;
    pipe(fd);
    printf("They are strted\n");
    int id = getpid();
    pid_t pid = fork();
    if(pid < 0) 
    {
        perror("error\n"); //fork()
    }
    else if( pid == 0 ) 
    {
        wait(NULL);
        printf("Child start receiving data\n");
        close(fd[1]);
        int arr[MAX];
        for(int i=0; i<counter; i++)
        {
            read(fd[0], &arr[i], 1);
        }
        //int n = read(fd[0], arr, sizeof(arr));
        printf("PID\tMessage\n");
        for (int i = 0;i < counter; i++)
        {
            // printing the array received from parent process
            printf("%d\t", pid);
            printf("%c\n", arr[i]); 
        }
        printf("Child end for receiving data\n");
        close(fd[0]);
    } 
    else 
    {
        printf("Parent start to send data\n");
        close(fd[0]);
        for(int i=0; i< counter; i++)
        {
            write(fd[1], &file_contents[i],1);
        }
        printf("Parent end to send data\n");
        close(fd[1]);
    } 
    
    
    printf("Process going to terminate\n");
}

void show_menu()
{
    int choice;
    char filename[200];
	do 
	{
		 printf("1. Parent to Child\n");
		 printf("2. Child to Parent\n");
		 printf("3. Exit\n");
		 printf("Enter Choice:\t");
		 scanf("%d",&choice);
		 switch (choice)
 		{
			case 1:
                parent_to_child();
          	    break;
     		case 2: 
                child_to_parent();
                break;
     		case 3: 
			    printf("Exit\n");
				exit(0); 
         	    break;
    		default: 
				printf("Wrong Choice. Enter again\n");
            	break;
 		}	 
	} 
	while (choice !=3);
	
}
int main()
{
    //parent_to_child();
    //child_to_parent();
    show_menu();
    return 0;
}