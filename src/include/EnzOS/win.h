#ifndef WIN_H
#define WIN_H

typedef struct {
        uint8 row;
        uint8 column;
        uint8 color;
        uint8 borderColor;

        char top[80];
        char footer[80];
} Win;

void winInit(Win *w);
void winRender(Win *w);

#endif
