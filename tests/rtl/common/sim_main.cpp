#include <verilated.h>
#include "Vtestbench.h"
#include "testbench.h"


int main(int argc, char** argv, char** env) {
    int result = 0;
    TESTBENCH<Vtestbench> *tb;
    Verilated::commandArgs(argc, argv);

    tb = new TESTBENCH<Vtestbench>();
    tb->opentrace("logs/trace.vcd");
    result = tb->load_program((char*) "main.hex", 0x14);
    if(result != 0){
        std::cout << result << std::endl;
        exit(0);
    }

    for(int i = 0; i < 50; i++){
        for(int j = 0; j < 10000; j++)
            tb->tick();
        result = tb->read_mem(0x10007ff0);
        if(result != 0)
            break;
    }

    // The test result+1 is written into the magic address
    // in order to prevent reading a success if the memory was 
    // uninitialized (e.g. remains 0)

    result -= 1;

    // Cleanup
    tb->tick();
    tb->m_core->final();

    // Evaluate test
    if(result == 0)
        std::cout << "PASSED" << std::endl;
    else
        std::cout << "FAILED " << result << std::endl;
    
    //  Coverage analysis (since test passed)
    VerilatedCov::write("logs/coverage.dat");

    // Destroy model
    delete tb->m_core; tb->m_core = NULL;

    exit(0);
}
