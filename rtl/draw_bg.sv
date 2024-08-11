 /**
  * Copyright (C) 2023  AGH University of Science and Technology
  * MTM UEC2
  * Author: Piotr Kaczmarczyk
  *
  * Description:
  * Draw background.
  */

 `timescale 1 ns / 1 ps

module draw_bg (
        input  logic clk,
        input  logic rst,

        vga_if.out vga_bg_out,
        vga_if.in vga_bg_in
    );

    import vga_pkg::*;

    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;

    /**
     * Internal logic
     */

    always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
            vga_bg_out.vcount   <= '0;
            vga_bg_out.vsync    <= '0;
            vga_bg_out.vblnk    <= '0;
            vga_bg_out.hcount   <= '0;
            vga_bg_out.hsync    <= '0;
            vga_bg_out.hblnk    <= '0;
            vga_bg_out.rgb      <= '0;
        end else begin
            vga_bg_out.vcount <=  vga_bg_in.vcount;
            vga_bg_out.vsync  <=  vga_bg_in.vsync;
            vga_bg_out.vblnk  <=  vga_bg_in.vblnk;
            vga_bg_out.hcount <=  vga_bg_in.hcount;
            vga_bg_out.hsync  <=  vga_bg_in.hsync;
            vga_bg_out.hblnk  <=  vga_bg_in.hblnk;
            vga_bg_out.rgb    <=  rgb_nxt;
        end
    end

    always_comb begin : bg_comb_blk
        if (vga_bg_in.vblnk || vga_bg_in.hblnk) begin  // Blanking region:
            rgb_nxt = 12'h0_0_0;                       // - make it black.
        end else begin                                 // Active region:
            // Draw the green table background
            if ((vga_bg_in.hcount > 100) && (vga_bg_in.hcount < 924) &&
                    (vga_bg_in.vcount > 100) && (vga_bg_in.vcount < 668)) begin
                rgb_nxt = 12'h0_a_0;                   // Green table
            end
            // Decorate the edges with gold
            else if (vga_bg_in.vcount < 20 || vga_bg_in.vcount > (VER_PIXELS - 20) ||
                    vga_bg_in.hcount < 20 || vga_bg_in.hcount > (HOR_PIXELS - 20)) begin
                rgb_nxt = 12'hf_a_5;                   // Gold border
            end
            else begin
                rgb_nxt = 12'h0_8_0;                   // Darker green for the rest of the table
            end
        end
    end

endmodule