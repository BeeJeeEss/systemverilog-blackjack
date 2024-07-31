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
module blackjack_FSM
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
    localparam STATE_BITS = 3; // number of bits used for state register

    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------

    enum logic [STATE_BITS-1 :0] {
        IDLE = 3'b000, // idle state
        DEAL_CARDS = 3'b001,
        PLAYER_TURN = 3'b011,
        DEALER_TURN = 3'b010,
        CHECK_WINNER = 3'b110
    } state, state_nxt;

    logic [3:0] player_card_values [8:0]; // Zakładamy, że gracz może mieć maksymalnie 9 kart
    logic [1:0] player_card_symbols [8:0];
    logic [3:0] player_card_values_nxt [8:0]; // Zakładamy, że gracz może mieć maksymalnie 9 kart
    logic [1:0] player_card_symbols_nxt [8:0];
    logic [3:0] dealer_card_values [8:0]; // Zakładamy, że gracz może mieć maksymalnie 9 kart
    logic [1:0] dealer_card_symbols [8:0];
    logic [3:0] player_card_count; // Liczba kart gracza
    logic [3:0] dealer_card_count;
    logic [4:0] player_card_value;
    logic [4:0] dealer_card_value;
    logic [6:0] player_score; // Wartość punktowa kart gracza
    logic [6:0] dealer_score; // Wartość punktowa kart dealera
    logic card_chosen;



    vga_if wire_cd [0:9] ();



    //------------------------------------------------------------------------------
    // state sequential with synchronous reset
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : state_seq_blk
        if(vga_blackjack_in.hcount == 0 & vga_blackjack_in.vcount == 0) begin
            if(rst)begin : state_seq_rst_blk
                for (int i = 0; i <= 8; i++) begin
                    player_card_values[i] <= 0;
                    player_card_symbols[i] <= 0;
                end
                state <= IDLE;
            end
        end
        else begin : state_seq_run_blk
            for (int i = 0; i <= 8; i++) begin
                player_card_values[i] <= player_card_values_nxt[i];
                player_card_symbols[i] <= player_card_symbols_nxt[i];
            end
            state <= state_nxt;
        end
    end

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
            vga_blackjack_out.rgb    <=  wire_cd[8].rgb;
        end
    end


    always_comb begin
        case (state)
            IDLE: begin
                for (int i = 0; i <= 8; i++) begin
                    player_card_values_nxt[i] = 0;
                end
                state_nxt = left_mouse ? DEAL_CARDS : IDLE;
            end
            DEAL_CARDS: begin
                // Rozdanie kart graczowi i dealerowi
                player_card_count = 2; // Gracz zaczyna z 2 kartami
                player_card_values_nxt[0] = 5;
                player_card_symbols_nxt[0] = 3;
                player_card_values_nxt[1] = 1;
                player_card_symbols_nxt[1] = 0;

                state_nxt = right_mouse ? PLAYER_TURN : DEAL_CARDS;
            end
            PLAYER_TURN: begin
                if(left_mouse == 1) begin
                    player_card_values_nxt[player_card_count] = player_card_count;
                    player_card_symbols_nxt[player_card_count] = 2;
                    player_card_count ++;
                end
                state_nxt = right_mouse ? DEALER_TURN : PLAYER_TURN;

            end
            DEALER_TURN: begin
                // Tura dealera
                if (dealer_card_count < 10) begin
                    dealer_card_values[dealer_card_count] = 5;
                    dealer_card_symbols[dealer_card_count] = 3;
                    dealer_card_count++;
                end
                state_nxt = left_mouse ? CHECK_WINNER : DEALER_TURN;
            end
            CHECK_WINNER: begin
                // Sprawdzenie, kto wygrał
                state_nxt = left_mouse ? IDLE : CHECK_WINNER;
            end
        endcase
    end




    for (genvar i = 0; i <= 8; i++) begin : player_cards
        if (i == 0) begin
            card #(
                .CARD_XPOS(150 + 30*i), // Ustaw pozycję x dla każdej karty
                .CARD_YPOS(50)
            ) u_card1 (
                .clk(clk),
                .rst(rst),

                .card_number(player_card_values[i]),
                .card_symbol(player_card_symbols[i]),
                .card_in(vga_blackjack_in),
                .card_out(wire_cd[i])
            );
        end else if (i >= 1 && i <= 8) begin
            card #(
                .CARD_XPOS(150 + 30*i), // Ustaw pozycję x dla każdej karty
                .CARD_YPOS(50)
            ) u_card1 (
                .clk(clk),
                .rst(rst),

                .card_number(player_card_values[i]),
                .card_symbol(player_card_symbols[i]),
                .card_in(wire_cd[i-1]),
                .card_out(wire_cd[i])
            );
        end
    end



endmodule
