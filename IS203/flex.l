%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

// This function is to convert string to lower format
void lower(char* yytext) {
    int i = 0;
    while (yytext[i]) {
        // call c function putchar and tolower
        putchar(tolower(yytext[i]));
        ++i;
    }
}

// strctl function is build-in function to convert format
// digit_8_type0  is regex for 0123 (base is 8)
// digit_8_type1  is regex for oO123 (base is 8)
// digit_2        is regex for oB101 (base is 2)
// digit_16       is regex for 0XFa1 (base is 16)
// sline_comment  is regex for single-line comment
// mline_comment  is regex for multi-line comment
// digit_10       is regex for normal decimal number
// identifier     is regex for identifier in python
// string         is regex for string literal in python

%}

digit_8_type0   0[0-9]+ 
digit_8_type1   0[oO][0-7]+
digit_2         0[bB][0-1]+
digit_16        0[xX][0-9a-fA-F]+
digit_10        [1-9][0-9]*
mline_comment   (["]{3}(["]{0,2}[^"])*["]{3})|([']{3}([']{0,2}[^'])*[']{3})
sline_comment   #.*\n
identifier      [_a-zA-Z][0-9_a-zA-Z]*
string          (".*")|('.*')

%%

{digit_16}          { printf("%d", (int)strtol(yytext, NULL, 16)); }
{digit_8_type0}     { printf("%d", (int)strtol(yytext, NULL, 8)); }
{digit_8_type1}     { printf("%d", (int)strtol(yytext + 2, NULL, 8)); }
{digit_2}           { printf("%d", (int)strtol(yytext + 2, NULL, 2)); }
{mline_comment}     { lower(yytext); }
{sline_comment}     { lower(yytext); }
{identifier}        { printf("%s", yytext); }
{string}            { printf("%s", yytext); }
{digit_10}          { printf("%s", yytext); }

%%

// This is the entrace of the c program
void main(void)
{
    yylex();
}

