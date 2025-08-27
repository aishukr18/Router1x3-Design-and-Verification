class router_dst_sequencer extends uvm_sequencer #(dst_xtn);

	`uvm_component_utils(router_dst_sequencer)

	extern function new(string name = "router_dst_sequencer",uvm_component parent);
endclass

function router_dst_sequencer::new(string name="router_dst_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

