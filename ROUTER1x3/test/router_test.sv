class router_test extends uvm_test;

	`uvm_component_utils(router_test)
	
	router_tb envh;
	router_env_config env_cfg;
	router_src_agent_config src_cfg[];
	router_dst_agent_config dst_cfg[];
	
	int no_of_src_agent = 1;
	int no_of_dst_agent = 3;
	
	bit has_sagent = 1;
    	bit has_dagent = 1;


	extern function new(string name = "router_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

function router_test::new(string name = "router_test" , uvm_component parent);
	super.new(name,parent);
	
endfunction

function void router_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	env_cfg = router_env_config::type_id::create("env_cfg");
	src_cfg = new[no_of_src_agent];
	env_cfg.src_cfg = new[no_of_src_agent];
	foreach(src_cfg[i])
		begin
			src_cfg[i] = router_src_agent_config::type_id::create($sformatf("src_cfg[%0d]",i));
			if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("src_if%0d",i),src_cfg[i].vif))
				`uvm_fatal("error","could not get the config_db")
			src_cfg[i].is_active = UVM_ACTIVE;
			env_cfg.src_cfg[i] = src_cfg[i];
			
		end
	dst_cfg = new[no_of_dst_agent];
	env_cfg.dst_cfg = new[no_of_dst_agent];

	foreach(dst_cfg[i])
		begin
			dst_cfg[i] = router_dst_agent_config::type_id::create($sformatf("dst_cfg[%0d]",i));
			if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("dst_if%0d",i),dst_cfg[i].vif))
				`uvm_fatal("error","could not get the config_db")
			dst_cfg[i].is_active = UVM_ACTIVE;
			env_cfg.dst_cfg[i] = dst_cfg[i];
		end
		env_cfg.no_of_src_agent = no_of_src_agent;
		env_cfg.no_of_dst_agent =  no_of_dst_agent;
	
			
	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",env_cfg);
	envh = router_tb::type_id::create("envh", this);
	
endfunction

function void router_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);

	uvm_top.print_topology();
endfunction

//-------------------SMALL PACKET TEST----------------------------------------------------------//
class small_packet_test extends router_test;

	`uvm_component_utils(small_packet_test)
	
	small_packet_vseq small_seqh;
	bit [1:0] addr=0;
	//small_packet s_seq;

	extern function new(string name = "small_packet_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function small_packet_test::new(string name = "small_packet_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void small_packet_test::build_phase(uvm_phase phase);

	small_seqh = small_packet_vseq::type_id::create("small_seqh");
	
	addr =0;
	uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
	super.build_phase(phase);

endfunction

task small_packet_test::run_phase(uvm_phase phase);
	
//      s_seq = small_packet::type_id::create("s_seq");
//	addr = 0;
//	uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);

	phase.raise_objection(this);
	small_seqh.start(envh.v_seqr);
	#500;
	phase.drop_objection(this);
endtask
	

//-------------------MEDIUM PACKET TEST----------------------------------------------------------//
class medium_packet_test extends router_test;

	`uvm_component_utils(medium_packet_test)

	medium_packet_vseq medium_seqh;
	
	bit [1:0] addr = 1;
//	medium_packet m_seq;

	extern function new(string name = "medium_packet_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function medium_packet_test::new(string name = "medium_packet_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void medium_packet_test::build_phase(uvm_phase phase);

	medium_seqh = medium_packet_vseq::type_id::create("medium_seqh");
	super.build_phase(phase);

	uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

endfunction

task medium_packet_test::run_phase(uvm_phase phase);
	
//	m_seq = medium_packet::type_id::create("m_seq");
//	addr = 1;
//	uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);

	phase.raise_objection(this);
	medium_seqh.start(envh.v_seqr);
	#500;
	phase.drop_objection(this);
endtask

//-------------------LARGE PACKET TEST----------------------------------------------------------//
class large_packet_test extends router_test;

	`uvm_component_utils(large_packet_test)

	large_packet_vseq large_seqh;	
	bit [1:0] addr = 2;
//	large_packet l_seq;

	extern function new(string name = "large_packet_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function large_packet_test::new(string name = "large_packet_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void large_packet_test::build_phase(uvm_phase phase);
	super.build_phase(phase);

	large_seqh=large_packet_vseq::type_id::create("large_seqh");
	uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

endfunction

task large_packet_test::run_phase(uvm_phase phase);
	
//	l_seq = large_packet::type_id::create("l_seq");
//	addr = 2;
//	uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);

	phase.raise_objection(this);
	large_seqh.start(envh.v_seqr);
	#500;
	phase.drop_objection(this);
endtask

//---------------------------read_enb_test---------------------------------------------/
class read_enb_test extends router_test;
	
	`uvm_component_utils(read_enb_test)
	read_enb_seq read_seq;
	small_packet small_seq;
	
	bit[1:0] addr = 0;

	extern function new(string name = "read_enb_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function read_enb_test::new(string name = "read_enb_test",uvm_component parent);
	super.new(name,parent);
endfunction


function void read_enb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);

	read_seq = read_enb_seq::type_id::create("read_seq",this);
	small_seq = small_packet::type_id::create("small_seq",this);
	
	uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
endfunction

task read_enb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	fork
	small_seq.start(envh.sagt_top.src_agnth[0].seqrh);
	read_seq.start(envh.dagt_top.dst_agnth[addr].seqrh);	
	join
	#500;
	phase.drop_objection(this);
endtask

//===========================soft_test===================================================//
class soft_reset_test extends router_test;
	
	`uvm_component_utils(soft_reset_test)
	soft_reset_seq soft_seq;
	small_packet small_seq;
	
	bit[1:0] addr = 0;

	extern function new(string name = "soft_reset_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function soft_reset_test::new(string name = "soft_reset_test",uvm_component parent);
	super.new(name,parent);
endfunction


function void soft_reset_test::build_phase(uvm_phase phase);
	super.build_phase(phase);

	soft_seq = soft_reset_seq::type_id::create("soft_seq",this);
	small_seq = small_packet::type_id::create("small_seq",this);
	
	uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
endfunction

task soft_reset_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	fork
	small_seq.start(envh.sagt_top.src_agnth[0].seqrh);
	soft_seq.start(envh.dagt_top.dst_agnth[addr].seqrh);	
	join
	#500;
	phase.drop_objection(this);
endtask



	

