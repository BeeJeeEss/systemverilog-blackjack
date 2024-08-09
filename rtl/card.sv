 /**
  * Konrad Sawina
  *
  *
  */

 `timescale 1 ns / 1 ps

module card (

        input  logic clk,
        input  logic rst,

        SM_if.in SM_in,

        vga_if.in card_in,
        vga_if.out card_out
    );


    /**
     * Local variables and signals
     */

    vga_if wire_card [0:7]();
    wire [11:0] rgb_wire [0:8];
    wire [10:0] address_wire [0:8];




    /**
     * Submodules instances
     */



    draw_card #(
        .CARD_XPOS(437),
        .CARD_YPOS(550),
        .MODULE_NUMBER(0)
    ) u_draw_card0 (
        .clk,
        .rst,

        .vga_card_in(card_in),
        .vga_card_out(wire_card[0]),
        .pixel_addr (address_wire[0]),
        .rgb_pixel(rgb_wire[0]),

        .SM_in(SM_in)

    );

    image_rom_card #(
        .MODULE_NUMBER(0)
    )  u_image_rom_card0(
        .clk,
        .addrA(address_wire[0]),
        .dout(rgb_wire[0]),
        .image_in(SM_in)

    );

    draw_card #(
        .CARD_XPOS(467),
        .CARD_YPOS(550),
        .MODULE_NUMBER(1)
    ) u_draw_card1 (
        .clk,
        .rst,

        .vga_card_in(wire_card[0]),
        .vga_card_out(wire_card[1]),
        .pixel_addr (address_wire[1]),
        .rgb_pixel(rgb_wire[1]),

        .SM_in(SM_in)

    );

    image_rom_card #(
        .MODULE_NUMBER(1)
    )  u_image_rom_card1(
        .clk,
        .addrA(address_wire[1]),
        .dout(rgb_wire[1]),
        .image_in(SM_in)

    );

    draw_card #(
        .CARD_XPOS(497),
        .CARD_YPOS(550),
        .MODULE_NUMBER(2)
    ) u_draw_card2 (
        .clk,
        .rst,

        .vga_card_in(wire_card[1]),
        .vga_card_out(wire_card[2]),
        .pixel_addr (address_wire[2]),
        .rgb_pixel(rgb_wire[2]),

        .SM_in(SM_in)

    );

    image_rom_card #(
        .MODULE_NUMBER(2)
    )  u_image_rom_card2(
        .clk,
        .addrA(address_wire[2]),
        .dout(rgb_wire[2]),
        .image_in(SM_in)

    );

    draw_card #(
        .CARD_XPOS(527),
        .CARD_YPOS(550),
        .MODULE_NUMBER(3)
    ) u_draw_card3 (
        .clk,
        .rst,

        .vga_card_in(wire_card[2]),
        .vga_card_out(wire_card[3]),
        .pixel_addr (address_wire[3]),
        .rgb_pixel(rgb_wire[3]),

        .SM_in(SM_in)

    );

    image_rom_card #(
        .MODULE_NUMBER(3)
    )  u_image_rom_card3(
        .clk,
        .addrA(address_wire[3]),
        .dout(rgb_wire[3]),
        .image_in(SM_in)

    );

    draw_card #(
        .CARD_XPOS(557),
        .CARD_YPOS(550),
        .MODULE_NUMBER(4)
    ) u_draw_card4 (
        .clk,
        .rst,

        .vga_card_in(wire_card[3]),
        .vga_card_out(wire_card[4]),
        .pixel_addr (address_wire[4]),
        .rgb_pixel(rgb_wire[4]),

        .SM_in(SM_in)

    );

    image_rom_card #(
        .MODULE_NUMBER(4)
    )  u_image_rom_card4(
        .clk,
        .addrA(address_wire[4]),
        .dout(rgb_wire[4]),
        .image_in(SM_in)

    );

    draw_card #(
        .CARD_XPOS(587),
        .CARD_YPOS(550),
        .MODULE_NUMBER(5)
    ) u_draw_card5 (
        .clk,
        .rst,

        .vga_card_in(wire_card[4]),
        .vga_card_out(wire_card[5]),
        .pixel_addr (address_wire[5]),
        .rgb_pixel(rgb_wire[5]),

        .SM_in(SM_in)

    );

    image_rom_card #(
        .MODULE_NUMBER(5)
    )  u_image_rom_card5(
        .clk,
        .addrA(address_wire[5]),
        .dout(rgb_wire[5]),
        .image_in(SM_in)

    );

    draw_card #(
        .CARD_XPOS(617),
        .CARD_YPOS(550),
        .MODULE_NUMBER(6)
    ) u_draw_card6 (
        .clk,
        .rst,

        .vga_card_in(wire_card[5]),
        .vga_card_out(wire_card[6]),
        .pixel_addr (address_wire[6]),
        .rgb_pixel(rgb_wire[6]),

        .SM_in(SM_in)

    );

    image_rom_card #(
        .MODULE_NUMBER(6)
    )  u_image_rom_card6(
        .clk,
        .addrA(address_wire[6]),
        .dout(rgb_wire[6]),
        .image_in(SM_in)

    );

    draw_card #(
        .CARD_XPOS(647),
        .CARD_YPOS(550),
        .MODULE_NUMBER(7)
    ) u_draw_card7 (
        .clk,
        .rst,

        .vga_card_in(wire_card[6]),
        .vga_card_out(wire_card[7]),
        .pixel_addr (address_wire[7]),
        .rgb_pixel(rgb_wire[7]),

        .SM_in(SM_in)

    );

    image_rom_card #(
        .MODULE_NUMBER(7)
    )  u_image_rom_card7(
        .clk,
        .addrA(address_wire[7]),
        .dout(rgb_wire[7]),
        .image_in(SM_in)

    );

    draw_card #(
        .CARD_XPOS(677),
        .CARD_YPOS(550),
        .MODULE_NUMBER(8)
    ) u_draw_card8 (
        .clk,
        .rst,

        .vga_card_in(wire_card[7]),
        .vga_card_out(card_out),
        .pixel_addr (address_wire[8]),
        .rgb_pixel(rgb_wire[8]),

        .SM_in(SM_in)

    );

    image_rom_card #(
        .MODULE_NUMBER(8)
    )  u_image_rom_card8(
        .clk,
        .addrA(address_wire[8]),
        .dout(rgb_wire[8]),
        .image_in(SM_in)

    );




endmodule
