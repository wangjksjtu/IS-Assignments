#include <sys/types.h>  
#include <sys/stat.h>  
#include <errno.h>  
#include <fcntl.h>  
#include <stdio.h>  
#include <stdlib.h>  
#include <unistd.h>  

#define FIFO   "myfifo"    /* 有名管道文件名*/  
#define BUFFER_SIZE 1024       
/*常量PIPE_BUF 定义在于limits.h中*/  
  
int main(int argc, char * argv[]) /*参数为即将写入的字符串*/  
{  
    int fd;  
    char buffer[BUFFER_SIZE];  
    int length;
    char infile [] = "test.in";
    FILE *in = fopen(infile, "r");
   
    /* 以只写阻塞方式打开FIFO管道 */  
    fd = open(FIFO, O_WRONLY);  
    if (fd == -1) {  
        printf("[Info]: Open fifo file error\n");  
        exit(1);  
    }

    /*向管道中写入字符串*/
    
    while(1) {
        while ((length = fread(buffer, sizeof(char), BUFFER_SIZE, in)) > 0) {
            printf("[Info]: Reading from file '%s'\n", infile);
            write(fd, buffer, length);
            printf("[Info]: Writing to FIFO %d\n", length);
            // printf("Write '%s' to FIFO\n", buffer);
        }
        break;
    }
    close(fd);  
    exit(0);
    
}