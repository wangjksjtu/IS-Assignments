#include <sys/types.h>  
#include <sys/stat.h>  
#include <errno.h>  
#include <fcntl.h>  
#include <stdio.h>  
#include <stdlib.h>  
#include <string.h>  
#include <unistd.h>  

#define FIFO   "myfifo"    /* 有名管道文件名*/  
#define BUFFER_SIZE   1024     
  
int main()  
{  
    char buffer[BUFFER_SIZE];  
    int  fd;  
    int  nread;
    char *outfile = "test.out";

    FILE *out = fopen(outfile, "w");

    /* 判断有名管道是否已存在，若尚未创建，则以相应的权限创建*/  
    if (access(FIFO, F_OK) == -1) {        
        if ((mkfifo(FIFO, 0666) < 0) && (errno != EEXIST)) {     
            printf("[Error]: Cannot create fifo file\n");
            exit(1);  
        }  
    }  
    
    /* 以只读阻塞方式打开有名管道 */  
    fd = open(FIFO, O_RDONLY);  
    if (fd == -1) {          
    printf("[Error]: Cannot open fifo file\n");  
    exit(1);      
    }

    while (1) {
        bzero(buffer, sizeof(buffer));
        while ((nread = read(fd, buffer, BUFFER_SIZE)) > 0) {
            // printf("[Info]: Read '%s' from FIFO\n", buffer);
            printf("[Info]: Reading from FIFO %d\n", nread);
            fwrite(buffer, sizeof(char), nread, out);
        }
        printf("[Info]: Writing to file '%s'\n", outfile);
        break;
    }

    close(fd);      
    exit(0);  
}    