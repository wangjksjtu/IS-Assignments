#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUFFER_SIZE 1024 

void copy(char *infile, char *outfile) {
    char buffer[BUFFER_SIZE];
    
    FILE *in = fopen(infile, "r");
    FILE *out = fopen(outfile, "w");

    if (in == NULL || out == NULL) {
        if (in == NULL) {
            printf("[Error]: Can not open file %s\n", infile);
        }  
        else {
            printf("[Error]: Can not create file %s\n", outfile);  
        }
        exit(1);  
    }  
    // printf("%s", buffer);
    int length = 0;
    while((length = fread(buffer, sizeof(char), BUFFER_SIZE, in)) > 0) {
        fwrite(buffer, sizeof(char), length, out);
    }

    fclose(in);
    fclose(out);
}

void sig_w() {
    printf("[Father]: Writing finished\n");
    system("date -u");
}

int main() {
    int pid, ret, status = 1;
    void sig_w();
    char infile [] = "test.in";
    char outfile [] = "test.out";
    signal(SIGUSR1, sig_w);

    while ((pid=fork())==-1);
    if (pid) {
        printf("[Father]: This is the parent process.(ID: %d).\n", getpid());
        printf("[Father]: Cope '%s' to '%s'.\n", infile, outfile);
        copy(infile, outfile);
        sleep(3);
        printf("[Father]: Send the signal.\n");
        kill(pid, SIGUSR1);
        // pid = wait(&status);
        // printf("[Father]: Child process %d, status=%d \n", pid, status);
        
        sleep(1);
        if ((waitpid(pid, NULL, WNOHANG)) == 0) {  
            if ((ret = kill(pid, SIGKILL)) == 0) {  
                 printf("[Father] Kill child process %d\n", pid) ;  
            }  
        }
        
        pid = wait(&status);
        printf("[Father]: Child process %d, status=%d \n", pid, status);
    } else {
        printf("[Child]: This is the child process (ID: %d).\n", getpid());
        pause();
        printf("[Child]: Signal is received.\n");
        char buffer[BUFFER_SIZE];
        FILE *fp = fopen(outfile, "r");
        if (fread(buffer, sizeof(char), 10, fp) > 0) 
            printf("[Child]: Read from file `%s`: %s\n", outfile, buffer);
        execl("/bin/ls", "ls", "-al", "test.out", (char*)0);
        printf("execl error.\n");
        printf("[Child]: Start sleeping.\n");
        sleep(5);
        exit(1);
    }
    printf("[Father]: Parent process will terminate.\n");
}