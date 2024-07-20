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
		DATA_WIDTH = 12,
		CARD_SYMBOL = 0,
		CARD_NUMBER = 5
	)
	(
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


	initial begin
		if (CARD_SYMBOL == 0) begin
			data_path_serce = $sformatf("../../rtl/card_data/%0d_serce.dat", CARD_NUMBER);
			$readmemh(data_path_serce, rom);
		end if (CARD_SYMBOL == 1) begin
			data_path_pik = $sformatf("../../rtl/card_data/%0d_pik.dat", CARD_NUMBER);
			$readmemh(data_path_pik, rom);
		end if (CARD_SYMBOL == 2) begin
			data_path_romb = $sformatf("../../rtl/card_data/%0d_romb.dat", CARD_NUMBER);
			$readmemh(data_path_romb, rom);
		end if (CARD_SYMBOL == 3) begin
			data_path_trefl = $sformatf("../../rtl/card_data/%0d_trefl.dat", CARD_NUMBER);
			$readmemh(data_path_trefl, rom);
		end
	end

endmodule

