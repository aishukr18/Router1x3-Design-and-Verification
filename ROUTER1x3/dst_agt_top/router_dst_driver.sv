class router_dst_driver extends uvm_driver #(dst_xtn);

	`uvm_component_utils(router_dst_driver)

	router_dst_agent_config m_cfg;
	virtual router_if.RDR_MP vif;
		

	extern function new(string name ="router_dst_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(dst_xtn xtn);

endclass

function router_dst_driver::new (string name ="router_dst_driver", uvm_component parent);
	super.new(name,parent);
endfunction : new

function void router_dst_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
//	uvm_config_db #(router_dst_agent_config)::set(this,$sformatf("dst_agnth[%0d]",i),"router_dst_agent_config",env_cfg.dst_cfg[i]);

	if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",m_cfg))
		`uvm_fatal("config","cannot get() m_cfg from uvm_config_db in dst driver. Have you set() it?")

endfunction

function void router_dst_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif = m_cfg.vif;
endfunction

task router_dst_driver::run_phase(uvm_phase phase);
	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end

endtask

task router_dst_driver::send_to_dut(dst_xtn xtn);
	vif.rdr_cb.read_enb<=1'b0;
	while(vif.rdr_cb.vld_out !==1)
		@(vif.rdr_cb); 
	//@(vif.rdr_cb);

	repeat(xtn.no_of_cycles)
		@(vif.rdr_cb);

	vif.rdr_cb.read_enb<=1'b1;
	@(vif.rdr_cb);
	while(vif.rdr_cb.vld_out !==0)
		@(vif.rdr_cb); 
	@(vif.rdr_cb);
	vif.rdr_cb.read_enb<=1'b0;

	`uvm_info("ROUTER_DST_DRIVER",$sformatf("printing from dst driver \n %s", xtn.sprint()),UVM_LOW) 

endtask

	
	





