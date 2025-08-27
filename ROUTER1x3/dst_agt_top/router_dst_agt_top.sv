class router_dst_agt_top extends uvm_env;

	`uvm_component_utils(router_dst_agt_top)

	router_dst_agent dst_agnth[];
	router_env_config env_cfg;	
	
	extern function new(string name = "router_dst_agt_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function router_dst_agt_top::new(string name = "router_dst_agt_top" , uvm_component parent);
	super.new(name,parent);
endfunction

    
//-----------------  build() phase method  -------------------//
function void router_dst_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
		`uvm_fatal("CONFIG","cannot get() env_cfg from uvm_config_db. Have you set() it?")
	dst_agnth = new[env_cfg.no_of_dst_agent];
	foreach(dst_agnth[i])
		begin
			dst_agnth[i] = router_dst_agent::type_id::create($sformatf("dst_agnth[%0d]",i),this);
			uvm_config_db #(router_dst_agent_config)::set(this,$sformatf("dst_agnth[%0d]*",i),"router_dst_agent_config",env_cfg.dst_cfg[i]);
		end

endfunction



