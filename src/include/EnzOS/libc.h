#ifndef LIBC_H
#define LIBC_H

uint16 strlen(char *str);
void memset(void *dest, uint8 c, uint16 size);
void bzero(void *dest, uint16 size);

#endif
