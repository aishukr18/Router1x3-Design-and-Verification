class router_dst_monitor extends uvm_monitor;

	`uvm_component_utils(router_dst_monitor)
	dst_xtn data_rcvd;
	router_dst_agent_config m_cfg;
	virtual router_if.RMON_MP vif;
	uvm_analysis_port #(dst_xtn) monitor_port;

	extern function new(string name = "router_dst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();

endclass

function router_dst_monitor::new (string name = "router_dst_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);		

endfunction 

function void router_dst_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",m_cfg))
  		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db in dst monitor. Have you set() it?")
endfunction

function void router_dst_monitor::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

task router_dst_monitor::run_phase(uvm_phase phase);
	data_rcvd = dst_xtn::type_id::create("data_rcvd");
	forever
		begin
			collect_data();
		end
endtask
task router_dst_monitor::collect_data();
	while(vif.rmon_cb.read_enb!==1)
		@(vif.rmon_cb);
	@(vif.rmon_cb);

	data_rcvd.header=vif.rmon_cb.data_out;
	data_rcvd.payload=new[data_rcvd.header[7:2]];
	@(vif.rmon_cb);	
	foreach(data_rcvd.payload[i])
		begin
		     data_rcvd.payload[i]=vif.rmon_cb.data_out;
		     @(vif.rmon_cb);
		end
	data_rcvd.parity=vif.rmon_cb.data_out;
	`uvm_info("ROUTER_DST_MONITOR",$sformatf("printing from  DST monitor \n %s", data_rcvd.sprint()),UVM_LOW) 
//	data_rcvd.print;
		     @(vif.rmon_cb);
		     @(vif.rmon_cb);
	monitor_port.write(data_rcvd);
		
endtask









