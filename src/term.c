#include "EnzOS/types.h"
#include "EnzOS/vesa.h"
#include "EnzOS/term.h"

void terminit(Term *term) {
        term->x = 0;
        term->y = 0;
        term->color = TERMCOLOR;
}

void termputchar(Term *term, char c) {
        if (c == '\r') {
                term->x = 0;
                return;
        }

        if (c == '\n') {
                uint8 erasecolumns = (VWIDTH-1) - term->x;

                for (uint8 i = 0; i < erasecolumns; i++) {
                        termputchar(term, ' ');
                }

                term->y++;
                term->x = 0;

                return;
        }

        putchar(term->x, term->y, c, term->color);
        term->x++;

        if (term->x == VWIDTH) {
                term->x = 0;
                term->y++;
        }

        if (term->y == VHEIGHT) {
                term->x = 0;
                term->y = 0;
        }
}

void termputstr(Term *term, char *str) {
        char c;
        while ((c = *str++) != '\0') {
                termputchar(term, c);
        }
}
