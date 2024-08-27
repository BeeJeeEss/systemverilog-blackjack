//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   image_rom_card
 Author:        Robert Szczygiel
 Modified by: Konrad Sawina, Borys Strzeboński
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

module image_rom_deck
    #(parameter
        ADDR_WIDTH = 13,
        DATA_WIDTH = 12
    )
    (
        input wire clk, // posedge active clock
        input wire [ADDR_WIDTH - 1 : 0 ] addrA,
        output logic [DATA_WIDTH - 1 : 0 ] dout
    );

    (* rom_style = "block" *)

    logic [DATA_WIDTH-1:0] rom [2**ADDR_WIDTH-1:0];

    initial
        $readmemh("../../rtl/card/card_data/deck.dat", rom);

    always_ff @(posedge clk) begin : rom_read_blk
        dout <= rom[addrA];
    end

endmodule
