#include "msgcom.h"

int main() {
    struct msg_s buf;
    int qid, pid;
    char buffer [BUFFER_SIZE]; 
    char infile[] = "test.in";
    int nread;

    FILE *in = fopen(infile, "r");

    while ((nread = fread(buffer, sizeof(char), BUFFER_SIZE, in)) > 0) {
        // printf("%s", buffer);
        qid = msgget(MSGKEY, IPC_CREAT|0666);
        buf.msgtype = 1;
        buf.pid = pid = getpid();
        strcpy(buf.text, buffer);
        buf.length = nread;
        // printf("%d\n", buf.length);
        msgsnd(qid, &buf, sizeof(buf.text), 0);
        msgrcv(qid, &buf, 512, pid, MSG_NOERROR);
        printf ("Request received a message from server. MSG_type is: %ld\n", buf.msgtype);
        // break;
    }
    return 0;
}