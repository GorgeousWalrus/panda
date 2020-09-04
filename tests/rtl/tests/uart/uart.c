#include "uart.h"

#define N_TRNS 60

int uart(){
    volatile int *uart_tx       = (int *) 0x20002000;
    volatile int *uart_rx       = (int *) 0x20002004;
    volatile int *uart_clk_div  = (int *) 0x20002008;
    volatile int *uart_ctrl     = (int *) 0x2000200c;
    volatile int *uart_status   = (int *) 0x20002010;

    *uart_clk_div = 0x16;
    *uart_ctrl |= (0x1 << 0); // enable tx
    *uart_ctrl |= (0x1 << 1); // enable rx
    

    for(int i = 1; i < N_TRNS; i++){
        while(((*uart_status) >> 1) & 0x1 == 1);
        *uart_tx = i;
    }
    
    for(int i = 1; i < N_TRNS; i++){
        while(((*uart_status) >> 2) & 0x1 == 1);
        if((*uart_rx) != i)
            return i+1;
    }

    *uart_ctrl &= ~(0x1 << 0); // disable tx
    *uart_ctrl &= ~(0x1 << 1); // disable rx

    return 0;
}