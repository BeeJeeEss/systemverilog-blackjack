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
     vga_if wire_tim();
     vga_if wire_bg();
     vga_if wire_card();

  

    /**
     * Signals assignments
     */

    assign vs = wire_card.vsync;
    assign hs = wire_card.hsync;
    assign {r,g,b} = wire_card.rgb;


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

    wire [11:0] rgb_wire;
    wire [12:0] address_wire;
    wire [6:0] card_number;
    wire [3:0] card_symbol;

    draw_card u_draw_card(
        .clk,
        .rst,
       
        .vga_card_in(wire_bg),
        .vga_card_out(wire_card),

        .pixel_addr (address_wire),
        .rgb_pixel(rgb_wire),
        .card_number(card_number),
        .card_symbol(card_symbol)

    );


    image_rom_card u_image_rom_card(
        .clk,
        .card_number(card_number),
        .card_symbol(card_symbol),
        .addrA(address_wire),
        .dout(rgb_wire)

    );

endmodule
