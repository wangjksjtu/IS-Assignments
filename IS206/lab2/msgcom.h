#include <errno.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define MSGKEY 5678
#define BUFFER_SIZE 1024

struct msg_s {
    long msgtype;
    int pid;
    int length;
    char text[BUFFER_SIZE];
};