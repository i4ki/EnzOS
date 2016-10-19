
// note this example will always write to the top
// line of the screen
void write_string( int colour, const char *string )
{
    volatile char *video = (volatile char*)0xB8000;
    while( *string != 0 )
    {
        *video++ = *string++;
        *video++ = colour;
    }
}

void main() {
  char *str = "Hello, world", *ch;
	unsigned short *vidmem = (unsigned short*) 0xb8000;
	unsigned i;

	for (ch = str, i = 0; *ch; ch++, i++)
		vidmem[i] = (unsigned char) *ch | 0x0700;
  //*((int*)0xb8000)=0x07690748;
}
