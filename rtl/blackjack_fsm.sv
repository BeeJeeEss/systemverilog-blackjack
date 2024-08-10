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
        input  wire  [4:0] total_player_value,
        input  wire  [4:0] total_dealer_value,

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
    localparam STATE_BITS = 4; // number of bits used for state register

    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------

    enum logic [STATE_BITS-1 :0] {
        IDLE = 4'b0000, // idle state
        DEAL_CARDS = 4'b001,
        PLAYER_TURN = 4'b0011,
        DEALER_TURN = 4'b0010,
        CHECK_WINNER = 4'b0110,
        DEALER_WIN = 4'b1001,
        PLAYER_WIN = 4'b1010,
        PLAYER_CARD_CHOOSE = 4'b0100,
        DEALER_CARD_CHOOSE = 4'b0101,
        PLAYER_SCORE_CHECK = 4'b0111,
        DEALER_SCORE_CHECK = 4'b1000,
        DRAW = 4'b1011
    } state, state_nxt;


    logic [3:0] player_card_values_nxt [8:0]; // Zakładamy, że gracz może mieć maksymalnie 9 kart
    logic [1:0] player_card_symbols_nxt [8:0];
    logic [3:0] dealer_card_values_nxt [8:0]; // Zakładamy, że gracz może mieć maksymalnie 9 kart
    logic [1:0] dealer_card_symbols_nxt [8:0];
    logic [3:0] player_card_count;
    logic [3:0] player_card_count_nxt;
    logic [3:0] dealer_card_count;
    logic [3:0] dealer_card_count_nxt;
    logic [2:0] state_btn_nxt;


    logic card_chosen_finished;
    logic card_chosen_finished_nxt;
    logic deal_card_finished;
    logic deal_card_finished_nxt;
    logic lose_player;
    logic lose_dealer;
    logic counter;
    logic counter_nxt;
    logic checking_finshed;
    logic checking_finshed_nxt;
    logic checking_dealer_finshed;
    logic checking_dealer_finshed_nxt;
    logic dealer_round_finshed;
    logic deal_turn_finished;
    logic deal_turn_finished_nxt;
    logic check_winner_finshed;
    logic check_winner_finshed_nxt;









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
                for (int i = 0; i <= 8; i++) begin
                    SM_out.dealer_card_values[i] <= 0;
                    SM_out.dealer_card_symbols[i] <= 0;
                end
                player_card_count <= 0;
                card_chosen_finished <= 0;
                dealer_card_count <= 0;
                deal_card_finished <= 0;
                counter <= 0 ;
                checking_finshed <= 0;
                checking_dealer_finshed <= 0;
                deal_turn_finished <= 0;
                state_btn <= 0;
                state <= IDLE;
                check_winner_finshed <= 0;
            end
            else begin : state_seq_run_blk
                for (int i = 0; i <= 8; i++) begin
                    SM_out.player_card_values[i] <= player_card_values_nxt[i];
                    SM_out.player_card_symbols[i] <= player_card_symbols_nxt[i];
                end
                for (int i = 0; i <= 8; i++) begin
                    SM_out.dealer_card_values[i] <= dealer_card_values_nxt[i];
                    SM_out.dealer_card_symbols[i] <= dealer_card_symbols_nxt[i];
                end
                player_card_count <= player_card_count_nxt;
                card_chosen_finished <= card_chosen_finished_nxt;
                dealer_card_count <= dealer_card_count_nxt;
                deal_card_finished <= deal_card_finished_nxt;
                checking_finshed <= checking_finshed_nxt;
                checking_dealer_finshed <= checking_dealer_finshed_nxt;
                counter <= counter_nxt;
                deal_turn_finished <= deal_turn_finished_nxt;
                check_winner_finshed <= check_winner_finshed_nxt;
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
            PLAYER_SCORE_CHECK: state_nxt = checking_finshed ? (lose_player ? DEALER_WIN : PLAYER_TURN) : PLAYER_SCORE_CHECK;
            DEALER_TURN:        state_nxt = deal_turn_finished ? DEALER_SCORE_CHECK : DEALER_TURN;
            DEALER_SCORE_CHECK: state_nxt = checking_dealer_finshed ? ((lose_dealer ? PLAYER_WIN : (dealer_round_finshed ? CHECK_WINNER : DEALER_SCORE_CHECK ))) : DEALER_SCORE_CHECK;
            DEALER_WIN :        state_nxt = right_mouse ? IDLE : DEALER_WIN;
            PLAYER_WIN :        state_nxt = left_mouse ? IDLE : PLAYER_WIN;
            DRAW :              state_nxt = right_mouse ? IDLE : DEALER_WIN;
            CHECK_WINNER :      state_nxt = check_winner_finshed ? (lose_dealer ? PLAYER_WIN : (lose_player ? DEALER_WIN : DRAW) ) : CHECK_WINNER;
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
        for (int i = 0; i <= 8; i++) begin
            dealer_card_values_nxt[i] = SM_out.dealer_card_values[i];
            dealer_card_symbols_nxt[i] = SM_out.dealer_card_symbols[i];
        end
        check_winner_finshed_nxt = check_winner_finshed;
        player_card_count_nxt = player_card_count;
        card_chosen_finished_nxt = card_chosen_finished;
        deal_card_finished_nxt = deal_card_finished;
        checking_dealer_finshed_nxt = checking_dealer_finshed;
        checking_finshed_nxt = checking_finshed;
        dealer_card_count_nxt = dealer_card_count;
        state_btn_nxt = state_btn;
        lose_player = 0;
        lose_dealer = 0;
        dealer_round_finshed = 0;
        counter_nxt = counter;
        deal_turn_finished_nxt = deal_turn_finished;
        case (state)
            IDLE: begin
                for (int i = 0; i <= 8; i++) begin
                    player_card_values_nxt[i] = 0;
                    player_card_symbols_nxt[i] = 0;
                end
                for (int i = 0; i <= 8; i++) begin
                    dealer_card_values_nxt[i] = 0;
                    dealer_card_symbols_nxt[i] = 0;
                end

                player_card_count_nxt = 0;
                card_chosen_finished_nxt = 0;
                deal_card_finished_nxt = 0;
                state_btn_nxt = 0;
                checking_finshed_nxt = 0;
                lose_dealer = 0;
                lose_player = 0;
                counter_nxt = 0;
                dealer_round_finshed = 0;
                deal_turn_finished_nxt = 0;
                check_winner_finshed_nxt = 0;
                checking_dealer_finshed_nxt = 0;
            end
            DEAL_CARDS: begin
                player_card_values_nxt[0] = 10;
                player_card_symbols_nxt[0] = 3;
                player_card_values_nxt[1] = 9;
                player_card_symbols_nxt[1] = 0;
                dealer_card_values_nxt[0] = 10;
                dealer_card_symbols_nxt[0] = 3;

                player_card_count_nxt = 2;
                dealer_card_count_nxt = 1;
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
                if (total_player_value >= 22) begin
                    lose_player = 1;
                end else if (total_player_value <= 21) begin
                    lose_player = 0;
                end

                state_btn_nxt = 1;
                checking_finshed_nxt = 1;
            end
            DEALER_TURN: begin
                dealer_card_values_nxt[dealer_card_count] = 5;
                dealer_card_symbols_nxt[dealer_card_count] = 1;
                dealer_card_count_nxt = dealer_card_count + 1;
                deal_turn_finished_nxt = 1;
            end
            DEALER_SCORE_CHECK: begin
                if (total_dealer_value >= 22) begin
                    lose_dealer = 1;
                    dealer_round_finshed = 0;
                end else if (total_dealer_value >= 17 && total_dealer_value <= 21) begin
                    lose_dealer = 0;
                    dealer_round_finshed = 1;
                end else if (total_dealer_value <= 16) begin
                    lose_dealer = 0;
                    dealer_round_finshed = 0;
                end
                state_btn_nxt = 2;
                checking_dealer_finshed_nxt = 1;
            end
            CHECK_WINNER : begin
                if (total_dealer_value > total_player_value) begin
                    lose_dealer = 0;
                    lose_player = 1;
                end else if (total_player_value > total_dealer_value) begin
                    lose_dealer = 1;
                    lose_player = 0;
                end else if (total_dealer_value == total_player_value) begin
                    lose_dealer = 0;
                    lose_player = 0;
                end
                check_winner_finshed_nxt = 1;
            end
            DEALER_WIN: begin
            end
            PLAYER_WIN: begin
            end
            DRAW: begin
            end
            default: begin
            end
        endcase
    end



endmodule