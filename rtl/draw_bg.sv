 /**
  * Copyright (C) 2023  AGH University of Science and Technology
  * MTM UEC2
  * Author: Piotr Kaczmarczyk
  *
  * Description:
  * Draw background.
  */



 `timescale 1 ns / 1 ps

module draw_bg (
        input  logic clk,
        input  logic rst,

        vga_if.out vga_bg_out,
        vga_if.in vga_bg_in

    );

    import vga_pkg::*;


    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;


    /**
     * Internal logic
     */

    always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
            vga_bg_out.vcount <= '0;
            vga_bg_out.vsync  <= '0;
            vga_bg_out.vblnk <= '0;
            vga_bg_out.hcount <= '0;
            vga_bg_out.hsync  <= '0;
            vga_bg_out.hblnk  <= '0;
            vga_bg_out.rgb    <= '0;
        end else begin
            vga_bg_out.vcount <= vga_bg_in.vcount;
            vga_bg_out.vsync  <= vga_bg_in.vsync;
            vga_bg_out.vblnk  <= vga_bg_in.vblnk;
            vga_bg_out.hcount <= vga_bg_in.hcount;
            vga_bg_out.hsync  <= vga_bg_in.hsync;
            vga_bg_out.hblnk  <= vga_bg_in.hblnk;
            vga_bg_out.rgb    <= rgb_nxt;
        end
    end


// Constants for colors
    localparam LIGHT_GREEN = 12'h0_a_0;
    localparam DARK_GREEN = 12'h0_5_0;

    // Parameters for centering the rectangles
    localparam RECT_WIDTH = 600; // Width of the main rectangles (dealer and player)
    localparam RECT_HEIGHT = 100; // Height of the main rectangles (dealer and player)
    localparam CHIP_RECT_WIDTH = 400; // Width of the chip rectangle
    localparam CHIP_RECT_HEIGHT = 50; // Height of the chip rectangle

    // Positions
    localparam DEALER_Y_START = 50; // Y start position for dealer rectangle (with 50px margin)
    localparam DEALER_Y_END = DEALER_Y_START + RECT_HEIGHT; // Y end position for dealer rectangle
    localparam PLAYER_Y_START = 400; // Y start position for player rectangle (centered vertically)
    localparam PLAYER_Y_END = PLAYER_Y_START + RECT_HEIGHT; // Y end position for player rectangle
    localparam CHIP_Y_START = PLAYER_Y_START - CHIP_RECT_HEIGHT - 20; // Y start position for chip rectangle (above the player rectangle)
    localparam CHIP_Y_END = CHIP_Y_START + CHIP_RECT_HEIGHT; // Y end position for chip rectangle
    localparam RECT_X_START = 100; // X start position for main rectangles (centered horizontally)
    localparam RECT_X_END = RECT_X_START + RECT_WIDTH; // X end position for main rectangles
    localparam CHIP_X_START = 200; // X start position for chip rectangle (centered horizontally)
    localparam CHIP_X_END = CHIP_X_START + CHIP_RECT_WIDTH; // X end position for chip rectangle

    always_comb begin : bg_comb_blk
        if (vga_bg_in.vblnk || vga_bg_in.hblnk) begin
            rgb_nxt = 12'h0_0_0; // Blanking region - black
        end else begin
            // Default background color (light green for the blackjack table)
            rgb_nxt = LIGHT_GREEN;

            // Dealer area (top with 50px margin)
            if ((vga_bg_in.vcount >= DEALER_Y_START && vga_bg_in.vcount < DEALER_Y_END) &&
                    (vga_bg_in.hcount >= RECT_X_START && vga_bg_in.hcount < RECT_X_END)) begin
                rgb_nxt = DARK_GREEN;
            end

            // Player area (centered horizontally and vertically)
            else if ((vga_bg_in.vcount >= PLAYER_Y_START && vga_bg_in.vcount < PLAYER_Y_END) &&
                    (vga_bg_in.hcount >= RECT_X_START && vga_bg_in.hcount < RECT_X_END)) begin
                rgb_nxt = DARK_GREEN;
            end

            // Chip area (centered horizontally and above player area)
            else if ((vga_bg_in.vcount >= CHIP_Y_START && vga_bg_in.vcount < CHIP_Y_END) &&
                    (vga_bg_in.hcount >= CHIP_X_START && vga_bg_in.hcount < CHIP_X_END)) begin
                rgb_nxt = DARK_GREEN;
            end
        end
    end



endmodule
