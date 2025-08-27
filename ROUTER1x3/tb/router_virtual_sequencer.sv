class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

	`uvm_component_utils(router_virtual_sequencer)
	
	router_src_sequencer s_seqr[];
	router_dst_sequencer d_seqr[];
	router_env_config m_cfg;
	
	extern function new(string name = "router_virtual_sequencer",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass
	
function router_virtual_sequencer::new(string name = "router_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_virtual_sequencer::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("uvm_config","could not get the uvm_config_db in virtual sequencer did you set it?")
	s_seqr = new[m_cfg.no_of_src_agent];
	d_seqr = new[m_cfg.no_of_dst_agent];
endfunction

