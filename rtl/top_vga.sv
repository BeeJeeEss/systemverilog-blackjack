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
        input  logic clk100Mhz,
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

// VGA signals from timing
    vga_if wire_tim();
    vga_if wire_bg();
    vga_if wire_mouse();



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

    wire [11:0] xpos;
    wire [11:0] ypos;

    MouseCtl u_MouseCtl (
        .clk(clk100Mhz),
        .rst,

        .ps2_data(PS2Data),
        .ps2_clk(PS2Clk),

        .xpos(xpos),
        .ypos(ypos)
    );

    draw_mouse u_draw_mouse (
        .clk,
        .rst,

        .vga_card_in(wire_bg),
        .vga_card_out(wire_card),

        .vga_mouse_in(wire_bg),
        .vga_mouse_out(wire_mouse),

        .xpos(xpos),
        .ypos(ypos)
    );




endmodule
