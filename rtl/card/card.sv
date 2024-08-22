  /**
   * Copyright (C) 2024  AGH University of Science and Technology
   * MTM UEC2
   * Authors: Konrad Sawina, Borys Strzeboński
   * Description:
   * Module responsible for showing cards.
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

    vga_if wire_card [0:17]();
    wire [11:0] rgb_wire [0:17];
    wire [11:0] address_wire [0:17];




    /**
     * Submodules instances
     */



    draw_card #(
        .CARD_XPOS(437),
        .CARD_YPOS(550),
        .MODULE_NUMBER(0),
        .KIND_OF_CARDS(0)
    ) u_draw_card0 (
        .clk,
        .rst,

        .vga_card_in(card_in),
        .vga_card_out(wire_card[0]),
        .pixel_addr (address_wire[0]),
        .rgb_pixel(rgb_wire[0]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card0(
        .clk,
        .addrA(address_wire[0]),
        .dout(rgb_wire[0])
    );

    draw_card #(
        .CARD_XPOS(467),
        .CARD_YPOS(550),
        .MODULE_NUMBER(1),
        .KIND_OF_CARDS(0)
    ) u_draw_card1 (
        .clk,
        .rst,

        .vga_card_in(wire_card[0]),
        .vga_card_out(wire_card[1]),
        .pixel_addr (address_wire[1]),
        .rgb_pixel(rgb_wire[1]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card1(
        .clk,
        .addrA(address_wire[1]),
        .dout(rgb_wire[1])
    );

    draw_card #(
        .CARD_XPOS(497),
        .CARD_YPOS(550),
        .MODULE_NUMBER(2),
        .KIND_OF_CARDS(0)
    ) u_draw_card2 (
        .clk,
        .rst,

        .vga_card_in(wire_card[1]),
        .vga_card_out(wire_card[2]),
        .pixel_addr (address_wire[2]),
        .rgb_pixel(rgb_wire[2]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card2(
        .clk,
        .addrA(address_wire[2]),
        .dout(rgb_wire[2])

    );

    draw_card #(
        .CARD_XPOS(527),
        .CARD_YPOS(550),
        .MODULE_NUMBER(3),
        .KIND_OF_CARDS(0)
    ) u_draw_card3 (
        .clk,
        .rst,

        .vga_card_in(wire_card[2]),
        .vga_card_out(wire_card[3]),
        .pixel_addr (address_wire[3]),
        .rgb_pixel(rgb_wire[3]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card3(
        .clk,
        .addrA(address_wire[3]),
        .dout(rgb_wire[3])
    );

    draw_card #(
        .CARD_XPOS(557),
        .CARD_YPOS(550),
        .MODULE_NUMBER(4),
        .KIND_OF_CARDS(0)
    ) u_draw_card4 (
        .clk,
        .rst,

        .vga_card_in(wire_card[3]),
        .vga_card_out(wire_card[4]),
        .pixel_addr (address_wire[4]),
        .rgb_pixel(rgb_wire[4]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card4(
        .clk,
        .addrA(address_wire[4]),
        .dout(rgb_wire[4])
    );

    draw_card #(
        .CARD_XPOS(587),
        .CARD_YPOS(550),
        .MODULE_NUMBER(5),
        .KIND_OF_CARDS(0)
    ) u_draw_card5 (
        .clk,
        .rst,

        .vga_card_in(wire_card[4]),
        .vga_card_out(wire_card[5]),
        .pixel_addr (address_wire[5]),
        .rgb_pixel(rgb_wire[5]),

        .SM_in(SM_in)

    );

    image_rom_card  u_image_rom_card5(
        .clk,
        .addrA(address_wire[5]),
        .dout(rgb_wire[5])
    );

    draw_card #(
        .CARD_XPOS(617),
        .CARD_YPOS(550),
        .MODULE_NUMBER(6),
        .KIND_OF_CARDS(0)
    ) u_draw_card6 (
        .clk,
        .rst,

        .vga_card_in(wire_card[5]),
        .vga_card_out(wire_card[6]),
        .pixel_addr (address_wire[6]),
        .rgb_pixel(rgb_wire[6]),

        .SM_in(SM_in)

    );

    image_rom_card  u_image_rom_card6(
        .clk,
        .addrA(address_wire[6]),
        .dout(rgb_wire[6])

    );

    draw_card #(
        .CARD_XPOS(647),
        .CARD_YPOS(550),
        .MODULE_NUMBER(7),
        .KIND_OF_CARDS(0)
    ) u_draw_card7 (
        .clk,
        .rst,

        .vga_card_in(wire_card[6]),
        .vga_card_out(wire_card[7]),
        .pixel_addr (address_wire[7]),
        .rgb_pixel(rgb_wire[7]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card7(
        .clk,
        .addrA(address_wire[7]),
        .dout(rgb_wire[7])

    );

    draw_card #(
        .CARD_XPOS(677),
        .CARD_YPOS(550),
        .MODULE_NUMBER(8),
        .KIND_OF_CARDS(0)
    ) u_draw_card8 (
        .clk,
        .rst,

        .vga_card_in(wire_card[7]),
        .vga_card_out(wire_card[8]),
        .pixel_addr (address_wire[8]),
        .rgb_pixel(rgb_wire[8]),

        .SM_in(SM_in)

    );

    image_rom_card  u_image_rom_card8(
        .clk,
        .addrA(address_wire[8]),
        .dout(rgb_wire[8])

    );

    draw_card #(
        .CARD_XPOS(437),
        .CARD_YPOS(150),
        .MODULE_NUMBER(0),
        .KIND_OF_CARDS(1)
    ) u_draw_card9 (
        .clk,
        .rst,

        .vga_card_in(wire_card[8]),
        .vga_card_out(wire_card[9]),
        .pixel_addr (address_wire[9]),
        .rgb_pixel(rgb_wire[9]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card9(
        .clk,
        .addrA(address_wire[9]),
        .dout(rgb_wire[9])

    );

    draw_card #(
        .CARD_XPOS(467),
        .CARD_YPOS(150),
        .MODULE_NUMBER(1),
        .KIND_OF_CARDS(1)
    ) u_draw_card10 (
        .clk,
        .rst,

        .vga_card_in(wire_card[9]),
        .vga_card_out(wire_card[10]),
        .pixel_addr (address_wire[10]),
        .rgb_pixel(rgb_wire[10]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card10(
        .clk,
        .addrA(address_wire[10]),
        .dout(rgb_wire[10])
    );

    draw_card #(
        .CARD_XPOS(497),
        .CARD_YPOS(150),
        .MODULE_NUMBER(2),
        .KIND_OF_CARDS(1)
    ) u_draw_card11 (
        .clk,
        .rst,

        .vga_card_in(wire_card[10]),
        .vga_card_out(wire_card[11]),
        .pixel_addr (address_wire[11]),
        .rgb_pixel(rgb_wire[11]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card11(
        .clk,
        .addrA(address_wire[11]),
        .dout(rgb_wire[11])
    );


    draw_card #(
        .CARD_XPOS(527),
        .CARD_YPOS(150),
        .MODULE_NUMBER(3),
        .KIND_OF_CARDS(1)
    ) u_draw_card12 (
        .clk,
        .rst,

        .vga_card_in(wire_card[11]),
        .vga_card_out(wire_card[12]),
        .pixel_addr (address_wire[12]),
        .rgb_pixel(rgb_wire[12]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card12(
        .clk,
        .addrA(address_wire[12]),
        .dout(rgb_wire[12])
    );

    draw_card #(
        .CARD_XPOS(557),
        .CARD_YPOS(150),
        .MODULE_NUMBER(4),
        .KIND_OF_CARDS(1)
    ) u_draw_card13 (
        .clk,
        .rst,

        .vga_card_in(wire_card[12]),
        .vga_card_out(wire_card[13]),
        .pixel_addr (address_wire[13]),
        .rgb_pixel(rgb_wire[13]),

        .SM_in(SM_in)

    );

    image_rom_card  u_image_rom_card13(
        .clk,
        .addrA(address_wire[13]),
        .dout(rgb_wire[13])
    );

    draw_card #(
        .CARD_XPOS(587),
        .CARD_YPOS(150),
        .MODULE_NUMBER(5),
        .KIND_OF_CARDS(1)
    ) u_draw_card14 (
        .clk,
        .rst,

        .vga_card_in(wire_card[13]),
        .vga_card_out(wire_card[14]),
        .pixel_addr (address_wire[14]),
        .rgb_pixel(rgb_wire[14]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card14(
        .clk,
        .addrA(address_wire[14]),
        .dout(rgb_wire[14])

    );

    draw_card #(
        .CARD_XPOS(617),
        .CARD_YPOS(150),
        .MODULE_NUMBER(6),
        .KIND_OF_CARDS(1)
    ) u_draw_card15 (
        .clk,
        .rst,

        .vga_card_in(wire_card[14]),
        .vga_card_out(wire_card[15]),
        .pixel_addr (address_wire[15]),
        .rgb_pixel(rgb_wire[15]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card15(
        .clk,
        .addrA(address_wire[15]),
        .dout(rgb_wire[15])

    );

    draw_card #(
        .CARD_XPOS(647),
        .CARD_YPOS(150),
        .MODULE_NUMBER(7),
        .KIND_OF_CARDS(1)
    ) u_draw_card16 (
        .clk,
        .rst,

        .vga_card_in(wire_card[15]),
        .vga_card_out(wire_card[16]),
        .pixel_addr (address_wire[16]),
        .rgb_pixel(rgb_wire[16]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card16(
        .clk,
        .addrA(address_wire[16]),
        .dout(rgb_wire[16])

    );

    draw_card #(
        .CARD_XPOS(677),
        .CARD_YPOS(150),
        .MODULE_NUMBER(8),
        .KIND_OF_CARDS(1)
    ) u_draw_card17 (
        .clk,
        .rst,

        .vga_card_in(wire_card[16]),
        .vga_card_out(card_out),
        .pixel_addr (address_wire[17]),
        .rgb_pixel(rgb_wire[17]),

        .SM_in(SM_in)

    );

    image_rom_card u_image_rom_card17(
        .clk,
        .addrA(address_wire[17]),
        .dout(rgb_wire[17])

    );







endmodule