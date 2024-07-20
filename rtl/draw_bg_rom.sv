module draw_bg_rom
    #(parameter
        ADDR_WIDTH = 16,  // Adjust as needed
        DATA_WIDTH = 12   // RGB pixel width
    )
    (
        input wire clk,  // posedge active clock
        input wire en,   // enable, can be removed if not needed
        input wire [ADDR_WIDTH - 1 : 0] addrA,
        output logic [DATA_WIDTH - 1 : 0] dout
    );

    (* rom_style = "block" *)  // block || distributed

    logic [DATA_WIDTH-1:0] rom [2**ADDR_WIDTH-1:0];  // rom memory

    initial
        $readmemh("../../rtl/bg.dat", rom);  // Specify your .dat file here

    always_ff @(posedge clk) begin : rom_read_blk
        if (en)
            dout <= rom[addrA];
    end

endmodule
