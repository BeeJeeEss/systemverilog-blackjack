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
        NOTHING = 3'b111
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









    //------------------------------------------------------------------------------
    // state sequential with synchronous reset
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : state_seq_blk
        if(vga_blackjack_in.hcount == 0 & vga_blackjack_in.vcount == 0) begin
            if(rst)begin : state_seq_rst_blk
                SM_out.player_card_values[0] <= 0;
                SM_out.player_card_symbols[0] <= 0;
                SM_out.player_card_values[1] <= 0;
                SM_out.player_card_symbols[1] <= 0;
                SM_out.player_card_values[2] <= 0;
                SM_out.player_card_symbols[2] <= 0;
                SM_out.player_card_values[3] <= 0;
                SM_out.player_card_symbols[3] <= 0;
                SM_out.player_card_values[4] <= 0;
                SM_out.player_card_symbols[4] <= 0;
                SM_out.player_card_values[5] <= 0;
                SM_out.player_card_symbols[5] <= 0;
                SM_out.player_card_values[6] <= 0;
                SM_out.player_card_symbols[6] <= 0;
                SM_out.player_card_values[7] <= 0;
                SM_out.player_card_symbols[7] <= 0;
                SM_out.player_card_values[8] <= 0;
                SM_out.player_card_symbols[8] <= 0;
                player_card_count <= 0;
                card_chosen_finished <= 0;
                deal_card_finished <= 0;
                state_btn <= 0;
                state <= IDLE;
            end
            else begin : state_seq_run_blk
                SM_out.player_card_values[0] <= player_card_values_nxt[0];
                SM_out.player_card_symbols[0] <= player_card_symbols_nxt[0];
                SM_out.player_card_values[1] <= player_card_values_nxt[1];
                SM_out.player_card_symbols[1] <= player_card_symbols_nxt[1];
                SM_out.player_card_values[2] <= player_card_values_nxt[2];
                SM_out.player_card_symbols[2] <= player_card_symbols_nxt[2];
                SM_out.player_card_values[3] <= player_card_values_nxt[3];
                SM_out.player_card_symbols[3] <= player_card_symbols_nxt[3];
                SM_out.player_card_values[4] <= player_card_values_nxt[4];
                SM_out.player_card_symbols[4] <= player_card_symbols_nxt[4];
                SM_out.player_card_values[5] <= player_card_values_nxt[5];
                SM_out.player_card_symbols[5] <= player_card_symbols_nxt[5];
                SM_out.player_card_values[6] <= player_card_values_nxt[6];
                SM_out.player_card_symbols[6] <= player_card_symbols_nxt[6];
                SM_out.player_card_values[7] <= player_card_values_nxt[7];
                SM_out.player_card_symbols[7] <= player_card_symbols_nxt[7];
                SM_out.player_card_values[8] <= player_card_values_nxt[7];
                SM_out.player_card_symbols[8] <= player_card_symbols_nxt[7];

                player_card_count <= player_card_count_nxt;
                card_chosen_finished <= card_chosen_finished_nxt;
                deal_card_finished <= deal_card_finished_nxt;
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

            IDLE:               state_nxt = deal ? DEAL_CARDS : IDLE; //deal l
            DEAL_CARDS:         state_nxt = deal_card_finished ? PLAYER_TURN : DEAL_CARDS;
            PLAYER_TURN:        state_nxt = stand ? DEALER_TURN : (hit ? PLAYER_CARD_CHOOSE : PLAYER_TURN); //stand,hit lr
             PLAYER_CARD_CHOOSE: state_nxt = card_chosen_finished ? NOTHING : PLAYER_CARD_CHOOSE;
            DEALER_TURN:        state_nxt = left_mouse ? IDLE : DEALER_TURN;
            // default:            state_nxt = IDLE;

        endcase

    end

    //------------------------------------------------------------------------------
    // output register
    //----------------------------------------------------------------------------


    always_comb begin
        case (state)
            IDLE: begin
                player_card_values_nxt[0] = 0;
                player_card_symbols_nxt[0] = 0;
                player_card_values_nxt[1] = 0;
                player_card_symbols_nxt[1] = 0;
                player_card_values_nxt[2] = 0;
                player_card_symbols_nxt[2] = 0;
                player_card_values_nxt[3] = 0;
                player_card_symbols_nxt[3] = 0;
                player_card_values_nxt[4] = 0;
                player_card_symbols_nxt[4] = 0;
                player_card_values_nxt[5] = 0;
                player_card_symbols_nxt[5] = 0;
                player_card_values_nxt[6] = 0;
                player_card_symbols_nxt[6] = 0;
                player_card_values_nxt[7] = 0;
                player_card_symbols_nxt[7] = 0;
                player_card_values_nxt[8] = 0;
                player_card_symbols_nxt[8] = 0;

                player_card_count_nxt = 0;
                card_chosen_finished_nxt = 0;
                deal_card_finished_nxt = 0;
                state_btn_nxt = 0;
            end
            DEAL_CARDS: begin
                player_card_values_nxt[0] = 5;
                player_card_symbols_nxt[0] = 3;
                player_card_values_nxt[1] = 1;
                player_card_symbols_nxt[1] = 0;
                player_card_values_nxt[2] = 0;
                player_card_symbols_nxt[2] = 0;
                player_card_values_nxt[3] = 0;
                player_card_symbols_nxt[3] = 0;
                player_card_values_nxt[4] = 0;
                player_card_symbols_nxt[4] = 0;
                player_card_values_nxt[5] = 0;
                player_card_symbols_nxt[5] = 0;
                player_card_values_nxt[6] = 0;
                player_card_symbols_nxt[6] = 0;
                player_card_values_nxt[7] = 0;
                player_card_symbols_nxt[7] = 0;
                player_card_values_nxt[8] = 0;
                player_card_symbols_nxt[8] = 0;


                player_card_count_nxt = 1;
                card_chosen_finished_nxt = 0;
                deal_card_finished_nxt = 1;
                state_btn_nxt = 1;
            end
            NOTHING: begin
                player_card_values_nxt[0] = SM_out.player_card_values[0];
                player_card_symbols_nxt[0] = SM_out.player_card_symbols[0];
                player_card_values_nxt[1] = SM_out.player_card_values[1];
                player_card_symbols_nxt[1] = SM_out.player_card_symbols[1];
                player_card_values_nxt[2] = SM_out.player_card_values[2];
                player_card_symbols_nxt[2] = SM_out.player_card_symbols[2];
                player_card_values_nxt[3] = SM_out.player_card_values[2];
                player_card_symbols_nxt[3] = SM_out.player_card_symbols[2];
                player_card_values_nxt[4] = SM_out.player_card_values[3];
                player_card_symbols_nxt[4] = SM_out.player_card_symbols[3];
                player_card_values_nxt[5] = SM_out.player_card_values[3];
                player_card_symbols_nxt[5] = SM_out.player_card_symbols[4];
                player_card_values_nxt[6] = SM_out.player_card_values[6];
                player_card_symbols_nxt[6] = SM_out.player_card_symbols[6];
                player_card_values_nxt[7] = SM_out.player_card_values[7];
                player_card_symbols_nxt[7] = SM_out.player_card_symbols[7];
                player_card_values_nxt[8] = SM_out.player_card_values[8];
                player_card_symbols_nxt[8] = SM_out.player_card_symbols[8];
                state_btn_nxt = 2;
            end
            PLAYER_TURN: begin
                player_card_values_nxt[0] = SM_out.player_card_values[0];
                player_card_symbols_nxt[0] = SM_out.player_card_symbols[0];
                player_card_values_nxt[1] = SM_out.player_card_values[1];
                player_card_symbols_nxt[1] = SM_out.player_card_symbols[1];
                player_card_values_nxt[2] = SM_out.player_card_values[2];
                player_card_symbols_nxt[2] = SM_out.player_card_symbols[2];
                player_card_values_nxt[3] = SM_out.player_card_values[2];
                player_card_symbols_nxt[3] = SM_out.player_card_symbols[2];
                player_card_values_nxt[4] = SM_out.player_card_values[3];
                player_card_symbols_nxt[4] = SM_out.player_card_symbols[3];
                player_card_values_nxt[5] = SM_out.player_card_values[3];
                player_card_symbols_nxt[5] = SM_out.player_card_symbols[4];
                player_card_values_nxt[6] = SM_out.player_card_values[6];
                player_card_symbols_nxt[6] = SM_out.player_card_symbols[6];
                player_card_values_nxt[7] = SM_out.player_card_values[7];
                player_card_symbols_nxt[7] = SM_out.player_card_symbols[7];
                player_card_values_nxt[8] = SM_out.player_card_values[8];
                player_card_symbols_nxt[8] = SM_out.player_card_symbols[8];
                player_card_count_nxt = player_card_count;
                card_chosen_finished_nxt = 0;
                deal_card_finished_nxt = 0;
                state_btn_nxt = 1;

            end
            PLAYER_CARD_CHOOSE : begin
                player_card_values_nxt[0] = SM_out.player_card_values[0];
                player_card_symbols_nxt[0] = SM_out.player_card_symbols[0];
                player_card_values_nxt[1] = SM_out.player_card_values[1];
                player_card_symbols_nxt[1] = SM_out.player_card_symbols[1];
                player_card_values_nxt[2] = SM_out.player_card_values[2];
                player_card_symbols_nxt[2] = SM_out.player_card_symbols[2];
                player_card_values_nxt[3] = SM_out.player_card_values[2];
                player_card_symbols_nxt[3] = SM_out.player_card_symbols[2];
                player_card_values_nxt[4] = SM_out.player_card_values[3];
                player_card_symbols_nxt[4] = SM_out.player_card_symbols[3];
                player_card_values_nxt[5] = SM_out.player_card_values[3];
                player_card_symbols_nxt[5] = SM_out.player_card_symbols[4];
                player_card_values_nxt[6] = SM_out.player_card_values[6];
                player_card_symbols_nxt[6] = SM_out.player_card_symbols[6];
                player_card_values_nxt[7] = SM_out.player_card_values[7];
                player_card_symbols_nxt[7] = SM_out.player_card_symbols[7];
                player_card_values_nxt[8] = SM_out.player_card_values[8];
                player_card_symbols_nxt[8] = SM_out.player_card_symbols[8];
                player_card_values_nxt[player_card_count] = 12;
                player_card_symbols_nxt[player_card_count] = 0;
                player_card_count_nxt = player_card_count + 1;
                card_chosen_finished_nxt = 1;
                state_btn_nxt = 1;
                deal_card_finished_nxt = 0;
//                state_nxt = NOTHING;
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