//router interface
interface router_if(input bit clock);
	bit [7:0] data_in;
	bit [7:0] data_out;
	bit rst;
	bit error;
	bit busy;
	bit read_enb;
	bit vld_out;
	bit pkt_valid;
//	bit parity;

	clocking wdr_cb @(posedge clock);
		default input #1 output #1;
		output data_in,pkt_valid,rst;
		input  error,busy;
	endclocking
	
	clocking rdr_cb @(posedge clock);
		default input #1 output #1;
		output read_enb;
		input  vld_out;
	endclocking
	
	modport WDR_MP (clocking wdr_cb);
	modport RDR_MP (clocking rdr_cb);

	clocking wmon_cb @(posedge clock);
		default input #1 output #1;
		input data_in;
		input pkt_valid;
		input error;
		input busy;
		input rst;
	endclocking
	
	clocking rmon_cb @(posedge clock);
		default input #1 output #1;
		input data_out;
		input read_enb;
	endclocking
	
	modport WMON_MP(clocking wmon_cb);
	modport RMON_MP(clocking rmon_cb);

endinterface 
