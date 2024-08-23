     /**
      * Copyright (C) 2024  AGH University of Science and Technology
      * MTM UEC2
      * Authors: Konrad Sawina, Borys Strzeboński
      * Description:
      * Module responsible for sending signals to the SM.
      */

     `timescale 1 ns / 1 ps

module buttons_click (
        input  wire clk,
        input  wire rst,
        input  wire [11:0] mouse_x,
        input  wire [11:0] mouse_y,
        input  wire  left_mouse,

        output logic deal,
        output logic hit,
        output logic stand,
        output logic start,
        output logic player1,
        output logic player2
    );

    logic deal_nxt;
    logic hit_nxt;
    logic stand_nxt;
    logic start_nxt;
    logic player1_nxt;
    logic player2_nxt;


    always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
            deal <= 0;
            hit <= 0;
            stand <= 0;
            start <= 0;
            player1 <= 0;
            player2 <= 0;
        end else begin
            deal <= deal_nxt;
            hit <= hit_nxt;
            stand <= stand_nxt;
            start <= start_nxt;
            player1 <= player1_nxt;
            player2 <= player2_nxt;
        end
    end

    always_comb begin
        deal_nxt = 0;
        hit_nxt = 0;
        stand_nxt = 0;
        start_nxt = 0;
        player1_nxt = 0;
        player2_nxt = 0;
        if (left_mouse) begin

            if((mouse_x >= 342)&&(mouse_x<=442)&&(mouse_y>=668)&&(mouse_y<=718))  begin
                deal_nxt = 1;
            end
            else if((mouse_x >= 462)&&(mouse_x<=562)&&(mouse_y>=668)&&(mouse_y<=718)) begin
                hit_nxt = 1;
            end
            else if((mouse_x >= 582)&&(mouse_x<=682)&&(mouse_y>=668)&&(mouse_y<=718)) begin
                stand_nxt = 1;
            end
            else if((mouse_x >= 422)&&(mouse_x<=542)&&(mouse_y>=370)&&(mouse_y<=430)) begin
                start_nxt = 1;
            end
            else if((mouse_x >= 150)&&(mouse_x<=310)&&(mouse_y>=370)&&(mouse_y<=430)) begin
                player1_nxt = 1;
            end
            else if((mouse_x >= 714)&&(mouse_x<=874)&&(mouse_y>=370)&&(mouse_y<=430)) begin
                player2_nxt = 1;
            end
        end
    end



endmodule