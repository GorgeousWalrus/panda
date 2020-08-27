#define N_CYC 40

int performance(){
    volatile int *timer = (int *) 0x20000000;
    volatile int *t_cfg = (int *) 0x20000004;
    volatile int *cmp   = (int *) 0x20000008;

    volatile int t_old[8] = {0};
    int t_new = 0;

    *timer = 0;
    
    // set compare to highest to disable resetting it early
    *cmp = 0xffffffff;
    *t_cfg = 1;
    t_new = *timer;
    
    for(int i = 0; i < N_CYC; i++){
        t_old[0]++;
        t_old[1]++;
        t_old[2]++;
        t_old[3]++;
        t_old[4]++;
        t_old[5]++;
        t_old[6]++;
        t_old[7]++;
    }
    
    t_new = (*timer) - t_new;

    if(t_old[0] == N_CYC)
        return t_new;
    
    return -10;
}