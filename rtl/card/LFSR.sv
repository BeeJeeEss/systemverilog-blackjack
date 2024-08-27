/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Source: https://simplefpga.blogspot.com/2013/02/random-number-generator-in-verilog-fpga.html
 * Modified by: Konrad Sawina, Borys Strzeboński
 * Description:
 * Module responsible for randomizing numbers.
 */

module LFSR #(
        parameter RANDOM = 13'hF
    )(
        input clk,
        input rst,
        output reg [3:0] rnd
    );

    logic [12:0] random, random_next;
    logic [3:0] count, count_next;

    wire feedback = random[12] ^ random[3] ^ random[2] ^ random[0];

    always_ff @(posedge clk) begin
        if (rst)
        begin
            random <= RANDOM;
            count <= 0;
            rnd <= 1;
        end
        else
        begin
            random <= random_next;
            count <= count_next;

            if (random_next[9:6] >= 1 && random_next[9:6] <= 13) begin
                rnd <= random_next[9:6];
            end else begin
                rnd <= rnd;
            end
        end
    end

    always_comb begin
        random_next = {random[11:0], feedback};
        if (count == 13) begin
            count_next = 0;
        end else begin
            count_next = count + 1;
        end
    end

endmodule
