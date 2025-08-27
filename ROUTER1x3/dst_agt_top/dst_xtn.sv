class dst_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(dst_xtn)

	 bit [7:0] header;
	 bit [7:0] payload[];
	 bit [7:0] parity;
	
	rand bit [5:0] no_of_cycles;
	

	extern function new(string name = "dst_xtn");
	extern function void do_print (uvm_printer printer);
endclass	
	
function dst_xtn::new(string name ="dst_xtn");
	super.new(name);
endfunction

function void  dst_xtn::do_print (uvm_printer printer);
	super.do_print(printer);

   
	//                   srting name	bitstream value     size       radix for printing
	printer.print_field( "header", 		this.header, 	    8,	       UVM_DEC);
	for(int i=0;i<header[7:2];i++)
//	foreach(payload[i])
		begin
    			printer.print_field($sformatf("payload[%0d]",i),this.payload[i], 8,UVM_DEC);
		end

    	printer.print_field( "parity",this.parity,8,UVM_DEC);
	printer.print_field( "no_of_cycles",this.no_of_cycles,6,UVM_DEC);

    
endfunction:do_print

	
