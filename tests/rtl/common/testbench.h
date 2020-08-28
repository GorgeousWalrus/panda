#include <verilated_vcd_c.h>

vluint64_t main_time = 0;       // Current simulation time
// This is a 64-bit integer to reduce wrap over issues and
// allow modulus.  This is in units of the timeprecision
// used in Verilog (or from --timescale-override)

double sc_time_stamp () {       // Called by $time in Verilog
	return main_time;           // converts to double, to match
								// what SystemC does
}

#define CLK_FREQ 50000000
#define BAUDRATE 50000000
#define CLK_DIV CLK_FREQ/BAUDRATE

template<class MODULE>	class TESTBENCH {
	public:
		unsigned long	m_tickcount;
		MODULE	*m_core;
		VerilatedVcdC	*m_trace;

		TESTBENCH(void) {
			m_core = new MODULE;
			Verilated::traceEverOn(true);
			this->m_core->dbg_uart_rx_i = 1;
			m_tickcount = 0l;
		}

		// Open/create a trace file
		virtual	void	opentrace(const char *vcdname) {
			if (!m_trace) {
				m_trace = new VerilatedVcdC;
				m_core->trace(m_trace, 99);
				m_trace->open(vcdname);
			}
		}

		// Close a trace file
		virtual void	close(void) {
			if (m_trace) {
				m_trace->close();
				m_trace = NULL;
			}
		}


		virtual ~TESTBENCH(void) {
			this->close();
			delete m_core;
			m_core = NULL;
		}

		virtual void	reset(void) {
			m_core->ext_rstn_i = 0;
			for(int i = 0; i < 4; i++)
				this->tick();
			m_core->ext_rstn_i = 1;
		}

		virtual void	tick(void) {
			// Increment our own internal time reference
			m_tickcount++;

			// Make sure any combinatorial logic depending upon
			// inputs that may have changed before we called tick()
			// has settled before the rising edge of the clock.
			m_core->ext_clk_i = 0;
			m_core->eval();

			if(m_trace) m_trace->dump(10*m_tickcount-2);

			// Toggle the clock
			// Rising edge
			m_core->ext_clk_i = 1;
			m_core->eval();
			if(m_trace) m_trace->dump(10*m_tickcount);

			// Falling edge
			m_core->ext_clk_i = 0;
			m_core->eval();

			if (m_trace) {
				// This portion, though, is a touch different.
				// After dumping our values as they exist on the
				// negative clock edge ...
				m_trace->dump(10*m_tickcount+5);
				//
				// We'll also need to make sure we flush any I/O to
				// the trace file, so that we can use the assert()
				// function between now and the next tick if we want to.
				m_trace->flush();
			}
		}

		virtual bool	done(void) { return (Verilated::gotFinish()); }

		// -----------------------------------------------------------
		// Debug interfacing functions
		// -----------------------------------------------------------

		void baud_tick(){
			for(int i = 0; i < CLK_DIV; i++) this->tick();
		}

		void uart_send(int data){
			this->tick();
			int parity = 0;
			for(int i = 0; i < 4; i++){
				this->m_core->dbg_uart_rx_i = 0;
				this->baud_tick();
				for(int j = 0; j < 8; j++){
					this->m_core->dbg_uart_rx_i = ((data >> (8*i)) >> j) & 1;
					parity = parity ^ (((data >> (8*i)) >> j) & 1);
					this->baud_tick();
				}
				this->m_core->dbg_uart_rx_i = parity;
				this->baud_tick();
				this->m_core->dbg_uart_rx_i = 1;
				this->baud_tick();
			}
		}

		int uart_receive(){
			this->tick();
			int data = 0;
			for(int i = 0; i < 4; i ++){
				while(this->m_core->dbg_uart_tx_o == 1) this->tick();
				this->baud_tick();
				for(int j = 0; j < 8; j++){
					data = data | ((this->m_core->dbg_uart_tx_o << j) << (8*i));
					this->baud_tick();
				}
				// ignore parity
				this->baud_tick();
			}
			return data;
		}

		int dbg_uart_send(int data){
			uart_send(data);
			int ret = uart_receive();
			if(ret != 0x1) return 1;
			return 0;
		}

		int dbg_uart_read(){
			int ret = uart_receive();
			uart_send(0x1);
			return ret;
		}

		// Read from memory address (can also be a memory mapped
		// slave of the wishbone bus)
		int read_mem(int addr){
			int data;
			dbg_uart_send(0x80);
			dbg_uart_send(addr);
			data = dbg_uart_read();
			if(dbg_uart_read() != 0x2)
				return -1;
			return data;
		}

		// Write to memory address (can also be a memory mapped
		// slave of the wishbone bus)
		int write_mem(int addr, int data){
			dbg_uart_send(0xc0);
			dbg_uart_send(addr);
			dbg_uart_send(data);
			if(dbg_uart_read() != 0x2)
				return -1;
			return 0;
		}

		// Read from core registers
		int read_reg(int reg){
			int data;
			dbg_uart_send(0x81);
			dbg_uart_send(reg);
			data = dbg_uart_read();
			if(dbg_uart_read() != 0x2)
				return -1;
			return data;
		}

		// Write to core registers	
		int write_reg(int reg, int data){
			dbg_uart_send(0xc1);
			dbg_uart_send(reg);
			dbg_uart_send(data);
			if(dbg_uart_read() != 0x2)
				return -1;
			return 0;
		}

		// Halt the core
		int halt_core(){
			dbg_uart_send(0x04);
			if(dbg_uart_read() != 0x2)
				return -1;
			return 0;
		}

		// Resume the core
		int resume_core(){
			dbg_uart_send(0x05);
			if(dbg_uart_read() != 0x2)
				return -1;
			return 0;
		}

		// Reset the core
		int reset_core(){
			dbg_uart_send(0x01);
			if(dbg_uart_read() != 0x2)
				return -1;
			return 0;
		}

		// Read the program counter
		int read_pc(){
			int data;
			dbg_uart_send(0x82);
			dbg_uart_send(0x0);
			data = dbg_uart_read();
			if(dbg_uart_read() != 0x2)
				return -1;
			return data;
		}

		// Set the program counter
		int set_pc(int pc){
			dbg_uart_send(0xc2);
			dbg_uart_send(0x0);
			dbg_uart_send(pc);
			if(dbg_uart_read() != 0x2)
				return -1;
			return 0;
		}


		void load_program(int program[4096], int len, int startAddr){
			this->halt_core();
			for(int i = 0; i < len; i++){
				this->write_mem(startAddr + 4*i, program[i]);
			}
		}

		void load_program(char* filename, int startAddr){
			int program[4096];
			int instr_cnt = 0;
			size_t len = 0;
			ssize_t read;
			char * line = NULL;
    		FILE *fp;

			// Read in the program
			fp = fopen(filename, "r");
			if(fp){
				while((read = getline(&line, &len, fp)) != -1){
					program[instr_cnt] = (int)strtol(line, NULL, 16);;
					instr_cnt +=1;
				}
			} else {
				std::cout << "Error reading dump" << std::endl;
				exit(-10);
			}

			// Rest the core
			this->reset();
			// Halt the core
			this->halt_core();
			this->reset_core();
			
			// Load the program into memory
			this->load_program(program, instr_cnt, startAddr);

			// Set core to start of program
			this->set_pc(startAddr);
			// Start the program
			this->resume_core();
		}

		// Check a bunch of memory addresses for the expected results
		int check_memory(int *exp_mem, int n_checks){
			for(int i = 0; i < n_checks; i++){
				if(this->read_mem(exp_mem[i*2]) != exp_mem[i*2+1])
					return i+1;
			}
			return 0;
		}
};