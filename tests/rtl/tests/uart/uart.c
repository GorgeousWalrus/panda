#include "uart.h"

int uart(){
    volatile int *uart_tx       = (int *) 0x20002000;
    volatile int *uart_rx       = (int *) 0x20002004;
    volatile int *uart_clk_div  = (int *) 0x20002008;
    volatile int *uart_ctrl     = (int *) 0x2000200c;

    *uart_clk_div = 0x2;
    *uart_tx = 0xdeadbeef;
    
    unsigned int rx;

    while((*uart_ctrl) & (1 << 1) != 0);

    if((*uart_ctrl) & (1 << 2) != 1)
        return 1;
    
    rx = *uart_rx;
    if(rx != 0xdeadbeef)
        return rx+1;
    return 0;
}