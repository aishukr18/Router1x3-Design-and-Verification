class router_tb extends uvm_env;
	`uvm_component_utils(router_tb)
	

	router_src_agt_top sagt_top;
	router_dst_agt_top dagt_top;

	router_virtual_sequencer v_seqr;
	router_scoreboard sb;
  router_env_config env_cfg;


	extern function new(string name = "router_tb", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);


endclass

function router_tb::new(string name = "router_tb", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_tb::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
		`uvm_fatal("CONFIG","cannot get() env_cfg from uvm_config_db. Have you set() it?")
	if(env_cfg.has_sagent)
		sagt_top = router_src_agt_top::type_id::create("sagt_top",this);
	if(env_cfg.has_dagent)
		dagt_top = router_dst_agt_top::type_id::create("dagt_top",this);
	if(env_cfg.has_scoreboard)
		sb = router_scoreboard::type_id::create("sb",this);
	
	if(env_cfg.has_virtual_sequencer)
		v_seqr = router_virtual_sequencer::type_id::create("v_seqr",this); 
endfunction

function void router_tb::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	for(int i=0;i<env_cfg.no_of_src_agent;i++)
		v_seqr.s_seqr[i] = sagt_top.src_agnth[i].seqrh;
	for(int i=0;i<env_cfg.no_of_dst_agent;i++)
		v_seqr.d_seqr[i] = dagt_top.dst_agnth[i].seqrh;
	for(int i=0;i<env_cfg.no_of_src_agent;i++)
		sagt_top.src_agnth[i].monh.monitor_port.connect(sb.src_fifo[i].analysis_export);	
	for(int i=0;i<env_cfg.no_of_dst_agent;i++)
		dagt_top.dst_agnth[i].monh.monitor_port.connect(sb.dst_fifo[i].analysis_export);	
	
endfunction


