//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_card
 Author:        Konrad Sawina
 */
//////////////////////////////////////////////////////////////////////////////


 `timescale 1 ns / 1 ps

 module card 
     #( parameter
    CARD_XPOS = 20,
    CARD_YPOS = 30
    ) (
     input  logic clk,
     input  logic rst,
     input  logic [1:0] card_symbol,
     input  logic [3:0] card_number,
 
     vga_if.out card_out,
     vga_if.in card_in
 );
 
 vga_if wire_card();

 import vga_pkg::*;
 
 wire [11:0] rgb_wire;
 wire [12:0] address_wire;
 
logic [11:0] rgb_nxt;
 
draw_card #(
    .CARD_XPOS(CARD_XPOS),
    .CARD_YPOS(CARD_YPOS)      
)
u_draw_card(
    .clk,
    .rst,
   
    .vga_card_in(card_in),
    .vga_card_out(wire_card),

    .pixel_addr (address_wire),
    .rgb_pixel(rgb_wire),
    .card_number(card_number),
    .card_symbol(card_symbol)
);


image_rom_card  u_image_rom_card(
    .clk,
    .card_symbol(card_symbol),
    .addrA(address_wire),
    .dout(rgb_wire)

);

 
 always_ff @(posedge clk) begin : bg_ff_blk
     if (rst) begin
        card_out.vcount <=  '0;
        card_out.vsync  <=  '0;
        card_out.vblnk  <=  '0;
        card_out.hcount <=  '0;
        card_out.hsync  <=  '0;
        card_out.hblnk  <=  '0;
        card_out.rgb    <=  '0;
     end else begin
        card_out.vcount <=  wire_card.vcount;
        card_out.vsync  <=  wire_card.vsync;
        card_out.vblnk  <=  wire_card.vblnk;
        card_out.hcount <=  wire_card.hcount;
        card_out.hsync  <=  wire_card.hsync;
        card_out.hblnk  <=  wire_card.hblnk;
        card_out.rgb    <= rgb_nxt;
     end
 end
 
 always_comb begin : bg_comb_blk
    rgb_nxt = wire_card.rgb;   
 end
 
 endmodule