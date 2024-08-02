
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_card
 Author:        Konrad Sawina 
 */
//////////////////////////////////////////////////////////////////////////////
 module draw_card
    #( parameter
        CARD_XPOS = 20,
        CARD_YPOS = 30,
        MODULE_NUMBER = 0
    )
    (
        input  wire  clk,  // posedge active clock
        input  wire  rst,  // high-level active synchronous reset
        input  wire  [11:0] rgb_pixel,
     
        SM_if.in SM_in,

        vga_if.out vga_card_out,
        vga_if.in vga_card_in,

        output logic [10:0] pixel_addr
    );

    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    localparam CARD_HEIGHT = 80;
    localparam CARD_WIDTH = 56;
    localparam CARD_TYPE_HEIGHT = 40;
    localparam CARD_TYPE_WIDTH = 40;

    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------
    logic [11:0] rgb_nxt;
    logic [11:0] color;
    logic [10:0] pixel_addr_nxt;

    wire [11:0] delayed_rgb;

    vga_if wire_cd();

    delay #(
        .WIDTH(12),
        .CLK_DEL(2)
    )
    u_rgb_delay(
        .din(vga_card_in.rgb),
        .clk,
        .rst,
        .dout(delayed_rgb)
    );


    delay #(
        .WIDTH(26),
        .CLK_DEL(2)
    )
    u_char_delay(
        .din({vga_card_in.hcount, vga_card_in.vcount, vga_card_in.hsync, vga_card_in.vsync, vga_card_in.hblnk, vga_card_in.vblnk}),
        .clk,
        .rst,
        .dout({wire_cd.hcount, wire_cd.vcount, wire_cd.hsync, wire_cd.vsync, wire_cd.hblnk, wire_cd.vblnk})
    );



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
            vga_card_out.vcount <= wire_cd.vcount;
            vga_card_out.vsync  <= wire_cd.vsync;
            vga_card_out.vblnk  <= wire_cd.vblnk;
            vga_card_out.hcount <= wire_cd.hcount;
            vga_card_out.hsync  <= wire_cd.hsync;
            vga_card_out.hblnk  <= wire_cd.hblnk;
            vga_card_out.rgb    <= rgb_nxt;
            pixel_addr          <= pixel_addr_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // logic
    //------------------------------------------------------------------------------


    always_comb begin : card_comb_blk2
        case(SM_in.player_card_symbols[MODULE_NUMBER]) 
            2'b00: color = 12'h0_0_0;
            2'b01: color = 12'h0_0_0;
            2'b10: color = 12'hf_0_0;
            2'b11: color = 12'hf_0_0;
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
                 end case (SM_in.player_card_values[MODULE_NUMBER])
                 4'b0000: begin
                    rgb_nxt = delayed_rgb;
                 end
                 4'b0001: begin
                    if (
                        (vga_card_in.hcount == CARD_XPOS + 5 && vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13) ||
                        (vga_card_in.hcount == CARD_XPOS + 11 && vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13) ||
                        (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                        (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) 
                    ) 
                        rgb_nxt = color;
                end
                4'b0010: begin
                    if (
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 9) ||
                            (vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 9 && vga_card_in.hcount == CARD_XPOS + 9) ||
                            (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 5) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 9) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount == CARD_XPOS + 9) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 9)
                        )
                        rgb_nxt = color;
                end
                4'b0011: begin
                    if (
                    (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                    (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                    (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||          
                    (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 8 && vga_card_in.hcount == CARD_XPOS + 10) ||
                    (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 10) 
           
                    ) 
                    rgb_nxt = color;
                end
                4'b0100: begin
                    if (
                        (vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 8 && vga_card_in.hcount == CARD_XPOS + 6) ||
                        (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 6 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                        (vga_card_in.vcount >= CARD_YPOS + 9 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 10)
                        ) 
                        rgb_nxt = color;
                end
                4'b0101: begin
                    if (
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 8 && vga_card_in.hcount == CARD_XPOS + 5) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.vcount >= CARD_YPOS + 9 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 10) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) 
                        ) 
                            rgb_nxt = color;
                end
                4'b0110: begin
                    if (
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 5) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 13 && vga_card_in.hcount == CARD_XPOS + 10) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 6 && vga_card_in.hcount <= CARD_XPOS + 10) 
                        ) 
                            rgb_nxt = color;
                end
                4'b0111: begin 
                    if (
                        (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 12) ||
                        (((vga_card_in.vcount - CARD_YPOS) == (CARD_XPOS + 18 - vga_card_in.hcount)) && 
                        (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 12)) ||
                        ((vga_card_in.vcount - CARD_YPOS) == (CARD_XPOS + 17 - vga_card_in.hcount)) && 
                        (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 12)
                        ) 
                            rgb_nxt = color;
                end
                4'b1000: begin
                    if (
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 8)) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 8)) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 12)) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 12))
                        ) 
                            rgb_nxt = color;
                end
                4'b1001:  begin 
                    if (
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 9)) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.vcount == CARD_YPOS + 9 && vga_card_in.hcount >= CARD_XPOS + 6 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 10 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10)
                        )
                            rgb_nxt = color;    
                end
                4'b1010: begin
                    if (
                            (vga_card_in.hcount == CARD_XPOS + 5 &&  vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13) |
                            (vga_card_in.hcount == CARD_XPOS + 4 &&  vga_card_in.vcount == CARD_YPOS + 5) ||
                            (vga_card_in.hcount == CARD_XPOS + 3 &&  vga_card_in.vcount == CARD_YPOS + 6) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 4 && vga_card_in.hcount <= CARD_XPOS + 6)
                        ) 
                            rgb_nxt = color;
                         else if (
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 10 && vga_card_in.hcount <= CARD_XPOS + 16) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 10 && vga_card_in.hcount <= CARD_XPOS + 16) ||
                            (vga_card_in.hcount == CARD_XPOS + 10 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.hcount == CARD_XPOS + 16 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13))
                        ) 
                            rgb_nxt = color;
                end
                4'b1011: begin 
                    if (
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.hcount == CARD_XPOS + 10 && (vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 12)) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && vga_card_in.vcount >= CARD_YPOS + 12 && vga_card_in.vcount <= CARD_YPOS + 13)
                        ) 
                            rgb_nxt = color;
                end
                4'b1100: begin 
                    if (
                            (vga_card_in.vcount == CARD_YPOS + 5 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.vcount == CARD_YPOS + 13 && vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 11) ||
                            (vga_card_in.hcount == CARD_XPOS + 5 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.hcount == CARD_XPOS + 11 && (vga_card_in.vcount >= CARD_YPOS + 6 && vga_card_in.vcount <= CARD_YPOS + 13)) ||
                            (vga_card_in.hcount == CARD_XPOS + 12 && vga_card_in.vcount == CARD_YPOS + 13)
                        ) 
                            rgb_nxt = color;
                end
                4'b1101: begin
                    if (
                            (vga_card_in.hcount == CARD_XPOS + 5 && vga_card_in.vcount >= CARD_YPOS + 5 && vga_card_in.vcount <= CARD_YPOS + 13) ||
                            (vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10 &&
                             vga_card_in.vcount == CARD_YPOS + 4 + (CARD_XPOS + 11 - vga_card_in.hcount)) || 
                             (vga_card_in.hcount >= CARD_XPOS + 5 && vga_card_in.hcount <= CARD_XPOS + 10 &&
                             vga_card_in.vcount == CARD_YPOS + 4 - (CARD_XPOS + 1 - vga_card_in.hcount))
                            
                        ) 
                            rgb_nxt = color;
                end
                default: 
                     rgb_nxt = delayed_rgb ;

                endcase
            end else begin
            rgb_nxt = delayed_rgb;
        end
        if ((vga_card_in.hcount - 1 >= (CARD_XPOS + 7)  && vga_card_in.hcount - 1 <= (CARD_XPOS + 7)+CARD_TYPE_WIDTH && vga_card_in.vcount >= (CARD_YPOS + 20) && vga_card_in.vcount + 1 <= (CARD_YPOS + 20)+CARD_TYPE_HEIGHT) && (SM_in.player_card_values[MODULE_NUMBER] != 0)) begin
            rgb_nxt = rgb_pixel;
            pixel_addr_nxt = (vga_card_in.vcount - (CARD_YPOS + 20) )*CARD_TYPE_WIDTH + vga_card_in.hcount - (CARD_XPOS + 7);
        end
        else begin
            pixel_addr_nxt = 0;
        end
    end
    

endmodule