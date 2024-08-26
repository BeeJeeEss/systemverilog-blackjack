`timescale 1ns/1ps

module card_animation
    (
        input logic        clk,
        input logic        rst,
        input logic  [2:0] animation,

        output logic [11:0] xpos,
        output logic [11:0] ypos,
        output logic [1:0] angle,
        output logic animation_end,

        vga_if.in vga_in
    );

    logic [11:0]    xpos_nxt;
    logic [11:0]    ypos_nxt;
    logic [8:0]     V; // V - velocity (predkosc)
    logic [8:0]     V_nxt;
    logic [1:0]     angle_nxt;
    logic [2:0]     counter;
    logic [2:0]     counter_nxt;
    logic           animation_end_nxt;

    enum logic [2:0] {
        IDLE = 3'b000, // idle state
        DOWN = 3'b001,
        UP   = 3'b100,
        STOP = 3'b010,
        RESET = 3'b011,
        STRAIGHT = 3'b101
    } state, state_nxt;


    always_ff @(posedge clk) begin : xypos_blk
        if(vga_in.hcount == 0 & vga_in.vcount == 0) begin
            if(rst) begin
                state    <= IDLE;
                V        <= 3;
                angle    <= 0;
                xpos     <= 350;
                ypos     <= 365;
                counter  <= 0;
                animation_end <= 0;

            end

            else begin
                state    <= state_nxt;
                V        <= V_nxt;
                angle    <= angle_nxt;
                xpos     <= xpos_nxt;
                ypos     <= ypos_nxt;
                counter  <= counter_nxt;
                animation_end <= animation_end_nxt;

            end
        end

        else begin
        end

    end

    localparam XPOS_END = 437;




    always_comb begin

        case(state)

            IDLE:       state_nxt = animation == 1 ? DOWN :(animation == 2? UP : (animation == 3 ? STRAIGHT :IDLE));
            STRAIGHT:   state_nxt = xpos >= XPOS_END ? STOP : STRAIGHT;
            DOWN:       state_nxt = xpos >= XPOS_END ? STOP : DOWN;
            UP:         state_nxt = xpos >= XPOS_END ? STOP : UP;
            STOP:       state_nxt = animation == 0 ? RESET : STOP;
            RESET:      state_nxt = IDLE;
            default:    state_nxt = IDLE;

        endcase

    end


    always_comb begin

        case(state)

            IDLE: begin
                V_nxt = 2;
                xpos_nxt = 252;
                ypos_nxt = 365;
                angle_nxt = angle;
                animation_end_nxt = 0;
            end

            DOWN: begin
                V_nxt = V;
                xpos_nxt = xpos + V;
                ypos_nxt = ypos + V;
                if (counter == 3) begin
                    angle_nxt = angle + 1;
                end else
                    angle_nxt = angle;
                animation_end_nxt = 0;
            end

            STRAIGHT: begin
                V_nxt = V;
                xpos_nxt = xpos + V;
                ypos_nxt = ypos ;
                if (counter == 3) begin
                    angle_nxt = angle + 1;
                end else
                    angle_nxt = angle;
                animation_end_nxt = 0;
            end

            UP: begin
                V_nxt = V;
                xpos_nxt = xpos + V;
                ypos_nxt = ypos - V;
                if (counter == 3) begin
                    angle_nxt = angle + 1;
                end else
                    angle_nxt = angle;
                animation_end_nxt = 0;
            end

            STOP: begin
                V_nxt = 2;
                xpos_nxt = xpos;
                ypos_nxt = ypos;
                angle_nxt = 0;
                animation_end_nxt = 1;
            end

            RESET: begin
                V_nxt = 2;
                xpos_nxt = 252;
                ypos_nxt = 365;
                angle_nxt = 0;
                animation_end_nxt = 1;
            end

            default: begin
                V_nxt = 2;
                xpos_nxt = 252;
                ypos_nxt = 365;
                angle_nxt = 0;
                animation_end_nxt = 0;
            end

        endcase

    end

    always_comb begin
        counter_nxt = counter + 1;
    end


endmodule