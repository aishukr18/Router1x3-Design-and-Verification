class router_base_seq extends uvm_sequence #(dst_xtn); 

	`uvm_object_utils(router_base_seq)

	
	
	
	extern function new(string name = "router_base_seq");
endclass

function router_base_seq::new(string name = "router_base_seq");
	super.new(name);
endfunction

//===========================read_enb_seq===================================//
class read_enb_seq extends router_base_seq;
	`uvm_object_utils(read_enb_seq)
	

	extern function new(string name = "read_enb_seq");
	extern task body();
endclass

function read_enb_seq::new(string name = "read_enb_seq");
	super.new(name);
endfunction

task read_enb_seq::body();
	req = dst_xtn ::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_cycles inside {[1:29]};});
	finish_item(req);
endtask

//===============================soft_reset=================================//
class soft_reset_seq extends router_base_seq;
	`uvm_object_utils(soft_reset_seq)
	

	extern function new(string name = "soft_reset_seq");
	extern task body();
endclass

function soft_reset_seq::new(string name = "soft_reset_seq");
	super.new(name);
endfunction

task soft_reset_seq::body();
	req = dst_xtn ::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_cycles > 30;});
	finish_item(req);
endtask

  

