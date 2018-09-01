#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>  
#include <fcntl.h>  
#include <sys/types.h>  
#include <sys/stat.h>  

#define BUFFER_SIZE 1024


void copy1(char *infile, char *outfile) {  
    int in, out, length;   
    char buffer[BUFFER_SIZE];  
      
    in = open(infile, O_RDONLY,S_IRUSR);
    out = open(outfile, O_WRONLY|O_CREAT);  
 
    if (in == -1 || out == -1) {      
        if (in == -1) {
            printf("[Error]: Can not open file %s\n", infile);
        }
        else {
            printf("[Error]: Can not create file %s\n", outfile);  
        }
        exit(1);
    }

    while ((length = read(in, buffer, 1024)) > 0) {
        write(out, buffer, length);
    }

    close(in);  
    close(out);  
}


void copy2(char *infile, char *outfile) {
    char buffer[BUFFER_SIZE];
    
    FILE *in = fopen(infile, "r");
    FILE *out = fopen(outfile, "w");

    if (in == NULL || out == NULL) {
        if (in == NULL) {
            printf("[Error]: Can not open file %s\n", infile);
        }  
        else {
            printf("[Error]: Can not create file %s\n", outfile);  
        }
        exit(1);  
    }  
    // printf("%s", buffer);
    int length = 0;
    while((length = fread(buffer, sizeof(char), BUFFER_SIZE, in)) > 0) {
        fwrite(buffer, sizeof(char), length, out);
    }

    fclose(in);
    fclose(out);
}


void copy3(char *infile, char *outfile) {  
    FILE *in = fopen(infile, "r");
    FILE *out = fopen(outfile, "w");

    char val;
    while (fscanf(in, "%c", &val) != EOF) {
        // printf("%c", val);
        fprintf(out, "%c", val);
    }  

    fclose(in);
    fclose(out);
}


void copy4(char *infile, char *outfile) {  
    FILE *in = fopen(infile, "r");
    FILE *out = fopen(outfile, "w");

    int c;
    while ((c = fgetc(in)) != EOF) {
        // printf("%c", val);
        fputc(c, out);
    }  

    fclose(in);
    fclose(out);
}


void copy5(char *infile, char *outfile) {  
    FILE *in = fopen(infile, "r");
    FILE *out = fopen(outfile, "w");

    char buffer[BUFFER_SIZE];

    while (fgets(buffer, BUFFER_SIZE, in)!=NULL) {
        // printf("%c", val);
        fputs(buffer, out);
    }  

    fclose(in);
    fclose(out);
}


int main() {
    copy5("test.in", "test.out");
    return 0;
}
