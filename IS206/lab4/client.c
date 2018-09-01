#include <stdio.h>
#include <stdlib.h>
#include <string.h>    //strlen
#include <sys/socket.h>
#include <arpa/inet.h> //inet_addr

#define BUFFER_SIZE 4096  
#define IP_ADDR "127.0.0.1"
#define SERVER_PORT 8888

int main(int argc , char *argv[]) {
    int socket_desc;
    struct sockaddr_in server;
    char buffer[BUFFER_SIZE];
    char message[512], filename[512];
     
    // Create socket
    socket_desc = socket(AF_INET , SOCK_STREAM , 0);
    if (socket_desc == -1) {
        printf("Could not create socket");
    }
         
    server.sin_addr.s_addr = inet_addr(IP_ADDR);
    server.sin_family = AF_INET;
    server.sin_port = htons(SERVER_PORT);
 
    // Connect to remote server
    if (connect(socket_desc , (struct sockaddr *)&server , sizeof(server)) < 0) {
        puts("[Error]: Connection error!");
        return 1;
    }
     
    puts("[Info]: Connected to server");

    // Prinst the greeting info
    int length = 0;  
    if (length = recv(socket_desc, buffer, BUFFER_SIZE, 0)) {
        if (length < 0) {  
            printf("[Error]: Failed to receive file `%s` from server",  message);  
        }
        printf("[Info]: %s", buffer);
    }

    // Send some data
    printf("[Info]: Path of file to be read: ");
    while (scanf("%s", message)) {
        if (send(socket_desc, message, BUFFER_SIZE, 0) < 0) {
            puts("[Error]: Failed to send message");
            return 1;
        }
        puts("[Info]: Send message to server");
        
        //Receive a reply from the server
        bzero(buffer, sizeof(buffer));
        printf("[Info]: Path of file to be saved: ");
        scanf("%s", filename);
        
        FILE *file_pointer = fopen(filename, "w");
        if (file_pointer == NULL) {  
            printf("[Error]: Can not create file %s\n", filename);
            break;
            exit(1);  
        }
        int flag = 1;
        while (1) {
            length = recv(socket_desc, buffer, BUFFER_SIZE, 0);
            if (length < 0) {
                printf("[Error]: Failed to receive file `%s` from server\n",  message);
            } 
            else {
                // printf("%s", buffer);
                if (buffer[0] == '!' && buffer[1] == '=' && buffer[2] == '!') {
                    printf("[Error]: File `%s` not found in server\n", message);
                    flag = 0;
                    break;
                }
                else {
                    // printf("%s", buffer);
                    int write_length = fwrite(buffer, sizeof(char), length, file_pointer);
                    if (write_length < length) {  
                        printf("[Error]: Failed to write to %s\n", filename);  
                        break;
                    }
                    if (length < BUFFER_SIZE) break;
                }
            }
        }
        if (flag) printf("[Info]: Save to file %s finished!\n", filename);
        fclose(file_pointer);
        bzero(message, sizeof(message));
        printf("[Info]: Path of file to be read: ");
        fflush(stdout);
    }

    puts("[Info]: Connection disrupted!");
    puts("[Info]: Bye-Bye");
    return 0;
}