#include "EnzOS/types.h"
#include "EnzOS/term.h"
#include "EnzOS/stdarg.h"

extern Term *term;

// Simple printf
// Only supports %s modifier until now.
uint16 printf(char *fmt, ...) {
        return _doprintf(fmt, (char *)&fmt + sizeof(char *));
}

uint16 _doprintf(char *fmt, va_list vl) {
        uint16 i = 0;
        char c;

        while ((c = (unsigned char) fmt[i++]) != '\0') {
                if (c == '%') {
                        if ((c = (unsigned char)fmt[i++]) != '\0') {
                                if (c == 's') {
                                        char *val = (char *)*(char *)vl;
                                        vl += sizeof(char *);

                                        termputstr(term, val);
                                } else {
                                        termputstr(term, "Modifier not supported: %");
                                        termputchar(term, c);
                                }
                        }
                } else {
                        termputchar(term, c);
                }
        }

        return i;
}
