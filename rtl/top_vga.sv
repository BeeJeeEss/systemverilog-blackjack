/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * The project top module.
 */

`timescale 1 ns / 1 ps

module top_vga (
    input  logic clk,
    input  logic rst,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);


/**
 * Local variables and signals
 */

// VGA signals from timing
wire [10:0] vcount_tim, hcount_tim;
wire vsync_tim, hsync_tim;
wire vblnk_tim, hblnk_tim;

// VGA signals from background
wire [10:0] vcount_bg, hcount_bg;
wire vsync_bg, hsync_bg;
wire vblnk_bg, hblnk_bg;
wire [11:0] rgb_bg;

// VGA signals from draw_card
wire [10:0] vcount_card, hcount_card;
wire vsync_card, hsync_card;
wire vblnk_card, hblnk_card;
wire [11:0] rgb_card;


/**
 * Signals assignments
 */

assign vs = vsync_card;
assign hs = hsync_card;
assign {r,g,b} = rgb_card;


/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk,
    .rst,
    .vcount (vcount_tim),
    .vsync  (vsync_tim),
    .vblnk  (vblnk_tim),
    .hcount (hcount_tim),
    .hsync  (hsync_tim),
    .hblnk  (hblnk_tim)
);

background_display u_background_display (
    .clk(clk),
    .rst(rst),
    .hcount_in(hcount_tim),
    .vcount_in(vcount_tim),
    .xpos(11'd0), // Załóżmy, że obrazek zaczyna się od (0,0)
    .ypos(11'd0),
    .pixel_out(pixel_out)
);

    wire [11:0] rgb_wire;
    wire [11:0] address_wire;

draw_card u_draw_card(
    .clk,
    .rst,

    .vcount_in  (vcount_bg),
    .vsync_in   (vsync_bg),
    .vblnk_in   (vblnk_bg),
    .hcount_in  (hcount_bg),
    .hsync_in   (hsync_bg),
    .hblnk_in   (hblnk_bg),
    .rgb_pixel  (rgb_wire),
    
    .rgb_in     (rgb_bg),

    .vcount_out (vcount_card),
    .vsync_out  (vsync_card),
    .vblnk_out  (vblnk_card),
    .hcount_out (hcount_card),
    .hsync_out  (hsync_card),
    .hblnk_out  (hblnk_card),
    .pixel_addr (address_wire),

    .rgb_out    (rgb_card)
);


image_rom_card u_image_rom_card(
    .clk,

    .address(address_wire),
    .rgb(rgb_wire)

);

endmodule
