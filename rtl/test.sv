//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   template_fsm
 Author:        Robert Szczygiel
 Version:       1.0
 Last modified: 2023-05-18
 Coding style: safe with FPGA sync reset
 Description:  Template for modified Moore FSM for UEC2 project
 */
//////////////////////////////////////////////////////////////////////////////
 module test
    (
        input  wire  clk,  // posedge active clock
        input  wire  rst,  // high-level active synchronous reset
        input  wire  left_mouse,
        input  wire  right_mouse,

        vga_if.in vga_blackjack_in,
        vga_if.out vga_blackjack_out
    );
    
    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
   


  


    vga_if wire_cd [14:0] ();

   

   





    
   

    
    //------------------------------------------------------------------------------
    // state sequential with synchronous reset
    //------------------------------------------------------------------------------

    //------------------------------------------------------------------------------
    // next state logic
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // output register
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : out_reg_blk
        if(rst) begin : out_reg_rst_blk
            vga_blackjack_out.vcount   <= '0;
            vga_blackjack_out.vsync    <= '0;
            vga_blackjack_out.vblnk    <= '0;
            vga_blackjack_out.hcount   <= '0;
            vga_blackjack_out.hsync    <= '0;
            vga_blackjack_out.hblnk    <= '0;
            vga_blackjack_out.rgb      <= '0;
        end else begin
            vga_blackjack_out.vcount <=  vga_blackjack_in.vcount;
            vga_blackjack_out.vsync  <=  vga_blackjack_in.vsync;
            vga_blackjack_out.vblnk  <=  vga_blackjack_in.vblnk;
            vga_blackjack_out.hcount <=  vga_blackjack_in.hcount;
            vga_blackjack_out.hsync  <=  vga_blackjack_in.hsync;
            vga_blackjack_out.hblnk  <=  vga_blackjack_in.hblnk;
            vga_blackjack_out.rgb    <=  wire_cd[14].rgb;
        end
    end

    // card #(
    //         .CARD_XPOS(150), // Ustaw pozycję x dla każdej karty
    //         .CARD_YPOS(50)
    //     ) u_card1 (
    //         .clk(clk),
    //         .rst(rst),
    
    //         .card_number(1),
    //         .card_symbol(0),
    //         .card_in(vga_blackjack_in),
    //         .card_out(wire_cd[1])
    //     );




    for (genvar i = 0; i <= 14; i++) begin : player_cards
        if (i == 0) begin
        card #(
            .CARD_XPOS(150 + 30*i), // Ustaw pozycję x dla każdej karty
            .CARD_YPOS(50)
        ) u_card1 (
            .clk(clk),
            .rst(rst),
    
            .card_number(i - 1),
            .card_symbol(i % 4),
            .vga_card_in(vga_blackjack_in),
            .vga_card_out(wire_cd[i])
        );
        end else if (i >= 1 && i <= 14) begin
            card #(
                .CARD_XPOS(150 + 30*i), // Ustaw pozycję x dla każdej karty
                .CARD_YPOS(50)
            ) u_card1 (
                .clk(clk),
                .rst(rst),
        
                .card_number(i - 1),
                .card_symbol(i % 4),
                .vga_card_in(wire_cd[i-1]),
                .vga_card_out(wire_cd[i])
            );
        end
    end
   

    
    endmodule