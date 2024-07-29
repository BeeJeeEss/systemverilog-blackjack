module char_16x16 (
    input logic clk,
    input logic [7:0] char_xy,
    output logic [6:0] char_code
);

import vga_pkg::*;

reg [0:15][7:0] line1 = "litwo ojczyzno";   //Iijl()=+-><.,1
reg [0:15][7:0] line2 = "moja";
reg [0:15][7:0] line3 = "ty";
reg [0:15][7:0] line4 = "jestes";
reg [0:15][7:0] line5 = "jak zdrowie ile";
reg [0:15][7:0] line6 = "cie trzeba cenic";
reg [0:15][7:0] line7 = "ten tylko sie dowie";
reg [0:15][7:0] line8 = "kto sie stracil";
reg [0:15][7:0] line9 = "dzis";
reg [0:15][7:0] line10 = "................";
reg [0:15][7:0] line11 = "pieknosc twa";
reg [0:15][7:0] line12 = "widze i opisuje";
reg [0:15][7:0] line13 = "bo tesknie";
reg [0:15][7:0] line14 = "po";
reg [0:15][7:0] line15 = "tobie";
reg [0:15][7:0] line16 = "kropka";
reg [0:15][7:0] selected_line;

always_ff @(posedge clk) begin
    case(char_xy[7:4])
        4'b0000: selected_line <= line1;
        4'b0001: selected_line <= line2;
        4'b0010: selected_line <= line3;
        4'b0011: selected_line <= line4;
        4'b0100: selected_line <= line5;
        4'b0101: selected_line <= line6;
        4'b0110: selected_line <= line7;
        4'b0111: selected_line <= line8;
        4'b1000: selected_line <= line9;
        4'b1001: selected_line <= line10;
        4'b1010: selected_line <= line11;
        4'b1011: selected_line <= line12;
        4'b1100: selected_line <= line13;
        4'b1101: selected_line <= line14;
        4'b1100: selected_line <= line15;
        4'b1111: selected_line <= line16;
    endcase

    char_code <= selected_line[char_xy[3:0]][6:0];

end

endmodule