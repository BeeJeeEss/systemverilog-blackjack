  /**
   * Copyright (C) 2024  AGH University of Science and Technology
   * MTM UEC2
   * Authors: Konrad Sawina, Borys Strzeboński
   * Description:
   * Module responsible for drawing buttons.
   */

  `timescale 1 ns / 1 ps

module draw_buttons (
        input  logic clk,
        input  logic rst,
        input  logic [2:0] state,
        input  logic deal_wait_btn,
        input  wire [1:0] selected_player,
        input  wire dealer_finished,

        vga_if.out vga_btn_out,
        vga_if.in vga_btn_in
    );

    import vga_pkg::*;

    // Button parameters with specific positions
    localparam btn1_x = 342;   // First button position (X-axis)
    localparam btn1_y = 668;   // All buttons positioned 50 pixels from the bottom
    localparam btn1_width = 100;
    localparam btn1_height = 50;

    localparam btn2_x = 462;   // Second button positioned 120 pixels to the right of the first
    localparam btn2_y = 668;
    localparam btn2_width = 100;
    localparam btn2_height = 50;

    localparam btn3_x = 582;   // Third button positioned 120 pixels to the right of the second
    localparam btn3_y = 668;
    localparam btn3_width = 100;
    localparam btn3_height = 50;

    localparam central_btn_width = 120;
    localparam central_btn_height = 60;
    localparam central_btn_x = 422; // Position X for the central button (centered)
    localparam central_btn_y = 370; // Position Y for the central button (centered)

    localparam player1_btn_width = 160;
    localparam player1_btn_height = 60;
    localparam player1_btn_x = 150; // Position X for the central button (centered)
    localparam player1_btn_y = 370; // Position Y for the central button (centered)

    localparam player2_btn_width = 160;
    localparam player2_btn_height = 60;
    localparam player2_btn_y = 370; // Position X for the central button (centered)
    localparam player2_btn_x = 714; // Position Y for the central button (centered)
    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;

    /**
     * Internal logic
     */

    always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
            vga_btn_out.vcount   <= '0;
            vga_btn_out.vsync    <= '0;
            vga_btn_out.vblnk    <= '0;
            vga_btn_out.hcount   <= '0;
            vga_btn_out.hsync    <= '0;
            vga_btn_out.hblnk    <= '0;
            vga_btn_out.rgb      <= '0;
        end else begin
            vga_btn_out.vcount <=  vga_btn_in.vcount;
            vga_btn_out.vsync  <=  vga_btn_in.vsync;
            vga_btn_out.vblnk  <=  vga_btn_in.vblnk;
            vga_btn_out.hcount <=  vga_btn_in.hcount;
            vga_btn_out.hsync  <=  vga_btn_in.hsync;
            vga_btn_out.hblnk  <=  vga_btn_in.hblnk;
            vga_btn_out.rgb    <=  rgb_nxt;
        end
    end

    always_comb begin
        if ((vga_btn_in.hcount >= btn1_x) && (vga_btn_in.hcount < btn1_x + btn1_width) &&
                (vga_btn_in.vcount >= btn1_y) && (vga_btn_in.vcount < btn1_y + btn1_height)&&(state == 1)&&selected_player == 2'b01) begin
            rgb_nxt = 12'hF_0_0; // Button 1: Red

            if (vga_btn_in.hcount >= btn1_x + 11 && vga_btn_in.hcount <= btn1_x + 15 && vga_btn_in.vcount >= btn1_y + 5 && vga_btn_in.vcount <= btn1_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 11 && vga_btn_in.hcount <= btn1_x + 27 && vga_btn_in.vcount >= btn1_y + 5 && vga_btn_in.vcount <= btn1_y + 9)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 25 && vga_btn_in.hcount <= btn1_x + 29 && vga_btn_in.vcount >= btn1_y + 7 && vga_btn_in.vcount <= btn1_y + 43)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 11 && vga_btn_in.hcount <= btn1_x + 27 && vga_btn_in.vcount >= btn1_y + 41 && vga_btn_in.vcount <= btn1_y + 45)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= btn1_x + 31 && vga_btn_in.hcount <= btn1_x + 35 && vga_btn_in.vcount >= btn1_y + 5 && vga_btn_in.vcount <= btn1_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 31 && vga_btn_in.hcount <= btn1_x + 49 && vga_btn_in.vcount >= btn1_y + 5 && vga_btn_in.vcount <= btn1_y + 9)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 31 && vga_btn_in.hcount <= btn1_x + 49 && vga_btn_in.vcount >= btn1_y + 23 && vga_btn_in.vcount <= btn1_y + 27)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 31 && vga_btn_in.hcount <= btn1_x + 49 && vga_btn_in.vcount >= btn1_y + 41 && vga_btn_in.vcount <= btn1_y + 45)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= btn1_x + 51 && vga_btn_in.hcount <= btn1_x + 55 && vga_btn_in.vcount >= btn1_y + 7 && vga_btn_in.vcount <= btn1_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 65 && vga_btn_in.hcount <= btn1_x + 69 && vga_btn_in.vcount >= btn1_y + 7 && vga_btn_in.vcount <= btn1_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 53 && vga_btn_in.hcount <= btn1_x + 67 && vga_btn_in.vcount >= btn1_y + 5 && vga_btn_in.vcount <= btn1_y + 9)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 51 && vga_btn_in.hcount <= btn1_x + 67 && vga_btn_in.vcount >= btn1_y + 23 && vga_btn_in.vcount <= btn1_y + 27)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= btn1_x + 71 && vga_btn_in.hcount <= btn1_x + 75 && vga_btn_in.vcount >= btn1_y + 5 && vga_btn_in.vcount <= btn1_y + 43)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn1_x + 71 && vga_btn_in.hcount <= btn1_x + 89 && vga_btn_in.vcount >= btn1_y + 41 && vga_btn_in.vcount <= btn1_y + 45)
                rgb_nxt = 12'h0_0_0;
        end

        else if ((vga_btn_in.hcount >= btn2_x) && (vga_btn_in.hcount < btn2_x + btn2_width) &&
                (vga_btn_in.vcount >= btn2_y) && (vga_btn_in.vcount < btn2_y + btn2_height)&&(state == 2)) begin
            if(deal_wait_btn) begin
                rgb_nxt = 12'hA_A_A;
            end else
                rgb_nxt = 12'h0_0_F; // Button 2: Blue

            if (vga_btn_in.hcount >= btn2_x + 21 && vga_btn_in.hcount <= btn2_x + 25 && vga_btn_in.vcount >= btn2_y + 5 && vga_btn_in.vcount <= btn2_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn2_x + 35 && vga_btn_in.hcount <= btn2_x + 39 && vga_btn_in.vcount >= btn2_y + 5 && vga_btn_in.vcount <= btn2_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn2_x + 21 && vga_btn_in.hcount <= btn2_x + 39 && vga_btn_in.vcount >= btn2_y + 23 && vga_btn_in.vcount <= btn2_y + 27)
                rgb_nxt = 12'h0_0_0;


            else if (vga_btn_in.hcount >= btn2_x + 48 && vga_btn_in.hcount <= btn2_x + 52 && vga_btn_in.vcount >= btn2_y + 5 && vga_btn_in.vcount <= btn2_y + 45)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= btn2_x + 61 && vga_btn_in.hcount <= btn2_x + 79 && vga_btn_in.vcount >= btn2_y + 5 && vga_btn_in.vcount <= btn2_y + 9)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn2_x + 68 && vga_btn_in.hcount <= btn2_x + 72 && vga_btn_in.vcount >= btn2_y + 5 && vga_btn_in.vcount <= btn2_y + 45)
                rgb_nxt = 12'h0_0_0;
        end

        else if ((vga_btn_in.hcount >= btn3_x) && (vga_btn_in.hcount < btn3_x + btn3_width) &&
                (vga_btn_in.vcount >= btn3_y) && (vga_btn_in.vcount < btn3_y + btn3_height)&&(state == 2)) begin
            if(deal_wait_btn) begin
                rgb_nxt = 12'hA_A_A;
            end else begin
                rgb_nxt = 12'h0_F_0; // Button 3: Green
            end
            if (vga_btn_in.hcount >= btn3_x + 6 && vga_btn_in.hcount <= btn3_x + 22 && vga_btn_in.vcount >= btn3_y + 5 && vga_btn_in.vcount <= btn3_y + 9)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 6 && vga_btn_in.hcount <= btn3_x + 22 && vga_btn_in.vcount >= btn3_y + 23 && vga_btn_in.vcount <= btn3_y + 27)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 6 && vga_btn_in.hcount <= btn3_x + 22 && vga_btn_in.vcount >= btn3_y + 41 && vga_btn_in.vcount <= btn3_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 6 && vga_btn_in.hcount <= btn3_x + 10 && vga_btn_in.vcount >= btn3_y + 7 && vga_btn_in.vcount <= btn3_y + 23)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 18 && vga_btn_in.hcount <= btn3_x + 22 && vga_btn_in.vcount >= btn3_y + 27 && vga_btn_in.vcount <= btn3_y + 43)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= btn3_x + 24 && vga_btn_in.hcount <= btn3_x + 40 && vga_btn_in.vcount >= btn3_y + 5 && vga_btn_in.vcount <= btn3_y + 9)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 30 && vga_btn_in.hcount <= btn3_x + 34 && vga_btn_in.vcount >= btn3_y + 5 && vga_btn_in.vcount <= btn3_y + 45)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= btn3_x + 44 && vga_btn_in.hcount <= btn3_x + 54 && vga_btn_in.vcount >= btn3_y + 5 && vga_btn_in.vcount <= btn3_y + 9)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 44 && vga_btn_in.hcount <= btn3_x + 56 && vga_btn_in.vcount >= btn3_y + 23 && vga_btn_in.vcount <= btn3_y + 27)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 42 && vga_btn_in.hcount <= btn3_x + 46 && vga_btn_in.vcount >= btn3_y + 7 && vga_btn_in.vcount <= btn3_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 52 && vga_btn_in.hcount <= btn3_x + 56 && vga_btn_in.vcount >= btn3_y + 7 && vga_btn_in.vcount <= btn3_y + 45)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= btn3_x + 58 && vga_btn_in.hcount <= btn3_x + 62 && vga_btn_in.vcount >= btn3_y + 5 && vga_btn_in.vcount <= btn3_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 70 && vga_btn_in.hcount <= btn3_x + 74 && vga_btn_in.vcount >= btn3_y + 5 && vga_btn_in.vcount <= btn3_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 63 && vga_btn_in.hcount <= btn3_x + 66 && vga_btn_in.vcount >= btn3_y + 13 && vga_btn_in.vcount <= btn3_y + 16)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 67 && vga_btn_in.hcount <= btn3_x + 70 && vga_btn_in.vcount >= btn3_y + 17 && vga_btn_in.vcount <= btn3_y + 20)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 71 && vga_btn_in.hcount <= btn3_x + 74 && vga_btn_in.vcount >= btn3_y + 18 && vga_btn_in.vcount <= btn3_y + 21)
                rgb_nxt = 12'h0_0_0;


            else if (vga_btn_in.hcount >= btn3_x + 76 && vga_btn_in.hcount <= btn3_x + 80 && vga_btn_in.vcount >= btn3_y + 5 && vga_btn_in.vcount <= btn3_y + 45)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 88 && vga_btn_in.hcount <= btn3_x + 92 && vga_btn_in.vcount >= btn3_y + 7 && vga_btn_in.vcount <= btn3_y + 43)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 76 && vga_btn_in.hcount <= btn3_x + 90 && vga_btn_in.vcount >= btn3_y + 5 && vga_btn_in.vcount <= btn3_y + 9)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= btn3_x + 76 && vga_btn_in.hcount <= btn3_x + 90 && vga_btn_in.vcount >= btn3_y + 41 && vga_btn_in.vcount <= btn3_y + 45)
                rgb_nxt = 12'h0_0_0;
        end

        else if ((vga_btn_in.hcount >= central_btn_x) && (vga_btn_in.hcount < central_btn_x + central_btn_width) &&
                (vga_btn_in.vcount >= central_btn_y) && (vga_btn_in.vcount < central_btn_y + central_btn_height) && (state == 0 || state == 3 || state == 4 || state == 5)) begin
            if (!dealer_finished && state != 0) begin
                rgb_nxt = 12'hA_A_A;
            end else if (selected_player == 3)
                rgb_nxt = 12'hA_A_A;
            else
                rgb_nxt = 12'hF_7_2;
            if (vga_btn_in.hcount >= central_btn_x + 12 && vga_btn_in.hcount <= central_btn_x + 29 && vga_btn_in.vcount >= central_btn_y + 10 && vga_btn_in.vcount <= central_btn_y + 14)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 10 && vga_btn_in.hcount <= central_btn_x + 14 && vga_btn_in.vcount >= central_btn_y + 12 && vga_btn_in.vcount <= central_btn_y + 29)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 12 && vga_btn_in.hcount <= central_btn_x + 28 && vga_btn_in.vcount >= central_btn_y + 28 && vga_btn_in.vcount <= central_btn_y + 32)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 25 && vga_btn_in.hcount <= central_btn_x + 29 && vga_btn_in.vcount >= central_btn_y + 30 && vga_btn_in.vcount <= central_btn_y + 48)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 10 && vga_btn_in.hcount <= central_btn_x + 28 && vga_btn_in.vcount >= central_btn_y + 46 && vga_btn_in.vcount <= central_btn_y + 50)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= central_btn_x + 31 && vga_btn_in.hcount <= central_btn_x + 49 && vga_btn_in.vcount >= central_btn_y + 10 && vga_btn_in.vcount <= central_btn_y + 14)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 38 && vga_btn_in.hcount <= central_btn_x + 42 && vga_btn_in.vcount >= central_btn_y + 10 && vga_btn_in.vcount <= central_btn_y + 50)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= central_btn_x + 53 && vga_btn_in.hcount <= central_btn_x + 67 && vga_btn_in.vcount >= central_btn_y + 10 && vga_btn_in.vcount <= central_btn_y + 14)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 51 && vga_btn_in.hcount <= central_btn_x + 69 && vga_btn_in.vcount >= central_btn_y + 26 && vga_btn_in.vcount <= central_btn_y + 30)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 51 && vga_btn_in.hcount <= central_btn_x + 55 && vga_btn_in.vcount >= central_btn_y + 12 && vga_btn_in.vcount <= central_btn_y + 50)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 65 && vga_btn_in.hcount <= central_btn_x + 69 && vga_btn_in.vcount >= central_btn_y + 12 && vga_btn_in.vcount <= central_btn_y + 50)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= central_btn_x + 71 && vga_btn_in.hcount <= central_btn_x + 75 && vga_btn_in.vcount >= central_btn_y + 10 && vga_btn_in.vcount <= central_btn_y + 50)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 71 && vga_btn_in.hcount <= central_btn_x + 87 && vga_btn_in.vcount >= central_btn_y + 10 && vga_btn_in.vcount <= central_btn_y + 14)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 71 && vga_btn_in.hcount <= central_btn_x + 87 && vga_btn_in.vcount >= central_btn_y + 26 && vga_btn_in.vcount <= central_btn_y + 30)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 85 && vga_btn_in.hcount <= central_btn_x + 89 && vga_btn_in.vcount >= central_btn_y + 12 && vga_btn_in.vcount <= central_btn_y + 28)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 75 && vga_btn_in.hcount <= central_btn_x + 80 && vga_btn_in.vcount >= central_btn_y + 30 && vga_btn_in.vcount <= central_btn_y + 35)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 80 && vga_btn_in.hcount <= central_btn_x + 85 && vga_btn_in.vcount >= central_btn_y + 35 && vga_btn_in.vcount <= central_btn_y + 40)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 85 && vga_btn_in.hcount <= central_btn_x + 89 && vga_btn_in.vcount >= central_btn_y + 40 && vga_btn_in.vcount <= central_btn_y + 50)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= central_btn_x + 91 && vga_btn_in.hcount <= central_btn_x + 109 && vga_btn_in.vcount >= central_btn_y + 10 && vga_btn_in.vcount <= central_btn_y + 14)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= central_btn_x + 98 && vga_btn_in.hcount <= central_btn_x + 102 && vga_btn_in.vcount >= central_btn_y + 10 && vga_btn_in.vcount <= central_btn_y + 50)
                rgb_nxt = 12'h0_0_0;
        end
        else if ((vga_btn_in.hcount >= player1_btn_x) && (vga_btn_in.hcount < player1_btn_x + player1_btn_width) &&
                (vga_btn_in.vcount >= player1_btn_y) && (vga_btn_in.vcount < player1_btn_y  + player1_btn_height) && state == 6) begin
            rgb_nxt = 12'h4_3_F;
            if (vga_btn_in.vcount >= player1_btn_y + 10  &&  vga_btn_in.vcount  <= player1_btn_y + 50 && vga_btn_in.hcount >= player1_btn_x + 11 && vga_btn_in.hcount <= 15 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y  + 10 &&  vga_btn_in.vcount <= player1_btn_y + 14 && vga_btn_in.hcount >= player1_btn_x + 11 && vga_btn_in.hcount <= 27 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y  + 26 &&  vga_btn_in.vcount <= player1_btn_y + 30 && vga_btn_in.hcount >= player1_btn_x + 11 && vga_btn_in.hcount <= 27 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y  + 12 &&  vga_btn_in.vcount  <= player1_btn_y + 28 && vga_btn_in.hcount >= player1_btn_x + 25 && vga_btn_in.hcount <= 29 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.vcount >= player1_btn_y + 10 &&  vga_btn_in.vcount  <= player1_btn_y + 50 && vga_btn_in.hcount >= player1_btn_x + 31 && vga_btn_in.hcount <= 35 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 46 &&  vga_btn_in.vcount  <= player1_btn_y + 50 && vga_btn_in.hcount >= player1_btn_x + 31 && vga_btn_in.hcount <= 49 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;


            else if (vga_btn_in.vcount >= player1_btn_y + 12 &&  vga_btn_in.vcount  <= player1_btn_y + 50 && vga_btn_in.hcount >= player1_btn_x + 51 && vga_btn_in.hcount <= 55 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 12 &&  vga_btn_in.vcount  <= player1_btn_y + 50 && vga_btn_in.hcount >= player1_btn_x + 65 && vga_btn_in.hcount <= 69 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 10 &&  vga_btn_in.vcount  <= player1_btn_y + 14 && vga_btn_in.hcount >= player1_btn_x + 53 && vga_btn_in.hcount <= 67 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 26  &&  vga_btn_in.vcount  <= player1_btn_y + 30 && vga_btn_in.hcount >= player1_btn_x + 53 && vga_btn_in.hcount <= 67 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.vcount >= player1_btn_y + 30  &&  vga_btn_in.vcount  <= player1_btn_y + 50 && vga_btn_in.hcount >= player1_btn_x + 78 && vga_btn_in.hcount <= 82 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 25  &&  vga_btn_in.vcount  <= player1_btn_y + 29 && vga_btn_in.hcount >= player1_btn_x + 76 && vga_btn_in.hcount <= 80 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 10 &&  vga_btn_in.vcount  <= player1_btn_y + 25 && vga_btn_in.hcount >= player1_btn_x + 71 && vga_btn_in.hcount <= 75 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 10 &&  vga_btn_in.vcount  <= player1_btn_y + 25 && vga_btn_in.hcount >= player1_btn_x + 85 && vga_btn_in.hcount <= 89 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 25  &&  vga_btn_in.vcount  <= player1_btn_y + 29 && vga_btn_in.hcount >= player1_btn_x + 80 && vga_btn_in.hcount <= 84 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;


            else if (vga_btn_in.vcount >= player1_btn_y + 10 &&  vga_btn_in.vcount  <= player1_btn_y + 50 && vga_btn_in.hcount >= player1_btn_x + 91 && vga_btn_in.hcount <= 95 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 10 &&  vga_btn_in.vcount  <= player1_btn_y + 14 && vga_btn_in.hcount >= player1_btn_x + 91 && vga_btn_in.hcount <= 109 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 28 &&  vga_btn_in.vcount  <= player1_btn_y + 32 && vga_btn_in.hcount >= player1_btn_x + 91 && vga_btn_in.hcount <= 109 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player1_btn_y + 46 &&  vga_btn_in.vcount  <= player1_btn_y + 50 && vga_btn_in.hcount >= player1_btn_x + 91 && vga_btn_in.hcount <= 109 + player1_btn_x)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= player1_btn_x + 111 && vga_btn_in.hcount <= player1_btn_x + 115 && vga_btn_in.vcount >= player1_btn_y + 10 && vga_btn_in.vcount <= player1_btn_y + 50)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player1_btn_x + 111 && vga_btn_in.hcount <= player1_btn_x + 127 && vga_btn_in.vcount >= player1_btn_y + 10 && vga_btn_in.vcount <= player1_btn_y + 14)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player1_btn_x + 111 && vga_btn_in.hcount <= player1_btn_x + 127 && vga_btn_in.vcount >= player1_btn_y + 26 && vga_btn_in.vcount <= player1_btn_y + 30)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player1_btn_x + 125 && vga_btn_in.hcount <= player1_btn_x + 129 && vga_btn_in.vcount >= player1_btn_y + 12 && vga_btn_in.vcount <= player1_btn_y + 28)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player1_btn_x + 115 && vga_btn_in.hcount <= player1_btn_x + 120 && vga_btn_in.vcount >= player1_btn_y + 30 && vga_btn_in.vcount <= player1_btn_y + 35)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player1_btn_x + 120 && vga_btn_in.hcount <= player1_btn_x + 125 && vga_btn_in.vcount >= player1_btn_y + 35 && vga_btn_in.vcount <= player1_btn_y + 40)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player1_btn_x + 125 && vga_btn_in.hcount <= player1_btn_x + 129 && vga_btn_in.vcount >= player1_btn_y + 40 && vga_btn_in.vcount <= player1_btn_y + 50)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= player1_btn_x + 145 && vga_btn_in.hcount <= player1_btn_x + 149 && vga_btn_in.vcount >= player1_btn_y + 10 && vga_btn_in.vcount <= player1_btn_y + 50)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player1_btn_x + 140 && vga_btn_in.hcount <= player1_btn_x + 144 && vga_btn_in.vcount >= player1_btn_y + 15 && vga_btn_in.vcount <= player1_btn_y + 19)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player1_btn_x + 135 && vga_btn_in.hcount <= player1_btn_x + 139 && vga_btn_in.vcount >= player1_btn_y + 20 && vga_btn_in.vcount <= player1_btn_y + 24)
                rgb_nxt = 12'h0_0_0;

        end  else if ((vga_btn_in.hcount >= player2_btn_x) && (vga_btn_in.hcount < player2_btn_x + player2_btn_width) &&
                (vga_btn_in.vcount >= player2_btn_y) && (vga_btn_in.vcount < player2_btn_y + player2_btn_height) && state == 6) begin
            rgb_nxt = 12'h4_3_F;
            if (vga_btn_in.vcount >= player2_btn_y + 10  &&  vga_btn_in.vcount  <= player2_btn_y + 50 && vga_btn_in.hcount >= player2_btn_x + 11 && vga_btn_in.hcount <= 15 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y  + 10 &&  vga_btn_in.vcount <= player2_btn_y + 14 && vga_btn_in.hcount >= player2_btn_x + 11 && vga_btn_in.hcount <= 27 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y  + 26 &&  vga_btn_in.vcount <= player2_btn_y + 30 && vga_btn_in.hcount >= player2_btn_x + 11 && vga_btn_in.hcount <= 27 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y  + 12 &&  vga_btn_in.vcount  <= player2_btn_y + 28 && vga_btn_in.hcount >= player2_btn_x + 25 && vga_btn_in.hcount <= 29 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.vcount >= player2_btn_y + 10 &&  vga_btn_in.vcount  <= player2_btn_y + 50 && vga_btn_in.hcount >= player2_btn_x + 31 && vga_btn_in.hcount <= 35 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 46 &&  vga_btn_in.vcount  <= player2_btn_y + 50 && vga_btn_in.hcount >= player2_btn_x + 31 && vga_btn_in.hcount <= 49 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;


            else if (vga_btn_in.vcount >= player2_btn_y + 12 &&  vga_btn_in.vcount  <= player2_btn_y + 50 && vga_btn_in.hcount >= player2_btn_x + 51 && vga_btn_in.hcount <= 55 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 12 &&  vga_btn_in.vcount  <= player2_btn_y + 50 && vga_btn_in.hcount >= player2_btn_x + 65 && vga_btn_in.hcount <= 69 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 10 &&  vga_btn_in.vcount  <= player2_btn_y + 14 && vga_btn_in.hcount >= player2_btn_x + 53 && vga_btn_in.hcount <= 67 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 26  &&  vga_btn_in.vcount  <= player2_btn_y + 30 && vga_btn_in.hcount >= player2_btn_x + 53 && vga_btn_in.hcount <= 67 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.vcount >= player2_btn_y + 30  &&  vga_btn_in.vcount  <= player2_btn_y + 50 && vga_btn_in.hcount >= player2_btn_x + 78 && vga_btn_in.hcount <= 82 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 25  &&  vga_btn_in.vcount  <= player2_btn_y + 29 && vga_btn_in.hcount >= player2_btn_x + 76 && vga_btn_in.hcount <= 80 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 10 &&  vga_btn_in.vcount  <= player2_btn_y + 25 && vga_btn_in.hcount >= player2_btn_x + 71 && vga_btn_in.hcount <= 75 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 10 &&  vga_btn_in.vcount  <= player2_btn_y + 25 && vga_btn_in.hcount >= player2_btn_x + 85 && vga_btn_in.hcount <= 89 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 25  &&  vga_btn_in.vcount  <= player2_btn_y + 29 && vga_btn_in.hcount >= player2_btn_x + 80 && vga_btn_in.hcount <= 84 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;


            else if (vga_btn_in.vcount >= player2_btn_y + 10 &&  vga_btn_in.vcount  <= player2_btn_y + 50 && vga_btn_in.hcount >= player2_btn_x + 91 && vga_btn_in.hcount <= 95 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 10 &&  vga_btn_in.vcount  <= player2_btn_y + 14 && vga_btn_in.hcount >= player2_btn_x + 91 && vga_btn_in.hcount <= 109 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 28 &&  vga_btn_in.vcount  <= player2_btn_y + 32 && vga_btn_in.hcount >= player2_btn_x + 91 && vga_btn_in.hcount <= 109 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.vcount >= player2_btn_y + 46 &&  vga_btn_in.vcount  <= player2_btn_y + 50 && vga_btn_in.hcount >= player2_btn_x + 91 && vga_btn_in.hcount <= 109 + player2_btn_x)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= player2_btn_x + 111 && vga_btn_in.hcount <= player2_btn_x + 115 && vga_btn_in.vcount >= player2_btn_y + 10 && vga_btn_in.vcount <= player2_btn_y + 50)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 111 && vga_btn_in.hcount <= player2_btn_x + 127 && vga_btn_in.vcount >= player2_btn_y + 10 && vga_btn_in.vcount <= player2_btn_y + 14)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 111 && vga_btn_in.hcount <= player2_btn_x + 127 && vga_btn_in.vcount >= player2_btn_y + 26 && vga_btn_in.vcount <= player2_btn_y + 30)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 125 && vga_btn_in.hcount <= player2_btn_x + 129 && vga_btn_in.vcount >= player2_btn_y + 12 && vga_btn_in.vcount <= player2_btn_y + 28)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 115 && vga_btn_in.hcount <= player2_btn_x + 120 && vga_btn_in.vcount >= player2_btn_y + 30 && vga_btn_in.vcount <= player2_btn_y + 35)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 120 && vga_btn_in.hcount <= player2_btn_x + 125 && vga_btn_in.vcount >= player2_btn_y + 35 && vga_btn_in.vcount <= player2_btn_y + 40)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 125 && vga_btn_in.hcount <= player2_btn_x + 129 && vga_btn_in.vcount >= player2_btn_y + 40 && vga_btn_in.vcount <= player2_btn_y + 50)
                rgb_nxt = 12'h0_0_0;

            else if (vga_btn_in.hcount >= player2_btn_x + 131 && vga_btn_in.hcount <= player2_btn_x + 147 && vga_btn_in.vcount >= player2_btn_y + 10 && vga_btn_in.vcount <= player2_btn_y + 14)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 133 && vga_btn_in.hcount <= player2_btn_x + 147 && vga_btn_in.vcount >= player2_btn_y + 28 && vga_btn_in.vcount <= player2_btn_y + 32)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 133 && vga_btn_in.hcount <= player2_btn_x + 149 && vga_btn_in.vcount >= player2_btn_y + 46 && vga_btn_in.vcount <= player2_btn_y + 50)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 131 && vga_btn_in.hcount <= player2_btn_x + 135 && vga_btn_in.vcount >= player2_btn_y + 30 && vga_btn_in.vcount <= player2_btn_y + 48)
                rgb_nxt = 12'h0_0_0;
            else if (vga_btn_in.hcount >= player2_btn_x + 145 && vga_btn_in.hcount <= player2_btn_x + 149 && vga_btn_in.vcount >= player2_btn_y + 12 && vga_btn_in.vcount  <= player2_btn_y + 30)
                rgb_nxt = 12'h0_0_0;

        end else begin
            rgb_nxt = vga_btn_in.rgb;
        end
    end



endmodule