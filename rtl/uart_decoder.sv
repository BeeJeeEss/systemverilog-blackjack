/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Andrzej Kozdrowski, Aron Lampart
 * Modified by: Borys Strzeboński, Konrad Sawina
 * Description:
 * Decoder for UART
 */

module uart_decoder(
        input wire clk,
        input wire rst,
        input wire [7:0] read_data,
        input wire rx_empty,

        output logic rd_uart,
        output logic decoded_deal,
        output logic decoded_dealer_finished,
        UART_if.out decoder_cards

    );

// Local variables
    logic rd_uart_nxt;
    logic decoded_deal_nxt;
    logic decoded_dealer_finished_nxt;
    logic [3:0] card_values_nxt [0:8];


//Logic

    always_ff @(posedge clk) begin : data_passed_through
        if(rst) begin
            rd_uart <= '0;
            decoded_deal <= '0;
            decoded_dealer_finished <= '0;
            for (int i = 0; i <= 8; i++) begin
                decoder_cards.card_values[i] <= '0;
            end
        end

        else begin
            rd_uart <= rd_uart_nxt;
            decoded_deal <= decoded_deal_nxt;
            decoded_dealer_finished <= decoded_dealer_finished_nxt;
            for (int i = 0; i <= 8; i++) begin
                decoder_cards.card_values[i] <= card_values_nxt[i];
            end
        end
    end

    always_comb begin : uart_decoding_module
        rd_uart_nxt = rd_uart;
        decoded_deal_nxt = decoded_deal;
        decoded_dealer_finished_nxt = decoded_dealer_finished;
        for (int i = 0; i <= 8; i++) begin
            card_values_nxt[i] = decoder_cards.card_values[i];
        end
        if(rx_empty == 1'b0) begin
            case(read_data[3:0])
                4'b0000: begin
                    decoded_dealer_finished_nxt = read_data[4];
                    decoded_deal_nxt = read_data[5];
                end
                4'b0001: begin
                    card_values_nxt[0] = read_data[7:4];
                end
                4'b0010: begin
                    card_values_nxt[1] = read_data[7:4];
                end
                4'b0011: begin
                    card_values_nxt[2] = read_data[7:4];
                end
                4'b0100: begin
                    card_values_nxt[3] = read_data[7:4];
                end
                4'b0101: begin
                    card_values_nxt[4] = read_data[7:4];
                end
                4'b0110: begin
                    card_values_nxt[5] = read_data[7:4];
                end
                4'b0111: begin
                    card_values_nxt[6] = read_data[7:4];
                end
                4'b1000: begin
                    card_values_nxt[7] = read_data[7:4];
                end
                4'b1001: begin
                    card_values_nxt[8] = read_data[7:4];
                end
                default: begin
                    card_values_nxt[0] = read_data[7:4];
                end
            endcase
            if(rd_uart == 1'b0) begin
                rd_uart_nxt = 1'b1;
            end
            else begin
                rd_uart_nxt = 1'b0;
            end
        end
        else begin

            rd_uart_nxt = 1'b0;
        end

    end

endmodule