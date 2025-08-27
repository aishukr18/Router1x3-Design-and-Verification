class router_src_agt_top extends uvm_env;
	`uvm_component_utils(router_src_agt_top)

	router_src_agent src_agnth[];
	router_env_config env_cfg;	
	
	extern function new(string name = "router_src_agt_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass

function router_src_agt_top::new(string name = "router_src_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction

//-----------------  build() phase method  -------------------//
function void router_src_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
		`uvm_fatal("CONFIG","cannot get() env_cfg from uvm_config_db. Have you set() it?")
	src_agnth = new[env_cfg.no_of_src_agent];
	foreach(src_agnth[i])
		begin
			src_agnth[i] = router_src_agent::type_id::create($sformatf("src_agnth[%0d]",i),this);
			uvm_config_db #(router_src_agent_config)::set(this,"*","router_src_agent_config",env_cfg.src_cfg[i]);
		end
endfunction

