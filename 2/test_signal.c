#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
static void alarmHandler(int signo);

int main(void){
    
    alarm(10);

    signal(SIGALRM, alarmHandler);
       for(int i = 1; i <= 10; i++){
        sleep(1);    
    }

    return 0;

}

static void alarmHandler(int signo){
    printf("Alarm signal sent!\n");

}