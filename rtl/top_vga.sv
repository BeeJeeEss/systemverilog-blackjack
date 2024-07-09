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


/**
 * Signals assignments
 */

assign vs = vsync_bg;
assign hs = hsync_bg;
assign {r,g,b} = rgb_bg;


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

endmodule
