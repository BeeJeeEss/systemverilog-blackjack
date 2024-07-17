
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_card
 Author:        Konrad Sawina
 */
//////////////////////////////////////////////////////////////////////////////
module draw_card
    #( parameter
    CARD_XPOS = 20,
    CARD_YPOS = 30
    )   
    (
        input  wire  clk,  // posedge active clock
        input  wire  rst,  // high-level active synchronous reset
        input  wire  [11:0] rgb_pixel,
        
        vga_if.out vga_card_out,
        vga_if.in vga_card_in,

        output logic [12:0] pixel_addr
    );

    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    localparam CARD_HEIGHT = 79;
    localparam CARD_WIDTH = 55;

    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------
    logic [11:0] rgb_nxt;
    logic [12:0] pixel_addr_nxt;
    
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
        .dout({wire_cd.hcount, wire_cd.vcount, wire_cd.hblnk, wire_cd.hsync, wire_cd.vblnk, wire_cd.vsync})
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
    always_comb begin : card_comb_blk
            if (vga_card_in.hcount - 1 >= CARD_XPOS  && vga_card_in.hcount - 1 <= CARD_XPOS+CARD_WIDTH && vga_card_in.vcount >= CARD_YPOS && vga_card_in.vcount + 1 <= CARD_YPOS+CARD_HEIGHT) begin
                rgb_nxt = rgb_pixel;
                pixel_addr_nxt = (vga_card_in.vcount - CARD_YPOS )*CARD_WIDTH + vga_card_in.hcount - CARD_XPOS;
            end
            else begin
                pixel_addr_nxt = 0;
                rgb_nxt = delayed_rgb;
            end

    end

endmodule
