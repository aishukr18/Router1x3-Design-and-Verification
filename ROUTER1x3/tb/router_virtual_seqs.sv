class router_virtual_seq extends uvm_sequence #(uvm_sequence_item);
	
	`uvm_object_utils(router_virtual_seq)  
	
	router_virtual_sequencer v_seqr;
	
	router_src_sequencer s_seqr[];
	router_dst_sequencer d_seqr[];
	
	router_env_config m_cfg;
	
	extern function new(string name = "router_virtual_seq");
	extern task body();

endclass

function router_virtual_seq::new(string name ="router_virtual_seq");
	super.new(name);
endfunction

task router_virtual_seq::body();
		
	if(!uvm_config_db #(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
		`uvm_fatal("uvm_config","could not get the uvm_config_db in virtual sequencer did you set it?")
	s_seqr = new[m_cfg.no_of_src_agent];
	d_seqr = new[m_cfg.no_of_dst_agent];

	 assert($cast(v_seqr,m_sequencer)) 
		else begin
		    `uvm_error("BODY", "Error in $cast of virtual sequencer")
  		end

	foreach(s_seqr[i])
		s_seqr[i] = v_seqr.s_seqr[i];
	foreach(d_seqr[i])
		d_seqr[i] = v_seqr.d_seqr[i];
endtask

//=================================small_packet=================================//

class small_packet_vseq extends router_virtual_seq;
	`uvm_object_utils(small_packet_vseq)

	small_packet small_seqh;
	read_enb_seq read_seqh;

	bit [1:0]addr;

	extern function new(string name = "small_packet_vseq");
	extern task body();
endclass

function small_packet_vseq::new(string name = "small_packet_vseq");
	super.new(name);
endfunction

task small_packet_vseq::body();
	super.body();

	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
		`uvm_fatal("ADDR_CONFIG","cannot get() addr from config db ")

	small_seqh = small_packet::type_id::create("small_seqh");
	read_seqh  = read_enb_seq::type_id::create("read_seqh");

	fork
			small_seqh.start(s_seqr[0]);
			read_seqh.start(d_seqr[addr]);
	join
endtask


//=================================medium_packet=================================//

class medium_packet_vseq extends router_virtual_seq;
	`uvm_object_utils(medium_packet_vseq)

	medium_packet medium_seqh;
	read_enb_seq read_seqh;

	bit [1:0]addr;

	extern function new(string name = "medium_packet_vseq");
	extern task body();
endclass

function medium_packet_vseq::new(string name = "medium_packet_vseq");
	super.new(name);
endfunction

task medium_packet_vseq::body();
	super.body();

	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
		`uvm_fatal("ADDR_CONFIG","cannot get() addr from config db ")

	medium_seqh = medium_packet::type_id::create("medium_seqh");
	read_seqh  = read_enb_seq::type_id::create("read_seqh");

	fork
			medium_seqh.start(s_seqr[0]);
			read_seqh.start(d_seqr[addr]);
	join
endtask


//=================================large_packet=================================//

class large_packet_vseq extends router_virtual_seq;
	`uvm_object_utils(large_packet_vseq)

	large_packet large_seqh;
	read_enb_seq read_seqh;

	bit [1:0]addr;

	extern function new(string name = "large_packet_vseq");
	extern task body();
endclass

function large_packet_vseq::new(string name = "large_packet_vseq");
	super.new(name);
endfunction

task large_packet_vseq::body();
	super.body();

	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
		`uvm_fatal("ADDR_CONFIG","cannot get() addr from config db ")

	large_seqh = large_packet::type_id::create("large_seqh");
	read_seqh  = read_enb_seq::type_id::create("read_seqh");

	fork
			large_seqh.start(s_seqr[0]);
			read_seqh.start(d_seqr[addr]);
	join
endtask
	
	
	
	

