`timescale 1 ns / 1 ps

module calculate_card(
        input logic clk,
        input logic rst,
        output logic [5:0] total_players_value, // Łączna wartość kart

        SM_if.in card_if // Interfejs wejściowy
    );

    logic [4:0] total_nxt;

    // Kopiowanie kart z interfejsu do zmiennych lokalnych
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            total_players_value <= 0;
        end else begin
            total_players_value <= total_nxt;
        end
    end


    // Logika obliczania wartości kart i flagi bust
    always_comb begin
        total_nxt = 0;

        total_nxt = calculate_card_value(card_if.player_card_values[0]) + calculate_card_value(card_if.player_card_values[1]) + calculate_card_value(card_if.player_card_values[2]) + calculate_card_value(card_if.player_card_values[3]) + + calculate_card_value(card_if.player_card_values[4]) + + calculate_card_value(card_if.player_card_values[5]) + calculate_card_value(card_if.player_card_values[6] + + calculate_card_value(card_if.player_card_values[7]) + + calculate_card_value(card_if.player_card_values[8]));

    end

    // Funkcja obliczająca wartość jednej karty
    function [7:0] calculate_card_value(input [3:0] card);
        case (card)
            4'b0001: calculate_card_value = 11; // As
            4'b1011, 4'b1100, 4'b1101: calculate_card_value = 10; // Walet, Dama, Król
            4'b0000: calculate_card_value = 0;
            default: calculate_card_value = card; // Karty od 2 do 10
        endcase
    endfunction

endmodule
