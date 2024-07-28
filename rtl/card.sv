
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_card
 Author:        Konrad Sawina
 */
//////////////////////////////////////////////////////////////////////////////
 module card
    #( parameter
        CARD_XPOS = 20,
        CARD_YPOS = 30
    )
    (
        input  wire  clk,  // posedge active clock
        input  wire  rst,  // high-level active synchronous reset
        input  wire  [11:0] rgb_pixel,
        input  logic [3:0] card_number,
        input  logic [1:0] card_symbol,

        vga_if.out vga_card_out,
        vga_if.in vga_card_in,

        output logic [12:0] pixel_addr
    );

    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    localparam CARD_HEIGHT = 80;
    localparam CARD_WIDTH = 56;

    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------
    logic [11:0] rgb_nxt;
    logic [11:0] color;
    logic [12:0] pixel_addr_nxt;

    wire [11:0] delayed_rgb;

    vga_if wire_cd();

    // delay #(
    //     .WIDTH(12),
    //     .CLK_DEL(2)
    // )
    // u_rgb_delay(
    //     .din(vga_card_in.rgb),
    //     .clk,
    //     .rst,
    //     .dout(delayed_rgb)
    // );


    // delay #(
    //     .WIDTH(26),
    //     .CLK_DEL(2)
    // )
    // u_char_delay(
    //     .din({vga_card_in.hcount, vga_card_in.vcount, vga_card_in.hsync, vga_card_in.vsync, vga_card_in.hblnk, vga_card_in.vblnk}),
    //     .clk,
    //     .rst,
    //     .dout({wire_cd.hcount, wire_cd.vcount, wire_cd.hblnk, wire_cd.hsync, wire_cd.vblnk, wire_cd.vsync})
    // );



    //------------------------------------------------------------------------------
    // output register with sync reset
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : out_reg_blk
        if(rst) begin : out_reg_rst_blk
            vga_card_out.vcount <= '0;
            vga_card_out.vsync  <= '0;
            vga_card_out.vblnk  <= '0;
            vga_card_out.hcount <= '0;
            vga_card_out.hsync  <= '0;
            vga_card_out.hblnk  <= '0;
            vga_card_out.rgb    <= '0;
            pixel_addr          <= '0;
        end
        else begin : out_reg_run_blk
            vga_card_out.vcount <= vga_card_in.vcount;
            vga_card_out.vsync  <= vga_card_in.vsync;
            vga_card_out.vblnk  <= vga_card_in.vblnk;
            vga_card_out.hcount <= vga_card_in.hcount;
            vga_card_out.hsync  <= vga_card_in.hsync;
            vga_card_out.hblnk  <= vga_card_in.hblnk;
            vga_card_out.rgb    <= rgb_nxt;
            pixel_addr          <= pixel_addr_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // logic
    //------------------------------------------------------------------------------
    // always_comb begin : card_comb_blk
    //     if (card_number == 0) begin
    //         rgb_nxt = delayed_rgb;
    //     end else if (vga_card_in.hcount - 1 >= CARD_XPOS  && vga_card_in.hcount - 1 <= CARD_XPOS+CARD_WIDTH && vga_card_in.vcount >= CARD_YPOS && vga_card_in.vcount + 1 <= CARD_YPOS+CARD_HEIGHT) begin
    //         rgb_nxt = rgb_pixel;
    //         pixel_addr_nxt = (vga_card_in.vcount - CARD_YPOS )*CARD_WIDTH + vga_card_in.hcount - CARD_XPOS;
    //     end
    //     else begin
    //         pixel_addr_nxt = 0;
    //         rgb_nxt = delayed_rgb;
    //     end
    // end

    always_comb begin : card_comb_blk
        case(card_symbol) 
            0: color = 12'h0_0_0;
            1: color = 12'h0_0_0;
            2: color = 12'hf_0_0;
            3: color = 12'hf_0_0;
            default: color = 12'hF_F_F;
        endcase
        if (vga_card_in.vcount >= CARD_YPOS && vga_card_in.vcount <= CARD_YPOS + CARD_HEIGHT && 
            vga_card_in.hcount >= CARD_XPOS && vga_card_in.hcount <= CARD_XPOS + CARD_WIDTH) begin
            
            rgb_nxt = 12'hF_F_F; // Domyślnie kolor biały wewnątrz prostokąta
            
            // Warunek na czarną obwódkę
            if ((vga_card_in.vcount == CARD_YPOS || vga_card_in.vcount == CARD_YPOS + CARD_HEIGHT ||
                 vga_card_in.hcount == CARD_XPOS || vga_card_in.hcount == CARD_XPOS + CARD_WIDTH)) begin
                // Kolor czarny
                rgb_nxt = 12'h0_0_0;
                 end case (card_number)
                 1: begin
                    if (
                        // Warunki na rysowanie litery "A"
                        (vga_card_in.hcount == CARD_XPOS + 5 && vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13) ||
                        (vga_card_in.hcount == CARD_XPOS + 11 && vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13) ||
                        (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                        (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) 
                    ) 
                        // Kolor czarny dla litery "A"
                        rgb_nxt = color;
                end
                2: begin
                    if (
                            // Warunki na rysowanie cyfry "2"
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 9) ||
                            (vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 9 && vga_card_in.hcount == CARD_XPOS + 9) ||
                            (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 5) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 9) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount == CARD_XPOS + 9) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 9)
                        )
                            // Kolor czarny dla "2"
                        rgb_nxt = color;
                end
                3: begin
                    if (
                    (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                    (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                    (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||          
                    (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 8 && vga_card_in.hcount == CARD_XPOS + 10) ||
                    (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 10) 
           
                    ) 
                    rgb_nxt = color;
                end
                4: begin
                    if (
                        // Warunki na rysowanie cyfry "4"
                        (vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 8 && vga_card_in.hcount == CARD_XPOS + 6) ||
                        (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 6 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                        (vga_card_in.vcount >= CARD_YPOS + 9 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 10)
                        ) 
                        // Kolor czarny dla "4"
                        rgb_nxt = color;
                end
                5: begin
                    if (
                            // Warunki na rysowanie cyfry "5"
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 8 && vga_card_in.hcount == CARD_XPOS + 5) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.vcount >= CARD_YPOS + 9 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 10) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) 
                        ) 
                            // Kolor czarny dla "5"
                            rgb_nxt = color;
                end
                6: begin
                    if (
                            // Warunki na rysowanie cyfry "6"
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 5) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 10) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 6 && vga_card_in.hcount <= CARD_XPOS + 10) 
                        ) 
                            // Kolor czarny dla "6"
                            rgb_nxt = color;
                end
                7: begin 
                    if (
                        // Warunki na rysowanie cyfry "7"
                        (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 12) ||
                        (((vga_card_in.vcount - CARD_YPOS) == (CARD_XPOS + 18 - vga_card_in.hcount)) && 
                        (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 12)) ||
                        ((vga_card_in.vcount - CARD_YPOS) == (CARD_XPOS + 17 - vga_card_in.hcount)) && 
                        (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 12)
                        ) 
                        // Kolor czarny dla "7"
                            rgb_nxt = color;
                end
                8: begin
                    if (
                            // Warunki na rysowanie cyfry "8"
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 8)) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 8)) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 12)) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 12))
                        ) 
                            // Kolor czarny dla "8"
                            rgb_nxt = color;
                end
                9:  begin 
                    if (
                            // Warunki na rysowanie cyfry "9"
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 9)) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 6 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10)
                        )
                            // Kolor czarny dla "9"
                            rgb_nxt = color;    
                end
                10: begin
                    if (
                            // Warunki na rysowanie cyfry "1"
                            (vga_card_in.hcount == CARD_XPOS + 5 &&  vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13) |
                            (vga_card_in.hcount == CARD_XPOS + 4 &&  vga_card_in.vcount == CARD_YPOS + 5) ||
                            (vga_card_in.hcount == CARD_XPOS + 3 &&  vga_card_in.vcount == CARD_YPOS + 6) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 4 && vga_card_in.hcount <= CARD_XPOS + 6)
                        ) 
                            // Kolor czarny dla "1"
                            rgb_nxt = color;
                         else if (
                            // Warunki na rysowanie cyfry "0"
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 10 && vga_card_in.hcount <= CARD_XPOS + 16) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 10 && vga_card_in.hcount <= CARD_XPOS + 16) ||
                            (vga_card_in.hcount == CARD_XPOS + 10 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.hcount == CARD_XPOS + 16 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13))
                        ) 
                            // Kolor czarny dla "0"
                            rgb_nxt = color;
                end
                11: begin 
                    if (
                            // Warunki na rysowanie litery "J"
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.hcount == CARD_XPOS + 10 && (vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 12)) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && vga_card_in.vcount >= CARD_YPOS + 12 && vga_card_in.vcount <= CARD_YPOS + 13)
                        ) 
                            // Kolor czarny dla litery "J"
                            rgb_nxt = color;
                end
                12: begin 
                    if (
                            // Warunki na rysowanie cyfry "0"
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.hcount == CARD_XPOS + 12 && vga_card_in.vcount == CARD_YPOS + 13)
                        ) 
                            // Kolor czarny dla "0"
                            rgb_nxt = color;
                end
                13: begin
                    if (
                            // Warunki na rysowanie litery "K"
                            // Pionowa linia dla "K"
                            (vga_card_in.hcount == CARD_XPOS + 5 && vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13) ||
                            // Górna przekątna linia dla "K"
                            (vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10 &&
                             vga_card_in.vcount == CARD_YPOS + 4 + (CARD_XPOS + 11 - vga_card_in.hcount)) || 
                             (vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10 &&
                             vga_card_in.vcount == CARD_YPOS + 4 - (CARD_XPOS + 1 - vga_card_in.hcount))
                            
                        ) 
                            // Kolor czarny dla litery "K"
                            rgb_nxt = color;
                end
                default: 
                     rgb_nxt = vga_card_in.rgb ;

                endcase
            end else begin
            rgb_nxt = vga_card_in.rgb;
        end
    end

endmodule