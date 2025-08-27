class router_env_config extends uvm_object;
	
	`uvm_object_utils(router_env_config)

	router_src_agent_config src_cfg[];
	router_dst_agent_config dst_cfg[];
	
	bit has_sagent = 1;
    	bit has_dagent = 1;
	bit has_scoreboard = 1;
	bit has_virtual_sequencer = 1;

	int no_of_src_agent = 1;
	int no_of_dst_agent = 3;


	extern function new(string name = "router_env_config");

endclass: router_env_config

function router_env_config::new(string name = "router_env_config");
	super.new(name);
endfunction




