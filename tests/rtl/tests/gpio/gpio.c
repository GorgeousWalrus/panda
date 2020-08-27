int gpio(){

    volatile unsigned int *gpio_dir = (unsigned int*) 0x30000000;
    volatile unsigned int *gpio_val = (unsigned int*) 0x30000004;
    volatile unsigned int *gpio_inv = (unsigned int*) 0x30000008;
    volatile unsigned int *gpio_inten = (unsigned int*) 0x3000000c;
    volatile unsigned int *gpio_int_t = (unsigned int*) 0x30000010;


    *gpio_dir = 0x0;
    *gpio_inv = 0x00;

    if(*gpio_val != 0)
        return 1;

    *gpio_dir = 0x0f;
    *gpio_val = 0x0f;

    if(*gpio_val != 0xff)
        return 2;

    *gpio_dir = 0xf0;
    *gpio_val = 0x00;

    if(*gpio_val != 0x00)
        return 3;

    *gpio_val = 0xf0;

    if(*gpio_val != 0xff)
        return 4;

    return 0;
}