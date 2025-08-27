class src_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(src_xtn)
	
	rand bit [7:0] header;
	rand bit [7:0] payload[];
	rand bit [7:0] parity;
	bit error;
	bit pkt_valid;
	bit busy;
	constraint valid_addr{ header [1:0]!=2'b11;}
	constraint valid_len { header [7:2]!=0;}
	constraint valid_size{payload.size==header[7:2];}
	
	function void post_randomize();
		parity = header;
		foreach(payload[i])
			begin
				parity = payload[i]^parity;
			end
	endfunction       
	

	extern function new(string name = "src_xtn");
	extern function void do_copy (uvm_object rhs);
	extern function bit do_compare (uvm_object rhs,uvm_comparer comparer);
	extern function void do_print (uvm_printer printer);

endclass : src_xtn

function src_xtn::new(string name = "src_xtn");
	super.new(name);
endfunction

function void src_xtn::do_copy(uvm_object rhs);
	
	src_xtn rhs_;
	
	if(!$cast(rhs_,rhs))
		begin
			 `uvm_fatal("do_copy","cast of the rhs object failed")
		end
	super.do_copy(rhs);

	this.header  = rhs_.header;
	this.payload = rhs_.payload;
	this.parity  = rhs_.parity;
	this.error   = rhs_.error;

endfunction

function bit  src_xtn::do_compare (uvm_object rhs,uvm_comparer comparer);

	src_xtn rhs_;

	if(!$cast(rhs_,rhs)) begin
        	`uvm_fatal("do_compare","cast of the rhs object failed")
    		return 0;
    	end

	return super.do_compare(rhs,comparer) &&
    	this.header  == rhs_.header &&
    	this.payload == rhs_.payload &&
    	this.parity  == rhs_.parity &&
	this.error   == rhs_.error;

endfunction

function void  src_xtn::do_print (uvm_printer printer);
	super.do_print(printer);

   
	//                   srting name	bitstream value     size       radix for printing
	printer.print_field( "header", 		this.header, 	    8,	       UVM_DEC);
	for(int i=0;i<header[7:2];i++)
//	foreach(payload[i])
		begin
    			printer.print_field($sformatf("payload[%0d]",i),this.payload[i], 8,UVM_DEC);
		end

    	printer.print_field( "parity",this.parity,8,UVM_DEC);
    	printer.print_field( "error", this.error, 1,UVM_DEC);
    
endfunction:do_print
    


