 /**
  * Copyright (C) 2023  AGH University of Science and Technology
  * MTM UEC2
  * Author: Piotr Kaczmarczyk
  *
  * Description:
  * Draw background with three rectangular buttons at the bottom of the screen.
  */

 `timescale 1 ns / 1 ps

module draw_buttons (
        input  logic clk,
        input  logic rst,
        input  logic [2:0] state,

        vga_if.out vga_btn_out,
        vga_if.in vga_btn_in
    );

    import vga_pkg::*;

    // Parameters for button positions and sizes
    parameter int btn1_x = 100;
    parameter int btn1_y = 400;
    parameter int btn1_width = 100;
    parameter int btn1_height = 50;

    parameter int btn2_x = 300;
    parameter int btn2_y = 400;
    parameter int btn2_width = 100;
    parameter int btn2_height = 50;

    // Adding third button parameters
    parameter int btn3_x = 500;
    parameter int btn3_y = 400;
    parameter int btn3_width = 100;
    parameter int btn3_height = 50;

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

    always_comb begin : bg_comb_blk
        // Draw the buttons
        if ((vga_btn_in.hcount >= btn1_x) && (vga_btn_in.hcount < btn1_x + btn1_width) &&
                (vga_btn_in.vcount >= btn1_y) && (vga_btn_in.vcount < btn1_y + btn1_height)&&(state == 0)) begin
            rgb_nxt = 12'hF_0_0; // Button 1: Red
        end else if ((vga_btn_in.hcount >= btn2_x) && (vga_btn_in.hcount < btn2_x + btn2_width) &&
                (vga_btn_in.vcount >= btn2_y) && (vga_btn_in.vcount < btn2_y + btn2_height)&&(state == 1)) begin
            rgb_nxt = 12'h0_0_F; // Button 2: Blue
        end else if ((vga_btn_in.hcount >= btn3_x) && (vga_btn_in.hcount < btn3_x + btn3_width) &&
                (vga_btn_in.vcount >= btn3_y) && (vga_btn_in.vcount < btn3_y + btn3_height)&&(state == 1)) begin
            rgb_nxt = 12'h0_F_0; // Button 3: Green
        end else begin                              // The rest of active display pixels:
            rgb_nxt = vga_btn_in.rgb;                 // - fill with gray.
        end
    end



endmodule
