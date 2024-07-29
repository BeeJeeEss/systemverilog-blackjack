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
        input  logic clk975Mhz,
        input  logic rst,
        output logic vs,
        output logic hs,
        output logic [3:0] r,
        output logic [3:0] g,
        output logic [3:0] b,
        inout  logic PS2Clk,
        inout  logic PS2Data
    );


    /**
     * Local variables and signals
     */

    vga_if wire_tim();
    vga_if wire_bg();
    vga_if wire_mouse();
    vga_if wire_test();
    vga_if wire_delay_rect();
    vga_if wire_char();
    vga_if before_wire_char_rgb();
    vga_if after_wire_char_rgb();
// VGA signals from timing

// VGA signals from background


    /**
     * Signals assignments
     */

    assign vs = wire_mouse.vsync;
    assign hs = wire_mouse.hsync;
    assign {r,g,b} = wire_mouse.rgb;


    /**
     * Submodules instances
     */

    vga_timing u_vga_timing (
        .clk,
        .rst,
        .vga_tim(wire_tim)
    );

    draw_bg u_draw_bg (
        .clk,
        .rst,

        .vga_bg_in(wire_tim),
        .vga_bg_out(wire_bg)
    );

    wire left;
    wire right;
    wire [11:0] xpos;
    wire [11:0] ypos;

    MouseCtl u_MouseCtl (
        .clk(clk975Mhz),
        .rst,

        .left(left),
        .right(right),

        .ps2_data(PS2Data),
        .ps2_clk(PS2Clk),

        .xpos(xpos),
        .ypos(ypos)
    );

    wire [11:0] xpos_nxt;
    wire [11:0] ypos_nxt;

    wire left_nxt;
    wire right_nxt;

    hold_mouse u_hold_mouse(
        .clk,
        .rst,

        .left(left),
        .right(right),
        .xpos(xpos),
        .ypos(ypos),

        .left_out(left_nxt),
        .right_out(right_nxt),
        .xposout(xpos_nxt),
        .yposout(ypos_nxt)

    );

    draw_mouse u_draw_mouse (
        .clk,
        .rst,

        .vga_mouse_in(wire_test),
        .vga_mouse_out(wire_mouse),

        .xpos(xpos_nxt),
        .ypos(ypos_nxt)
    );

    test u_test (
        .clk,
        .rst,
        .vga_blackjack_in(wire_char),
        .vga_blackjack_out(wire_test)

    );

    wire [7:0] char_pxl;
    wire [7:0] char_xy;
    wire [3:0] char_line;
    wire [6:0] char_coded;

    font_rom u_font_rom(
        .clk,
        .addr({char_coded[6:0], char_line[3:0]}),
        .char_line_pixels(char_pxl)
    );

    draw_rect_char u_draw_rect_char (
        .clk,
        .rst,
        .vga_in(wire_bg),
        .vga_out(wire_char),
        .char_line,
        .char_xy,
        .char_pixels(char_pxl)
    );

    char_16x16 u_char_16x16 (
        .clk,
        .char_code(char_coded),
        .char_xy
    );

endmodule
