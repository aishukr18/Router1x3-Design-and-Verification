class base_sequence extends uvm_sequence #(src_xtn);
	`uvm_object_utils(base_sequence)
	
	extern function new(string name = "base_sequence");
endclass

function base_sequence::new(string name = "base_sequence");
	super.new(name);
endfunction

//--------------------------SMALL PACKET-------------------------------------//

class small_packet extends base_sequence;

	`uvm_object_utils(small_packet)

	bit[1:0] addr;

    extern function new(string name ="small_packet");
    extern task body();
endclass

function small_packet::new(string name = "small_packet");
	super.new(name);
endfunction

task small_packet::body();
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"addr",addr))
		`uvm_fatal("config for addr in small packet","could not get")
//	repeat(3)
	begin
		req = src_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2]<15; header[1:0] == addr;} );
		req.parity = 1;
       		finish_item(req);
	end
endtask

//--------------------------MEDIUM PACKET-------------------------------------//

class medium_packet extends base_sequence;

	`uvm_object_utils(medium_packet)

	bit[1:0] addr;

    extern function new(string name ="medium_packet");
    extern task body();
endclass

function medium_packet::new(string name = "medium_packet");
	super.new(name);
endfunction

task medium_packet::body();
	//check if repeat needed
	
//	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"addr",addr))
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"addr",addr))
		`uvm_fatal("config for addr in medium packet","could not get")
//	repeat(3)
	begin
		req = src_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[15:30]}; header[1:0] == addr;} );
       		finish_item(req);
	end
endtask
	

//--------------------------LARGE PACKET-------------------------------------//

class large_packet extends base_sequence;

	`uvm_object_utils(large_packet)

	bit[1:0] addr;

    extern function new(string name ="large_packet");
    extern task body();
endclass

function large_packet::new(string name = "large_packet");
	super.new(name);
endfunction

task large_packet::body();
	//check if repeat needed
	
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"addr",addr))
		`uvm_fatal("config for addr in large packet","could not get")
	begin
		req = src_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[31:63]}; header[1:0] == addr;} );
       		finish_item(req);
	end
endtask

	

