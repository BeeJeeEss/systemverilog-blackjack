/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Konrad Sawina, Borys Strzeboński
 * Description:
 * Timing module
 */

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
        if (vga_tim.hcount == 1343) begin
            hcount_nxt = '0;
            if (vga_tim.vcount == 805)
                vcount_nxt = '0;
            else
                vcount_nxt = vga_tim.vcount + 1;
        end
        else begin
            hcount_nxt = vga_tim.hcount + 1;
            vcount_nxt = vga_tim.vcount;
        end

        hblnk_nxt = (hcount_nxt >= HBLANK_START && hcount_nxt <= HBLANK_STOP - 1);
        hsync_nxt = (hcount_nxt >= HSYNC_START && hcount_nxt <= HSYNC_STOP - 1);
        vblnk_nxt = (vcount_nxt >= VBLANK_START && vcount_nxt <= VBLANK_STOP - 1);
        vsync_nxt = (vcount_nxt >= VSYNC_START && vcount_nxt <= VSYNC_STOP - 1);
    end

endmodule