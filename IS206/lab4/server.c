#include <stdio.h>
#include <stdlib.h>
#include <string.h>    // strlen
#include <sys/socket.h>
#include <arpa/inet.h> // inet_addr
#include <unistd.h>    // write
 
#include <pthread.h> // for threading , link with lpthread

#define BUFFER_SIZE 4096  
#define PORT 8888 

void *connection_handler(void *);
 
int main(int argc , char *argv[])
{
    int socket_desc , new_socket , c , *new_sock;
    struct sockaddr_in server , client;
    char *message;
     
    // Create socket
    socket_desc = socket(AF_INET , SOCK_STREAM , 0);
    if (socket_desc == -1) {
        printf("[Error]: Could not create socket");
    }
     
    // Prepare the sockaddr_in structure
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = INADDR_ANY;
    server.sin_port = htons(PORT);
     
    // Bind
    if( bind(socket_desc,(struct sockaddr *)&server , sizeof(server)) < 0) {
        puts("[Error]: Bind failed");
        return 1;
    }
    puts("[Info]: Bind done");
     
    // Listen
    listen(socket_desc , 3);
     
    // Accept and incoming connection
    puts("[Info]: Waiting for incoming connections...");
    c = sizeof(struct sockaddr_in);
    while ((new_socket = accept(socket_desc, (struct sockaddr *)&client, (socklen_t*)&c))) {
        puts("[Info]: Connection accepted");
         
        // Reply to the client
        message = "Hello, nice to meet you!\n";
        write(new_socket , message , strlen(message));
         
        pthread_t sniffer_thread;
        new_sock = malloc(1);
        *new_sock = new_socket;
         
        if (pthread_create( &sniffer_thread, NULL, connection_handler, (void*) new_sock) < 0) {
            perror("[Error]: Could not create thread");
            return 1;
        }
         
        // Now join the thread , so that we dont terminate before the thread
        // pthread_join( sniffer_thread , NULL);
        puts("[Info]: Handler assigned");
    }
     
    if (new_socket<0)
    {
        perror("[Error]: Accept failed");
        return 1;
    }
     
    return 0;
}
 

/*
 * This will handle connection for each client
 * */
void *connection_handler(void *socket_desc)
{
    // Get the socket descriptor
    int sock = *(int*)socket_desc;
    int read_size;
    char client_message[BUFFER_SIZE];
    char buffer[BUFFER_SIZE];

    //Receive a message from client
    while ((read_size = recv(sock, client_message, BUFFER_SIZE, 0)) > 0) {
        // Send the message back to client
        fflush(stdout);
        FILE *file_pointer = fopen(client_message, "r");  
        if (file_pointer == NULL) {  
            printf("[Error]: File: %s not found!\n", client_message);
            bzero(buffer, BUFFER_SIZE);
            strcpy(buffer, "!=!");
            // printf("%s", buffer);
            // fflush(stdout);
            send(sock, buffer, sizeof(buffer), 0);
        }
        else  {  
            bzero(buffer, BUFFER_SIZE);
            int file_block_length = 0;  
            while((file_block_length = fread(buffer, sizeof(char), BUFFER_SIZE, file_pointer)) > 0) {  
                printf("[Info]: File block length = %d\n", file_block_length);  
                if (send(sock, buffer, file_block_length, 0) < 0) {  
                    printf("[Info]: Send file %s failed!\n", client_message);  
                    break;  
                }
                bzero(buffer, sizeof(buffer)); 
            }  
            printf("[Info]: File %s transferring finished!\n", client_message);  
            fclose(file_pointer);
        }
    }
     
    if (read_size == 0) {
        puts("[Info]: Client disconnected");
        fflush(stdout);
    }
    else if (read_size == -1) {
        perror("[Error]: Receive failed");
    }
         
    // Free the socket pointer
    free(socket_desc);
    return 0;
}