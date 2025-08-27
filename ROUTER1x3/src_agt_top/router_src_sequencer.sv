class router_src_sequencer extends uvm_sequencer#(src_xtn);
	`uvm_component_utils(router_src_sequencer)
	
	extern function new(string name = "router_src_sequencer",uvm_component parent);
endclass

function router_src_sequencer::new(string name = "router_src_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
