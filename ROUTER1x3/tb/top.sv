module top;

  import router_test_pkg::*;
	import uvm_pkg::*;
	bit clock;  
	always 
		#10 clock=!clock;  

   // Instantiate router_if with clock as input
	router_if src_if0(clock);
	router_if dst_if0(clock);
   	router_if dst_if1(clock);
	router_if dst_if2(clock); 
	
	router duv(.clk(clock),.rst(src_if0.rst),.data_in(src_if0.data_in),.pkt_valid(src_if0.pkt_valid),.err(src_if0.error),.busy(src_if0.busy),
		   .read_enb_0(dst_if0.read_enb),.vld_out_0(dst_if0.vld_out),.data_out_0(dst_if0.data_out),
		   .read_enb_1(dst_if1.read_enb),.vld_out_1(dst_if1.vld_out),.data_out_1(dst_if1.data_out),
		   .read_enb_2(dst_if2.read_enb),.vld_out_2(dst_if2.vld_out),.data_out_2(dst_if2.data_out));

   // In initial block
    initial 
	begin
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif

		//set the virtual interface using the uvm_config_db
		uvm_config_db #(virtual router_if)::set(null,"*","src_if0",src_if0);
		uvm_config_db #(virtual router_if)::set(null,"*","dst_if0",dst_if0);
		uvm_config_db #(virtual router_if)::set(null,"*","dst_if1",dst_if1);
		uvm_config_db #(virtual router_if)::set(null,"*","dst_if2",dst_if2);  

		run_test();
	end

endmodule

