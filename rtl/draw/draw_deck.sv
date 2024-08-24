/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Konrad Sawina, Borys Strzeboński
 * Description:
 * Module responsible for drawing cards.
 */
module draw_deck (
        input  wire  clk,
        input  wire  rst,
        input  wire  [11:0] rgb_pixel,
        input  wire  [2:0] state,

        vga_if.out vga_deck_out,
        vga_if.in vga_deck_in,

        output logic [12:0] pixel_addr
    );

    localparam CARD_DECK_XPOS = 350;
    localparam CARD_DECK_YPOS = 365;
    localparam CARD_TYPE_HEIGHT = 80;
    localparam CARD_TYPE_WIDTH = 56;

    logic [11:0] rgb_nxt;
    logic [12:0] pixel_addr_nxt;
    wire [11:0] delayed_rgb;

    vga_if wire_cd();

    delay #(
        .WIDTH(12),
        .CLK_DEL(2)
    )
    u_rgb_delay(
        .din(vga_deck_in.rgb),
        .clk,
        .rst,
        .dout(delayed_rgb)
    );


    delay #(
        .WIDTH(26),
        .CLK_DEL(2)
    )
    u_char_delay(
        .din({vga_deck_in.hcount, vga_deck_in.vcount, vga_deck_in.hsync, vga_deck_in.vsync, vga_deck_in.hblnk, vga_deck_in.vblnk}),
        .clk,
        .rst,
        .dout({wire_cd.hcount, wire_cd.vcount, wire_cd.hsync, wire_cd.vsync, wire_cd.hblnk, wire_cd.vblnk})
    );

    always_ff @(posedge clk) begin : out_reg_blk
        if(rst) begin : out_reg_rst_blk
            vga_deck_out.vcount <= '0;
            vga_deck_out.vsync  <= '0;
            vga_deck_out.vblnk  <= '0;
            vga_deck_out.hcount <= '0;
            vga_deck_out.hsync  <= '0;
            vga_deck_out.hblnk  <= '0;
            vga_deck_out.rgb    <= '0;
            pixel_addr          <= '0;
        end
        else begin : out_reg_run_blk
            if (state == 0 || state == 6) begin
                vga_deck_out.vcount <= vga_deck_in.vcount;
                vga_deck_out.vsync  <= vga_deck_in.vsync;
                vga_deck_out.vblnk  <= vga_deck_in.vblnk;
                vga_deck_out.hcount <= vga_deck_in.hcount;
                vga_deck_out.hsync  <= vga_deck_in.hsync;
                vga_deck_out.hblnk  <= vga_deck_in.hblnk;
                vga_deck_out.rgb    <= vga_deck_in.rgb;
                pixel_addr          <= 0;
            end else begin
                vga_deck_out.vcount <= wire_cd.vcount;
                vga_deck_out.vsync  <= wire_cd.vsync;
                vga_deck_out.vblnk  <= wire_cd.vblnk;
                vga_deck_out.hcount <= wire_cd.hcount;
                vga_deck_out.hsync  <= wire_cd.hsync;
                vga_deck_out.hblnk  <= wire_cd.hblnk;
                vga_deck_out.rgb    <= rgb_nxt;
                pixel_addr          <= pixel_addr_nxt;
            end
        end
    end

    always_comb begin
        if (vga_deck_in.hcount - 1 >= CARD_DECK_XPOS  && vga_deck_in.hcount - 1 <= CARD_DECK_XPOS +CARD_TYPE_WIDTH && vga_deck_in.vcount >= CARD_DECK_YPOS  && vga_deck_in.vcount + 1 <= CARD_DECK_YPOS + CARD_TYPE_HEIGHT) begin
            rgb_nxt = rgb_pixel;
            pixel_addr_nxt = (vga_deck_in.vcount - CARD_DECK_YPOS)*CARD_TYPE_WIDTH + vga_deck_in.hcount - CARD_DECK_XPOS ;
        end
        else begin
            rgb_nxt = delayed_rgb;
            pixel_addr_nxt = 0;
        end
    end
endmodule