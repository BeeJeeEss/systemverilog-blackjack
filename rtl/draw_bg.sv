`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_bg
 Author:        Borys Strzebonski
 */
//////////////////////////////////////////////////////////////////////////////


module draw_bg (
        input  logic clk,
        input  logic rst,

<<<<<<< HEAD
    vga_if.out vga_bg_out,
    vga_if.in vga_bg_in
);
=======
        vga_if.out vga_bg_out,
        vga_if.in vga_bg_in
    );

    import vga_pkg::*;

// Parameters for ROM
    localparam ADDR_WIDTH = 16;  // Adjust based on the size of the image
    localparam DATA_WIDTH = 12;  // RGB pixel width
>>>>>>> main

    /**
     * Local variables and signals
     */
    logic [DATA_WIDTH-1:0] rgb_nxt;
    logic [ADDR_WIDTH-1:0] pixel_addr;
    logic [DATA_WIDTH-1:0] rom_data;

    /**
     * ROM Instance
     */
    draw_bg_rom #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_draw_bg_rom (
        .clk(clk),
        .en(1'b1),  // Always enable the ROM
        .addrA(pixel_addr),
        .dout(rom_data)
    );

<<<<<<< HEAD
/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;


/**
 * Internal logic
 */

always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        vga_bg_out.vcount   <= '0;
        vga_bg_out.vsync    <= '0;
        vga_bg_out.vblnk    <= '0;
        vga_bg_out.hcount   <= '0;
        vga_bg_out.hsync    <= '0;
        vga_bg_out.hblnk    <= '0;
        vga_bg_out.rgb      <= '0;
    end else begin
        vga_bg_out.vcount <=  vga_bg_in.vcount;
        vga_bg_out.vsync  <=  vga_bg_in.vsync;
        vga_bg_out.vblnk  <=  vga_bg_in.vblnk;
        vga_bg_out.hcount <=  vga_bg_in.hcount;
        vga_bg_out.hsync  <=  vga_bg_in.hsync;
        vga_bg_out.hblnk  <=  vga_bg_in.hblnk;
        vga_bg_out.rgb   <= rgb_nxt;
=======
    /**
     * Internal logic
     */
    always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
            vga_bg_out.vcount   <= '0;
            vga_bg_out.vsync    <= '0;
            vga_bg_out.vblnk    <= '0;
            vga_bg_out.hcount   <= '0;
            vga_bg_out.hsync    <= '0;
            vga_bg_out.hblnk    <= '0;
            vga_bg_out.rgb      <= '0;
        end else begin
            vga_bg_out.vcount <=  vga_bg_in.vcount;
            vga_bg_out.vsync  <=  vga_bg_in.vsync;
            vga_bg_out.vblnk  <=  vga_bg_in.vblnk;
            vga_bg_out.hcount <=  vga_bg_in.hcount;
            vga_bg_out.hsync  <=  vga_bg_in.hsync;
            vga_bg_out.hblnk  <=  vga_bg_in.hblnk;
            vga_bg_out.rgb    <= rgb_nxt;
        end
>>>>>>> main
    end

<<<<<<< HEAD
always_comb begin : bg_comb_blk
    if ( vga_bg_in.vblnk ||  vga_bg_in.hblnk) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                    // - make it it black.
    end else begin                              // Active region:
        if ( vga_bg_in.vcount == 0)                     // - top edge:
            rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
        else if ( vga_bg_in.vcount == VER_PIXELS)   // - bottom edge:
            rgb_nxt = 12'hf_0_0;                // - - make a red line.
        else if ( vga_bg_in.hcount == 0)                // - left edge:
            rgb_nxt = 12'h0_f_0;                // - - make a green line.
        else if ( vga_bg_in.hcount == HOR_PIXELS - 1)   // - right edge:
            rgb_nxt = 12'h0_0_f;                // - - make a blue line.

        // Add your code here.

        else                                    // The rest of active display pixels:
            rgb_nxt = 12'h8_8_8;                // - fill with gray.
=======
    always_comb begin : bg_comb_blk
        if (vga_bg_in.vblnk || vga_bg_in.hblnk) begin  // Blanking region:
            rgb_nxt = 12'h0_0_0;  // - make it black.
        end else begin  // Active region:
            // Calculate the address for the current pixel
            pixel_addr = vga_bg_in.vcount * HOR_PIXELS + vga_bg_in.hcount;
            rgb_nxt = rom_data;  // Get the pixel data from ROM
        end
>>>>>>> main
    end

endmodule
