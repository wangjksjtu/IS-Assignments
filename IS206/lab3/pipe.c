#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 1024

int main() {
    int pipe_fd[2]; /*用于保存两个文件描述符*/
    pid_t pid;
    char buffer[BUFFER_SIZE]; /*用于读数据的缓存*/
    int r_num; /*用于保存读入数据大数量*/
    char infile[] = "test.in";
    char outfile[] = "test.out";
    FILE *in = fopen(infile, "r");
    FILE *out = fopen(outfile, "w");
    int length;

    if (pipe(pipe_fd)<0)    /*创建管道,成功返回0，否则返回-1*/
        return -1;

    if ((pid=fork())==0) {
        close(pipe_fd[1]);    /*关闭子进程写描述符*/
        while((length = read(pipe_fd[0], buffer, BUFFER_SIZE)) > 0) { /*子进程读取管道内容*/
            fwrite(buffer, sizeof(char), length, out);
        }
        close(pipe_fd[0]); /*关闭子进程读描述符*/
        exit(0);
    }
    else if (pid>0) {
        close(pipe_fd[0]); /*关闭父进程读描述符,并分多次向管道中写入文件读出的数据*/
        while((length = fread(buffer, sizeof(char), BUFFER_SIZE, in)) > 0) {
            write(pipe_fd[1], buffer, length);
        }
        close(pipe_fd[1]); /*关闭父进程写描述符*/
        exit(0);
    }
    return 0;
}