/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Konrad Sawina, Borys Strzeboński
 * Description:
 * SM which chooses a role (master/slave) at the begining.
 */

module player_selector
    (
        input  wire  clk,
        input  wire  rst,
        input  wire  player_1,
        input  wire  player_2,
        output logic [1:0] selected_player
    );

    localparam STATE_BITS = 2;

    logic [1:0] myout_nxt;

    enum logic [STATE_BITS-1 :0] {
        IDLE = 2'b00,
        MAIN_PLAYER = 2'b01,
        SIDE_PLAYER = 2'b11
    } state, state_nxt;

    always_ff @(posedge clk) begin
        if(rst)begin : state_seq_rst_blk
            state <= IDLE;
        end
        else begin : state_seq_run_blk
            state <= state_nxt;
        end
    end

    always_comb begin
        case(state)
            IDLE: state_nxt    = player_1 ? MAIN_PLAYER : (player_2 ? SIDE_PLAYER : IDLE);
            MAIN_PLAYER: state_nxt    = MAIN_PLAYER;
            SIDE_PLAYER: state_nxt    = SIDE_PLAYER;
            default: state_nxt = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin : out_reg_blk
        if(rst) begin : out_reg_rst_blk
            selected_player <= 2'b00;
        end
        else begin : out_reg_run_blk
            selected_player <= myout_nxt;
        end
    end

    always_comb begin : out_comb_blk
        case(state_nxt)
            IDLE : myout_nxt = 2'b00;
            MAIN_PLAYER: myout_nxt = 2'b01;
            SIDE_PLAYER: myout_nxt = 2'b11;
            default: myout_nxt = 2'b00;
        endcase
    end

endmodule