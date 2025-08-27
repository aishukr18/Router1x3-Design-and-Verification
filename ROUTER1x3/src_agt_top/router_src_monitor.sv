class router_src_monitor extends uvm_monitor;
	`uvm_component_utils(router_src_monitor)
	router_src_agent_config m_cfg;
	virtual router_if.WMON_MP vif;
	uvm_analysis_port#(src_xtn) monitor_port;
	src_xtn data_sent;
	
	extern function new(string name = "router_src_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();

	
endclass

function router_src_monitor::new(string name = "router_src_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port = new("monitor_port",this);
endfunction

function void router_src_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
	`uvm_fatal("CONFIG CLASS IN SRC MONITOR","cannot get() m_cfg from uvm_config_db. Have you set() it?")

endfunction

function void router_src_monitor::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
endfunction

task router_src_monitor::run_phase(uvm_phase phase);
	forever
		collect_data();
endtask

task router_src_monitor::collect_data();

	data_sent = src_xtn::type_id::create("data_sent");


//	data_sent.busy  = vif.wmon_cb.busy;
	@(vif.wmon_cb);

	while(vif.wmon_cb.pkt_valid !== 1)
		@(vif.wmon_cb);
	while(vif.wmon_cb.busy !== 0)
		@(vif.wmon_cb);
	data_sent.header = vif.wmon_cb.data_in;
	data_sent.payload = new[data_sent.header[7:2]];
		@(vif.wmon_cb);
	foreach(data_sent.payload[i])
		begin
			while(vif.wmon_cb.busy !== 0)
				@(vif.wmon_cb);
			data_sent.payload[i] = vif.wmon_cb.data_in;
			@(vif.wmon_cb);

		end
	data_sent.parity  = vif.wmon_cb.data_in;
	repeat(2)
		@(vif.wmon_cb);	
	data_sent.error  = vif.wmon_cb.error;

	`uvm_info("ROUTER_SRC_MONITOR",$sformatf("printing from monitor \n %s", data_sent.sprint()),UVM_LOW) 

	monitor_port.write(data_sent); 


//	data_sent.print();

endtask


