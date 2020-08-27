#include "timer.h"

int main() {
    unsigned int *magic_addr = (unsigned int*) 0x10007ff0;
    
    int result = timer();

    *(magic_addr) = result + 1;

    while(1);
}