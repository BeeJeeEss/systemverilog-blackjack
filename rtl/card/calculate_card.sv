/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Konrad Sawina, Borys Strzeboński
 * Description:
 * Module responsible for calculating cards values.
 */

`timescale 1 ns / 1 ps

module calculate_card(
        input logic clk,
        input logic rst,
        output logic [4:0] total_players_value,
        output logic [4:0] total_dealer_value,

        SM_if.in card_if
    );

    logic [4:0] total_player_nxt;
    logic [4:0] temp_player_total;
    logic [4:0] total_dealer_nxt;
    logic [4:0] temp_dealer_total;

    logic flag;
    logic flag_d;

    always_ff @(posedge clk) begin
        if (rst) begin
            total_players_value <= 0;
            total_dealer_value <= 0;
        end else begin
            total_players_value <= total_player_nxt;
            total_dealer_value <= total_dealer_nxt;
        end
    end

    always_comb begin
        total_player_nxt = 0;
        temp_player_total = 0;
        total_dealer_nxt = 0;
        temp_dealer_total = 0;
        flag = 0;
        flag_d = 0;

        if((card_if.player_card_values[0] == 4'b0001) || (card_if.player_card_values[1] == 4'b0001)) begin
            flag = 1;
            temp_player_total += calculate_card_value(card_if.player_card_values[0],flag);
            temp_player_total += calculate_card_value(card_if.player_card_values[1],flag);
        end else begin
            flag = (temp_player_total > 10) ? 0 : 1;
            temp_player_total += calculate_card_value(card_if.player_card_values[0], flag);
            temp_player_total += calculate_card_value(card_if.player_card_values[1], flag);
        end
        for (int i = 2; i < 9; i++) begin
            flag = (temp_player_total > 10) ? 0 : 1;
            temp_player_total += calculate_card_value(card_if.player_card_values[i], flag);
        end

        if((card_if.dealer_card_values[0] == 4'b0001) || (card_if.dealer_card_values[1] == 4'b0001)) begin
            flag_d = 1;
            temp_dealer_total += calculate_card_value(card_if.dealer_card_values[0],flag_d);
        end else begin
            flag_d = (temp_dealer_total > 10) ? 0 : 1;
            temp_dealer_total += calculate_card_value(card_if.dealer_card_values[0],flag_d);
        end
        for (int i = 1; i < 9; i++) begin
            flag_d = (temp_dealer_total > 10) ? 0 : 1;
            temp_dealer_total += calculate_card_value(card_if.dealer_card_values[i], flag_d);
        end

        total_dealer_nxt = temp_dealer_total;
        total_player_nxt = temp_player_total;
    end

    function automatic [3:0] calculate_card_value(input [3:0] card, input flag = 0);
        case (card)
            4'b0001: calculate_card_value = flag ? 11 : 1;
            4'b1011, 4'b1100, 4'b1101: calculate_card_value = 10;
            4'b0000: calculate_card_value = 0;
            default: calculate_card_value = card;
        endcase
    endfunction

endmodule