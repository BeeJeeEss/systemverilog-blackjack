`timescale 1 ns / 1 ps

module calculate_card(
        input logic clk,
        input logic rst,
        output logic [4:0] total_players_value,

        SM_if.in card_if
    );

    logic [4:0] total_nxt;
    logic [4:0] temp_total;


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
        temp_total = 0;

        // Suma wartości kart bez Asów
        for (int i = 0; i < 9; i++) begin
            if (card_if.player_card_values[i] != 4'b0001) begin
                temp_total += calculate_card_value(card_if.player_card_values[i]);
            end
        end

        // Obsługa Asów
        for (int i = 0; i < 9; i++) begin
            if (card_if.player_card_values[i] == 4'b0001) begin
                if (temp_total + 11 <= 21) begin
                    temp_total += 11;
                end else begin
                    temp_total += 1;
                end
            end
        end

        total_nxt = temp_total;
    end

    // Funkcja obliczająca wartość jednej karty
    function automatic [3:0] calculate_card_value(input [3:0] card);
        case (card)
            4'b0001: calculate_card_value = 0; // As is handled separately
            4'b1011, 4'b1100, 4'b1101: calculate_card_value = 10; // Walet, Dama, Król
            4'b0000: calculate_card_value = 0;
            default: calculate_card_value = card; // Karty od 2 do 10
        endcase
    endfunction

endmodule
