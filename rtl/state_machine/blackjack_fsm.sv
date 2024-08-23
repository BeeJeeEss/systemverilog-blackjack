/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Konrad Sawina, Borys Strzeboński
 * Description:
 * Main SM of the game.
 */
module blackjack_FSM
    (
        input  wire  clk,  // posedge active clock
        input  wire  rst,  // high-level active synchronous reset
        input  wire  [4:0] total_player_value,
        input  wire  [4:0] total_dealer_value,

        input  wire  deal,
        input  wire  hit,
        input  wire  stand,
        input  wire  start,
        input  wire  [1:0] selected_player,

        input wire decoded_deal,
        input wire decoded_dealer_finished,
        input wire decoded_start,

        UART_if.in decoded_cards,

        output logic finished_player_1,
        output logic deal_card_finished,
        output logic deal_wait_btn,
        output logic start_pressed,

        output logic [2:0] state_btn,
        vga_if.in vga_blackjack_in,
        SM_if.out SM_out
    );

    // Instancjonowanie LFSR
    wire [3:0] lfsr_rnd; // Przewód dla sygnału wyjściowego z LFSR
    wire [3:0] lfsr_rnd_2;
    wire [3:0] lfsr_rnd_3;

    LFSR #(
        .RANDOM(13'ha)
    )u_LFSR(
        .clk,
        .rst,
        .rnd(lfsr_rnd)
    );

    LFSR #(
        .RANDOM(13'hfd)
    )u_LFSR_2(
        .clk,
        .rst,
        .rnd(lfsr_rnd_2)
    );

    LFSR #(
        .RANDOM(13'h6a)
    )u_LFSR_3(
        .clk,
        .rst,
        .rnd(lfsr_rnd_3)
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
        DRAW = 4'b1011,
        START = 4'b1111,
        WAIT_FOR_DEALER = 4'b1100
    } state, state_nxt;


    logic [3:0] player_card_values_nxt [8:0]; // Zakładamy, że gracz może mieć maksymalnie 9 kart
    logic [3:0] dealer_card_values_nxt [8:0]; // Zakładamy, że gracz może mieć maksymalnie 9 kart
    logic [3:0] player_card_count;
    logic [3:0] player_card_count_nxt;
    logic [3:0] dealer_card_count;
    logic [3:0] dealer_card_count_nxt;
    logic [2:0] state_btn_nxt;


    logic card_chosen_finished;
    logic card_chosen_finished_nxt;
    logic deal_card_finished_nxt;
    logic lose_player;
    logic lose_dealer;
    logic counter;
    logic counter_nxt;
    logic checking_finished;
    logic checking_finished_nxt;
    logic checking_dealer_finished;
    logic checking_dealer_finished_nxt;
    logic deal_turn_finished;
    logic deal_turn_finished_nxt;
    logic check_winner_finished;
    logic check_winner_finshed_nxt;
    logic lose_player_nxt;
    logic finished_player_1_nxt;
    logic dealer_round_finished;
    logic deal_wait_btn_nxt;

    //------------------------------------------------------------------------------
    // state sequential with synchronous reset
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : state_seq_blk
        if(vga_blackjack_in.hcount == 0 & vga_blackjack_in.vcount == 0) begin
            if(rst)begin : state_seq_rst_blk
                for (int i = 0; i <= 8; i++) begin
                    SM_out.player_card_values[i] <= 0;
                end
                for (int i = 0; i <= 8; i++) begin
                    SM_out.dealer_card_values[i] <= 0;
                end
                player_card_count <= 0;
                card_chosen_finished <= 0;
                dealer_card_count <= 0;
                deal_card_finished <= 0;
                counter <= 0 ;
                checking_finished <= 0;
                checking_dealer_finished <= 0;
                deal_turn_finished <= 0;
                state_btn <= 0;
                state <= IDLE;
                check_winner_finished <= 0;
                lose_player_nxt <= 0;
                finished_player_1 <= 0;
                deal_wait_btn <= 0;

            end
            else begin : state_seq_run_blk
                for (int i = 0; i <= 8; i++) begin
                    SM_out.player_card_values[i] <= player_card_values_nxt[i];
                end
                for (int i = 0; i <= 8; i++) begin
                    SM_out.dealer_card_values[i] <= dealer_card_values_nxt[i];
                end
                player_card_count <= player_card_count_nxt;
                card_chosen_finished <= card_chosen_finished_nxt;
                dealer_card_count <= dealer_card_count_nxt;
                deal_card_finished <= deal_card_finished_nxt;
                checking_finished <= checking_finished_nxt;
                checking_dealer_finished <= checking_dealer_finished_nxt;
                counter <= counter_nxt;
                deal_turn_finished <= deal_turn_finished_nxt;
                check_winner_finished <= check_winner_finshed_nxt;
                state_btn <= state_btn_nxt;
                lose_player_nxt <= lose_player;
                state <= state_nxt;
                finished_player_1 <= finished_player_1_nxt;
                deal_wait_btn <= deal_wait_btn_nxt;
            end
        end
    end

    //------------------------------------------------------------------------------
    // next state logic
    //------------------------------------------------------------------------------


    always_comb begin
        state_nxt = state;
        case(state)
            IDLE : begin
                case (selected_player)
                    2'b01:
                        state_nxt = start ? START : IDLE;
                    2'b11:
                        state_nxt = decoded_start ? DEAL_CARDS : START;
                    default:
                        state_nxt = state;
                endcase
            end
            START: begin
                case (selected_player)
                    2'b01:
                        state_nxt = deal ? DEAL_CARDS : START;
                    2'b11:
                        state_nxt = decoded_deal ? DEAL_CARDS : START;
                    default:
                        state_nxt = state;
                endcase
            end
            DEAL_CARDS:         state_nxt = deal_card_finished ? PLAYER_TURN : DEAL_CARDS;
            PLAYER_TURN:  begin
                case (selected_player)
                    2'b01:
                        state_nxt = hit ? PLAYER_CARD_CHOOSE : (stand ? DEALER_TURN : PLAYER_TURN);
                    2'b11:
                        state_nxt = hit ? PLAYER_CARD_CHOOSE : (stand ? WAIT_FOR_DEALER : PLAYER_TURN);
                    default:
                        state_nxt = state;
                endcase
            end
            PLAYER_CARD_CHOOSE: state_nxt = card_chosen_finished ? PLAYER_SCORE_CHECK : PLAYER_CARD_CHOOSE;
            PLAYER_SCORE_CHECK: begin
                case (selected_player)
                    2'b01:
                        state_nxt = checking_finished ? (lose_player ? DEALER_TURN : PLAYER_TURN) : PLAYER_SCORE_CHECK;
                    2'b11:
                        state_nxt = checking_finished ? (lose_player ? WAIT_FOR_DEALER : PLAYER_TURN) : PLAYER_SCORE_CHECK;
                    default:
                        state_nxt = state;
                endcase
            end
            WAIT_FOR_DEALER :   state_nxt = decoded_dealer_finished ? CHECK_WINNER : WAIT_FOR_DEALER;
            DEALER_TURN:        state_nxt = deal_turn_finished ? DEALER_SCORE_CHECK : DEALER_TURN;
            DEALER_SCORE_CHECK: state_nxt = checking_dealer_finished ? ((lose_dealer ? PLAYER_WIN : (dealer_round_finished ? CHECK_WINNER : DEALER_TURN ))) : DEALER_SCORE_CHECK;
            DEALER_WIN : begin
                case (selected_player)
                    2'b01:
                        state_nxt = (start && decoded_dealer_finished) ? START : DEALER_WIN;
                    2'b11:
                        state_nxt = decoded_start ? START : DEALER_WIN;
                    default:
                        state_nxt = state;
                endcase
            end
            PLAYER_WIN : begin
                case (selected_player)
                    2'b01:
                        state_nxt = (start && decoded_dealer_finished) ? START : PLAYER_WIN;
                    2'b11:
                        state_nxt = decoded_start ? START : PLAYER_WIN;
                    default:
                        state_nxt = state;
                endcase
            end
            DRAW : begin
                case (selected_player)
                    2'b01:
                        state_nxt = (start && decoded_dealer_finished) ? START : DRAW;
                    2'b11:
                        state_nxt = decoded_start ? START : DRAW;
                    default:
                        state_nxt = state;
                endcase
            end
            CHECK_WINNER :      state_nxt = check_winner_finished ? (lose_dealer ? PLAYER_WIN : (lose_player ? DEALER_WIN : DRAW) ) : CHECK_WINNER;
            default:            state_nxt = IDLE;

        endcase
    end

//------------------------------------------------------------------------------
// output register
//----------------------------------------------------------------------------


    always_comb begin
        finished_player_1_nxt = 0;
        for (int i = 0; i <= 8; i++) begin
            player_card_values_nxt[i] = SM_out.player_card_values[i];
        end
        for (int i = 0; i <= 8; i++) begin
            dealer_card_values_nxt[i] = SM_out.dealer_card_values[i];
        end
        check_winner_finshed_nxt = check_winner_finished;
        player_card_count_nxt = player_card_count;
        card_chosen_finished_nxt = card_chosen_finished;
        deal_card_finished_nxt = deal_card_finished;
        checking_dealer_finished_nxt = checking_dealer_finished;
        checking_finished_nxt = checking_finished;
        dealer_card_count_nxt = dealer_card_count;
        state_btn_nxt = state_btn;
        lose_dealer = 0;
        dealer_round_finished = 0;
        counter_nxt = counter;
        deal_turn_finished_nxt = deal_turn_finished;
        lose_player = lose_player_nxt;
        deal_wait_btn_nxt = 0;
        start_pressed = 0;
        case (state)
            IDLE : begin
                state_btn_nxt = 0;
            end
            START: begin
                for (int i = 0; i <= 8; i++) begin
                    player_card_values_nxt[i] = 0;
                end
                for (int i = 0; i <= 8; i++) begin
                    dealer_card_values_nxt[i] = 0;
                end

                player_card_count_nxt = 0;
                card_chosen_finished_nxt = 0;
                deal_card_finished_nxt = 0;
                state_btn_nxt = 1;
                checking_finished_nxt = 0;
                lose_dealer = 0;
                lose_player = 0;
                counter_nxt = 0;
                dealer_round_finished = 0;
                deal_turn_finished_nxt = 0;
                check_winner_finshed_nxt = 0;
                checking_dealer_finished_nxt = 0;
                start_pressed = 1;
            end
            DEAL_CARDS: begin
                case(selected_player)
                    2'b01: begin
                        player_card_values_nxt[0] = lfsr_rnd;
                        player_card_values_nxt[1] = lfsr_rnd_2;
                        dealer_card_values_nxt[0] = lfsr_rnd_3;
                    end
                    2'b11: begin
                        player_card_values_nxt[0] = lfsr_rnd;
                        player_card_values_nxt[1] = lfsr_rnd_2;
                        dealer_card_values_nxt[0] = decoded_cards.card_values[0];
                    end
                endcase

                player_card_count_nxt = 2;
                dealer_card_count_nxt = 1;
                deal_card_finished_nxt = 1;
                state_btn_nxt = 2;
            end
            PLAYER_TURN: begin
                state_btn_nxt = 1;
                if (hit == 0) begin
                    counter_nxt = 0;
                end else if (hit == 1) begin
                    counter_nxt = counter;
                end

                state_btn_nxt = 2;
            end
            PLAYER_CARD_CHOOSE : begin
                if (counter == 0) begin
                    counter_nxt = counter + 1;
                    player_card_count_nxt = player_card_count + 1;
                    player_card_values_nxt[player_card_count] = lfsr_rnd;
                end
                state_btn_nxt = 2;
                card_chosen_finished_nxt = 1;
            end
            PLAYER_SCORE_CHECK: begin
                if (total_player_value >= 22) begin
                    lose_player = 1;
                end else if (total_player_value <= 21) begin
                    lose_player = 0;
                end

                state_btn_nxt = 2;
                checking_finished_nxt = 1;
            end
            DEALER_TURN: begin
                if (total_dealer_value <= 16) begin
                    dealer_card_values_nxt[dealer_card_count] = lfsr_rnd;
                    dealer_card_count_nxt = dealer_card_count + 1;
                end
                state_btn_nxt = 2;
                deal_turn_finished_nxt = 1;
            end
            DEALER_SCORE_CHECK: begin
                if (total_dealer_value >= 22 && lose_player_nxt == 1) begin
                    lose_dealer = 0;
                    dealer_round_finished = 1;
                end else if (total_dealer_value >= 22 && lose_player_nxt == 0) begin
                    lose_dealer = 1;
                    dealer_round_finished = 1;
                end
                else if (total_dealer_value >= 17 && total_dealer_value <= 21) begin
                    lose_dealer = 0;
                    dealer_round_finished = 1;
                end else if (total_dealer_value <= 16) begin
                    lose_dealer = 0;
                    dealer_round_finished = 0;
                end
                state_btn_nxt = 2;
                checking_dealer_finished_nxt = 1;
            end
            CHECK_WINNER : begin
                case (lose_player_nxt)
                    1'b0: begin
                        if (total_dealer_value > total_player_value && total_dealer_value <= 21) begin
                            lose_dealer = 0;
                            lose_player = 1;
                        end else if (total_player_value > total_dealer_value && total_player_value >= 22) begin
                            lose_dealer = 0;
                            lose_player = 1;
                        end else if (total_player_value > total_dealer_value && total_player_value <= 21) begin
                            lose_dealer = 1;
                            lose_player = 0;
                        end else if (total_dealer_value == total_player_value) begin
                            lose_dealer = 0;
                            lose_player = 0;
                        end else if (total_dealer_value > total_player_value && total_dealer_value > 21) begin
                            lose_dealer = 1;
                            lose_player = 0;
                        end
                    end
                    1'b1: begin
                        lose_player = 1;
                        lose_dealer = 0;
                    end
                endcase

                state_btn_nxt = 2;
                check_winner_finshed_nxt = 1;
            end
            WAIT_FOR_DEALER: begin
                for (int i = 0; i <= 8; i++) begin
                    dealer_card_values_nxt[i] = decoded_cards.card_values[i];
                end
                deal_wait_btn_nxt = 1;

            end
            DEALER_WIN: begin
                state_btn_nxt = 4;
                finished_player_1_nxt = 1;
            end
            PLAYER_WIN: begin
                state_btn_nxt = 3;
                finished_player_1_nxt = 1;
            end
            DRAW: begin
                state_btn_nxt = 5;
                finished_player_1_nxt = 1;
            end
            default: begin
            end
        endcase
    end



endmodule