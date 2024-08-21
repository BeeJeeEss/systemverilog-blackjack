/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Konrad Sawina, Borys Strzeboński
 * Description:
 * Module that is responsible for controlling the direction of the ball.
 */

module player_selector
    (
        input  wire  clk,  // posedge active clock
        input  wire  rst,  // high-level active synchronous reset
        input  wire  left_mouse,
        input  wire  right_mouse,
        output logic [1:0] selected_player
    );

    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    localparam STATE_BITS = 2; // number of bits used for state register

    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------
    logic [1:0] myout_nxt;

    enum logic [STATE_BITS-1 :0] {
        IDLE = 2'b00, // idle state
        MAIN_PLAYER = 2'b01,
        SIDE_PLAYER = 2'b11
    } state, state_nxt;

    //------------------------------------------------------------------------------
    // state sequential with synchronous reset
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : state_seq_blk
        if(rst)begin : state_seq_rst_blk
            state <= IDLE;
        end
        else begin : state_seq_run_blk
            state <= state_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // next state logic
    //------------------------------------------------------------------------------
    always_comb begin : state_comb_blk
        case(state)
            IDLE: state_nxt    = left_mouse ? MAIN_PLAYER : (right_mouse ? SIDE_PLAYER : IDLE);
            MAIN_PLAYER: state_nxt    = MAIN_PLAYER;
            SIDE_PLAYER: state_nxt    = SIDE_PLAYER;
            default: state_nxt = IDLE;
        endcase
    end
    //------------------------------------------------------------------------------
    // output register
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : out_reg_blk
        if(rst) begin : out_reg_rst_blk
            selected_player <= 2'b00;
        end
        else begin : out_reg_run_blk
            selected_player <= myout_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // output logic
    //------------------------------------------------------------------------------
    always_comb begin : out_comb_blk
        case(state_nxt)
            IDLE : myout_nxt = 2'b00;
            MAIN_PLAYER: myout_nxt = 2'b01;
            SIDE_PLAYER: myout_nxt = 2'b11;
            default: myout_nxt = 2'b00;
        endcase
    end

endmodule