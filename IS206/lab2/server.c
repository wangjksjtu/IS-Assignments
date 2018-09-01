#include "msgcom.h"

int main() {
    struct msg_s buf;
    int qid;
    qid = msgget(MSGKEY, IPC_CREAT | 0666);
    char outfile[] = "test.out";
    FILE *out = fopen(outfile, "w"); 

    if (qid == -1) {
        return (-1);
    }

    while (1) {
        msgrcv(qid, &buf, sizeof(buf.text), 1, MSG_NOERROR);
        printf("Server receive a request from process %d (", buf.pid);
        buf.msgtype = buf.pid;
        fwrite(buf.text, sizeof(char), buf.length, out);
        msgsnd(qid, &buf, sizeof(buf.text), 0);
        printf("%d)\n", buf.length);
        if (buf.length < BUFFER_SIZE) break;
    }
    fclose(out);

    return 0;
}