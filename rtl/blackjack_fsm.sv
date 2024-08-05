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
        input  wire  [5:0] total_value,

        input  wire  deal,
        input  wire  hit,
        input  wire  stand,

        output logic [2:0] state_btn,
        vga_if.in vga_blackjack_in,
        SM_if.out SM_out
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
        CHECK_WINNER = 3'b110,
        PLAYER_CARD_CHOOSE = 3'b100,
        DEALER_CARD_CHOOSE = 3'b101,
        PLAYER_SCORE_CHECK = 3'b111
    } state, state_nxt;


    logic [3:0] player_card_values_nxt [8:0]; // Zakładamy, że gracz może mieć maksymalnie 9 kart
    logic [1:0] player_card_symbols_nxt [8:0];
    // logic [3:0] dealer_card_values [8:0]; // Zakładamy, że gracz może mieć maksymalnie 9 kart
    // logic [1:0] dealer_card_symbols [8:0];
    logic [3:0] player_card_count;
    logic [3:0] player_card_count_nxt;
    logic [2:0] state_btn_nxt;
    // logic [3:0] dealer_card_count;

    logic card_chosen_finished;
    logic card_chosen_finished_nxt;
    logic deal_card_finished;
    logic deal_card_finished_nxt;
    logic lose_nxt;
    logic counter;
    logic counter_nxt;
    logic checking_finshed;
    logic checking_finshed_nxt;








    //------------------------------------------------------------------------------
    // state sequential with synchronous reset
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : state_seq_blk
        if(vga_blackjack_in.hcount == 0 & vga_blackjack_in.vcount == 0) begin
            if(rst)begin : state_seq_rst_blk
                for (int i = 0; i <= 8; i++) begin
                    SM_out.player_card_values[i] <= 0;
                    SM_out.player_card_symbols[i] <= 0;
                end
                player_card_count <= 0;
                card_chosen_finished <= 0;
                deal_card_finished <= 0;
                counter <= 0 ;
                checking_finshed <= 0;
                state_btn <= 0;
                state <= IDLE;
            end
            else begin : state_seq_run_blk
                for (int i = 0; i <= 8; i++) begin
                    SM_out.player_card_values[i] <= player_card_values_nxt[i];
                    SM_out.player_card_symbols[i] <= player_card_symbols_nxt[i];
                end
                player_card_count <= player_card_count_nxt;
                card_chosen_finished <= card_chosen_finished_nxt;
                deal_card_finished <= deal_card_finished_nxt;
                checking_finshed <= checking_finshed_nxt;
                counter <= counter_nxt;
                state_btn <= state_btn_nxt;
                state <= state_nxt;
            end
        end
    end

    //------------------------------------------------------------------------------
    // next state logic
    //------------------------------------------------------------------------------


    always_comb begin

        case(state)

            IDLE:               state_nxt = deal ? DEAL_CARDS : IDLE;
            DEAL_CARDS:         state_nxt = deal_card_finished ? PLAYER_TURN : DEAL_CARDS;
            PLAYER_TURN:        state_nxt = hit ? PLAYER_CARD_CHOOSE : (stand ? DEALER_TURN : PLAYER_TURN);
            PLAYER_CARD_CHOOSE: state_nxt = card_chosen_finished ? PLAYER_SCORE_CHECK : PLAYER_CARD_CHOOSE;
            PLAYER_SCORE_CHECK: state_nxt = checking_finshed ? (lose_nxt ? DEALER_TURN : PLAYER_TURN) : PLAYER_SCORE_CHECK;
            DEALER_TURN:        state_nxt = left_mouse ? IDLE : DEALER_TURN;
            default:            state_nxt = IDLE;

        endcase

    end

    //------------------------------------------------------------------------------
    // output register
    //----------------------------------------------------------------------------


    always_comb begin
        for (int i = 0; i <= 8; i++) begin
            player_card_values_nxt[i] = SM_out.player_card_values[i];
            player_card_symbols_nxt[i] = SM_out.player_card_symbols[i];
        end
        player_card_count_nxt = player_card_count;
        card_chosen_finished_nxt = card_chosen_finished;
        deal_card_finished_nxt = deal_card_finished;
        state_btn_nxt = state_btn;
        lose_nxt = 0;
        counter_nxt = counter;
        case (state)
            IDLE: begin
                for (int i = 0; i <= 8; i++) begin
                    player_card_values_nxt[i] = 0;
                    player_card_symbols_nxt[i] = 0;
                end

                player_card_count_nxt = 0;
                card_chosen_finished_nxt = 0;
                deal_card_finished_nxt = 0;
                state_btn_nxt = 0;
                lose_nxt = 0;
                counter_nxt = 0;
            end
            DEAL_CARDS: begin
                player_card_values_nxt[0] = 1;
                player_card_symbols_nxt[0] = 3;
                player_card_values_nxt[1] = 9;
                player_card_symbols_nxt[1] = 0;

                player_card_count_nxt = 2;
                deal_card_finished_nxt = 1;
                state_btn_nxt = 1;
            end
            PLAYER_TURN: begin
                state_btn_nxt = 1;
                if (hit == 0) begin
                    counter_nxt = 0;
                end else if (hit == 1) begin
                    counter_nxt = counter;
                end

                state_btn_nxt = 1;
            end
            PLAYER_CARD_CHOOSE : begin
                if (counter == 0) begin
                    counter_nxt = counter + 1;
                    player_card_values_nxt[player_card_count] = 1;
                    player_card_symbols_nxt[player_card_count] = 1;
                    player_card_count_nxt = player_card_count + 1;
                end

                state_btn_nxt = 1;
                card_chosen_finished_nxt = 1;
            end
            PLAYER_SCORE_CHECK: begin
                if (total_value >= 22) begin
                    lose_nxt = 1;
                end else if (total_value <= 21) begin
                    lose_nxt = 0;
                end

                state_btn_nxt = 1;
                checking_finshed_nxt = 1;
            end
            DEALER_TURN: begin
                state_btn_nxt = 2;
            end
            CHECK_WINNER: begin
            end
            default: begin
            end
        endcase
    end



endmodule