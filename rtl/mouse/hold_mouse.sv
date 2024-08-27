  /**
   * Copyright (C) 2024  AGH University of Science and Technology
   * MTM UEC2
   * Authors: Konrad Sawina, Borys Strzeboński
   * Description:
   * Module that is responsible for controlling the direction of the ball.
   */

  `timescale 1 ns / 1 ps

module hold_mouse (
    input  logic clk,
    input  logic rst,
    input  logic [11:0] xpos,
    input  logic [11:0] ypos,
    input  logic left,
    input  logic right,

    output logic left_out,
    output logic right_out,
    output logic [11:0] xposout,
    output logic [11:0] yposout
  );

  logic left_nxt;
  logic right_nxt;
  logic [11:0] xpos_nxt;
  logic [11:0] ypos_nxt;

  always_ff @(posedge clk) begin
    if (rst) begin
      yposout   <= '0;
      xposout   <= '0;
      left_out  <= '0;
      right_out <= '0;
    end else begin
      yposout   <= ypos_nxt;
      xposout   <= xpos_nxt;
      left_out  <= left_nxt;
      right_out <= right_nxt;
    end
  end

  always_comb begin : out_comb_blk
    left_nxt = left;
    right_nxt = right;
    xpos_nxt = xpos;
    ypos_nxt = ypos;
  end

endmodule