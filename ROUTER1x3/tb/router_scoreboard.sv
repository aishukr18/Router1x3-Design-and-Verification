class router_scoreboard extends uvm_scoreboard;
	
	`uvm_component_utils(router_scoreboard)

	uvm_tlm_analysis_fifo#(src_xtn) src_fifo[];
	uvm_tlm_analysis_fifo#(dst_xtn) dst_fifo[];
	
	router_env_config env_cfg;
	src_xtn sxtn;
	dst_xtn dxtn;
	bit [1:0]addr;

	covergroup src_cg;
		
		ADDR:coverpoint sxtn.header[1:0]
				{bins addr0 = {0};
				 bins addr1 = {1}; 
				 bins addr2 = {2}; }
	
		PAYLOAD:coverpoint sxtn.header[7:2]
				{bins small_pkt = {[0:15]};
				 bins medium_pkt = {[16:30]};
				 bins large_pkt = {[31:63]}; }

		ERROR:coverpoint sxtn.error{bins error0 = {0};
					    bins error1 = {1}; }
	endgroup

	extern function new(string name,uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task compare(src_xtn sxtn,dst_xtn dxtn);
endclass

function router_scoreboard::new(string name,uvm_component parent);
	super.new(name,parent);
	src_cg = new();
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
		`uvm_fatal("env_config class in scoreboard","could not get it have you set it?")
	if(!uvm_config_db #(bit[1:0])::get(this,"","addr",addr))
		`uvm_fatal("addr config in scoreboard","could not get it have you set it?")
	
	src_fifo = new[env_cfg.no_of_src_agent];
	dst_fifo = new[env_cfg.no_of_dst_agent];

	foreach(src_fifo[i])
		src_fifo[i] = new($sformatf("src_fifo[%0d]",i),this);

	foreach(dst_fifo[i])
		dst_fifo[i] = new($sformatf("dst_fifo[%0d]",i),this);

	sxtn = src_xtn::type_id::create("sxtn");
	dxtn = dst_xtn::type_id::create("dxtn");
	
endfunction

task router_scoreboard::run_phase(uvm_phase phase);
/*	forever
		begin
			fork
				begin:A
					src_fifo[0].get(sxtn);
					`uvm_info("scoreboard","sxtn data",UVM_LOW)
					sxtn.print();
				end
				begin:B
					fork
						begin
							dst_fifo[0].get(dxtn);
							`uvm_info("scoreboard","dxtn data",UVM_LOW)
							dxtn.print();
							compare(sxtn,dxtn);
						end
						begin
							dst_fifo[1].get(dxtn);
							`uvm_info("scoreboard","dxtn data",UVM_LOW)
							dxtn.print();
							compare(sxtn,dxtn);
						end
						begin
							dst_fifo[2].get(dxtn);
							`uvm_info("scoreboard","dxtn data",UVM_LOW)
							dxtn.print();
							compare(sxtn,dxtn);
						end
					join_any
					disable fork;
				end
			join
		end  */

	fork
		forever
		    begin:A
			foreach(src_fifo[i])					
				src_fifo[i].get(sxtn);
				`uvm_info("SRC SB","src_data" , UVM_LOW)					
				sxtn.print;
		    end
		forever		
		    begin				
			dst_fifo[addr].get(dxtn);
             		`uvm_info("DST SB","dst_data" , UVM_LOW)	
			dxtn.print;
			compare(sxtn,dxtn);											
		    end
	join


endtask

task router_scoreboard::compare(src_xtn sxtn,dst_xtn dxtn);
	if(sxtn.header==dxtn.header)
             `uvm_info("SB","header comparison is sucessfull",UVM_LOW)		
	else
             `uvm_error("SB","header comparison is unsucessfull")		

	if(sxtn.payload==dxtn.payload)
             `uvm_info("SB","payload comparison is sucessfull",UVM_LOW)		
	else
             `uvm_error("SB","payload comparison is unsucessfull")		

	src_cg.sample();
endtask		

	
