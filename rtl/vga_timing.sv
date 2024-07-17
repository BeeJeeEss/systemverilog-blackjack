  /**
   * Copyright (C) 2023  AGH University of Science and Technology
   * MTM UEC2
   * Author: Piotr Kaczmarczyk
   *
   * Description:
   * Vga timing controller.
   */

   `timescale 1 ns / 1 ps

   module vga_timing (
           input  logic clk,
           input  logic rst,
           vga_if.out vga_tim
   
       );
   
       import vga_pkg::*;
   
   
       /**
        * Local variables and signals
        */
   
       // Add your signals and variables here.
       logic [10:0] hcount_nxt;
       logic [10:0] vcount_nxt;
       logic hblnk_nxt;
       logic vblnk_nxt;
       logic hsync_nxt;
       logic vsync_nxt;
   
   
       /**
        * Internal logic
        */
       always_ff@(posedge clk) begin
           if (rst) begin
               vga_tim.hcount <= 11'b0;
               vga_tim.vcount <= 11'b0;
               vga_tim.hblnk <= 1'b0;
               vga_tim.vblnk <= 1'b0;
               vga_tim.hsync <= 1'b0;
               vga_tim.vsync <= 1'b0;
           end
           else begin
               vga_tim.hcount <= hcount_nxt;
               vga_tim.vcount <= vcount_nxt;
               vga_tim.hblnk <= hblnk_nxt;
               vga_tim.vblnk <= vblnk_nxt;
               vga_tim.hsync <= hsync_nxt;
               vga_tim.vsync <= vsync_nxt;
           end
       end
       always_comb begin
           if (vga_tim.hcount == H_MAX - 1) begin
               if (vga_tim.vcount == V_MAX - 1) begin
                   vcount_nxt=11'b0;
               end
               else begin
                   vcount_nxt = vga_tim.vcount + 1;
               end
               hcount_nxt=11'b0;
           end
           else begin
               hcount_nxt = vga_tim.hcount + 1;
               vcount_nxt = vga_tim.vcount;
           end
   
           if (hcount_nxt >= HOR_BLANK_START) begin
               hblnk_nxt = 1'b1;
           end
           else begin
               hblnk_nxt = 1'b0;
           end
   
           if((hcount_nxt >= HOR_SYNC_START) && (hcount_nxt <= HOR_SYNC_STOP)) begin
               hsync_nxt = 1'b1;
           end
           else begin
               hsync_nxt = 1'b0;
           end
           if (vcount_nxt > VER_BLANK_START) begin
               vblnk_nxt = 1'b1;
           end
           else begin
               vblnk_nxt = 1'b0;
           end
   
           if((vcount_nxt > VER_SYNC_START) && (vcount_nxt < VER_SYNC_STOP)) begin
               vsync_nxt = 1'b1;
           end
           else begin
               vsync_nxt = 1'b0;
           end
       end
   
   
   endmodule