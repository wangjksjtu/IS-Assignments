#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define SHMKEY 1223
#define SIZE 1024
#define SEMKEY1 2378
#define SEMKEY2 2367

static void semcall(int sid, int op) {
    struct sembuf sb;
    sb.sem_num = 0;
    sb.sem_op = op;
    sb.sem_flg = 0;

    if (semop(sid, &sb, 1) == -1) {
        perror("semop");
    }
}

int createsem(key_t key) {
    int sid;
    union semun {   
        int val;
        struct semid_ds *buf;
        ushort *array;
    } arg;

    if ((sid = semget(key, 1, 0666|IPC_CREAT)) == -1) {
        perror("semget");
    }

    arg.val = 1;
    if (semctl(sid, 0, SETVAL, arg) == -1) {
        perror("semctl");
    }
    return sid;
}

void P(int sid) {
    semcall(sid, -1);
}

void V(int sid) {
    semcall(sid, 1);
}

int main() {
    char *segaddr;
    int segid, sid1, sid2;
    int pid;

    // int shmid;
    // int ret;
    // void* mem;

    segid = shmget(SHMKEY, SIZE, IPC_CREAT | 0666 );
    printf("shmid is = %d, pid=%d\n", segid, getpid());
    segaddr = shmat(segid, (const void*)0, 0);
    if(segaddr == (void *) -1) {
        perror("shmat");
    }

    sid1 = createsem(SEMKEY1); /* 创建两个信号灯，初值为1 */
    sid2 = createsem(SEMKEY2);
    printf("%d %d\n", sid1, sid2);
    
    /*
    if ((segid = shmget(0x12367, SIZE, IPC_CREAT | 0666) == 1)) {
        perror("shmget");
    } 
    segaddr = shmat(segid, NULL, 0);
    if (segaddr == (void*)-1) {
        perror("shmat");
        exit(2);
    }*/

    P(sid2);                /* 置信号灯2值为0，表示缓冲区空 */
    if(!(pid = fork())) {
        printf ("%d\n", pid);
        char* outfile = "test.out";

        FILE *out = fopen(outfile, "w");
        //while(1){
        P(sid2);
        // printf("Received from Parent: %s\n", segaddr);
        fwrite(segaddr, sizeof(char), SIZE, out);
        fclose(out);
        // fflush(stdout);
        V(sid1);
        //}
    }
    else {
        printf ("%d\n", pid);
        char* infile = "test.in";
        int length = 0;
        char buffer [SIZE];
        FILE *in = fopen(infile, "r");
        fflush(stdout);
        
        //while((length = fread(buffer, sizeof(char), SIZE, in)) > 0) {
        if ((length = fread(buffer, sizeof(char), SIZE, in)) > 0) {
            P(sid1);
            strcpy(segaddr, buffer);
            printf("%d\n", length);
            V(sid2);
        //    break;
        }
        
        /*
        while(1) {
            P(sid1);
            scanf("%s", segaddr);
            // printf("%s\n", segaddr);
            V(sid2);
        }
        */
    }
}
