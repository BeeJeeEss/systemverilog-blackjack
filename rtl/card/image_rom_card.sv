//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   template_rom
 Author:        Robert Szczygiel
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: Xilinx recommended + ANSI ports
 Description:  Template for ROM module as recommended by Xilinx

 ** This example shows the use of the Vivado rom_style attribute
 **
 ** Acceptable values are:
 ** block : Instructs the tool to infer RAMB type components.
 ** distributed : Instructs the tool to infer LUT ROMs.
 **
 */
//////////////////////////////////////////////////////////////////////////////
 module image_rom_card
	#(parameter
		ADDR_WIDTH = 13,
		DATA_WIDTH = 12
	)
	(
		input wire clk, // posedge active clock
		input wire [ADDR_WIDTH - 1 : 0 ] addrA,
		input  logic [1:0] card_symbol,

		output logic [DATA_WIDTH - 1 : 0 ] dout
	);

	(* rom_style = "block" *) // block || distributed

	logic [DATA_WIDTH-1:0] rom [3:0] [2**ADDR_WIDTH-1:0];

	
	

	always_ff @(posedge clk) begin : rom_read_blk
		dout <= rom[card_symbol][addrA];
	end
			
				


	
	initial begin
		 $readmemh("../../rtl/card/card_data/trefl.dat", rom[0]);
		 $readmemh("../../rtl/card/card_data/pik.dat", rom[1]);
		 $readmemh("../../rtl/card/card_data/serce.dat", rom[2]);
		 $readmemh("../../rtl/card/card_data/romb.dat", rom[3]);
	end

endmodule
