#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <string.h>
#include <stdlib.h>
#define  MAX_MEM 4096

int main()
{

    int shmid;
    int ret;
    void* mem;

    shmid = shmget(0x12367, MAX_MEM, IPC_CREAT | 0666 );
    printf("shmid is = %d, pid=%d\n", shmid, getpid());
    mem = shmat(shmid, (const void*)0, 0);
    if(mem==(void *) -1) {
        perror("shmat");
    }

    strcpy((char*)mem,"Hello,this is test memory.\n");

    ret=shmdt(mem);

    return 0;

}