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
		input wire [3:0] card_symbol,
		input wire [6:0] card_number,
		input wire clk, // posedge active clock
		input wire [ADDR_WIDTH - 1 : 0 ] addrA,
		output logic [DATA_WIDTH - 1 : 0 ] dout
	);

	(* rom_style = "block" *) // block || distributed

	logic [DATA_WIDTH-1:0] rom [2**ADDR_WIDTH-1:0]; // rom memory
	
	string data_path_serce;
	string data_path_pik;
	string data_path_romb;
	string data_path_trefl;

	always_ff @(posedge clk) begin : rom_read_blk
			dout <= rom[addrA];
	end


	always_comb begin
		if (card_symbol == 0) begin
			data_path_serce = $sformatf("../../rtl/card_data/%0d_serce.dat", card_number);
    		$readmemh(data_path_serce, rom);
		end if (card_symbol == 1) begin
			data_path_pik = $sformatf("../../rtl/card_data/%0d_pik.dat", card_number);
    		$readmemh(data_path_pik, rom);
		end if (card_symbol == 2) begin
			data_path_romb = $sformatf("../../rtl/card_data/%0d_romb.dat", card_number);
    		$readmemh(data_path_romb, rom);
		end if (card_symbol == 3) begin
			data_path_trefl = $sformatf("../../rtl/card_data/%0d_trefl.dat", card_number);
    		$readmemh(data_path_trefl, rom);
		end 		
	end

endmodule

