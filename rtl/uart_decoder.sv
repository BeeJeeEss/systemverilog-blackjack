/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Konrad Sawina, Borys Strzeboński
 * Description:
 * Module responsible for decoding UART signals.
 */

module uart_decoder(
        input wire clk,
        input wire rst,
        input wire [7:0] read_data,
        input wire rx_empty,

        output logic rd_uart,
        output logic decoded_deal,
        output logic decoded_dealer_finished,
        output logic [3:0] first_card,
        output logic [3:0] second_card,
        output logic [3:0] third_card
    );

// Local variables
    logic rd_uart_nxt;
    logic decoded_deal_nxt;
    logic decoded_dealer_finished_nxt;
    logic [3:0] first_card_nxt;
    logic [3:0] second_card_nxt;
    logic [3:0] third_card_nxt;


//Logic

    always_ff @(posedge clk) begin : data_passed_through
        if(rst) begin
            rd_uart <= '0;
            decoded_deal <= '0;
            decoded_dealer_finished <= '0;
            first_card <= '0;
            second_card <= '0;
            third_card <= '0;

        end
        else begin
            rd_uart <= rd_uart_nxt;
            decoded_deal <= decoded_deal_nxt;
            decoded_dealer_finished <= decoded_dealer_finished_nxt;
            first_card <= first_card_nxt;
            second_card <= second_card_nxt;
            third_card <= third_card_nxt;

        end
    end

    always_comb begin : uart_decoding_module
        rd_uart_nxt = rd_uart;
        decoded_deal_nxt = decoded_deal;
        decoded_dealer_finished_nxt = decoded_dealer_finished;
        first_card_nxt = first_card;
        second_card_nxt = second_card;
        third_card_nxt = third_card;
        // fourth_card_nxt = fourth_card;

        if(rx_empty == 1'b0) begin
            case(read_data[3:0])
                4'b0000: begin
                    decoded_dealer_finished_nxt = read_data[4];
                    decoded_deal_nxt = read_data[5];
                end
                4'b0001: begin
                    first_card_nxt = read_data[7:4];
                end
                4'b0010: begin
                    second_card_nxt = read_data[7:4];
                end
                4'b0011: begin
                    third_card_nxt = read_data[7:4];
                end
                default: begin

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