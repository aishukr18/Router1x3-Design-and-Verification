class router_src_agent extends uvm_agent;

	`uvm_component_utils(router_src_agent)
	
	router_src_agent_config m_cfg;

	router_src_monitor monh;
	router_src_sequencer seqrh;
	router_src_driver drvh;

	
	extern function new(string name = "router_src_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : router_src_agent

function router_src_agent::new(string name = "router_src_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_src_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	monh  = router_src_monitor::type_id::create("monh",this);
	if(m_cfg.is_active == UVM_ACTIVE)
		begin
			drvh =  router_src_driver::type_id::create("drvh",this);
			seqrh = router_src_sequencer::type_id::create("seqrh",this);
		end
endfunction

function void router_src_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(m_cfg.is_active==UVM_ACTIVE)
		begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
  		end
endfunction



