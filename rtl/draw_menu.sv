  /**
   * Copyright (C) 2023  AGH University of Science and Technology
   * MTM UEC2
   * Author: Piotr Kaczmarczyk
   *
   * Description:
   * Draw background.
   */

  `timescale 1 ns / 1 ps

module draw_menu (
        input  logic clk,
        input  logic rst,
        input  logic [2:0] state,

        vga_if.out vga_menu_out,
        vga_if.in vga_menu_in
    );

    import vga_pkg::*;

    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;

    localparam xpos = 122;
    localparam ypos = 0;

    /**
     * Internal logic
     */

    always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
            vga_menu_out.vcount   <= '0;
            vga_menu_out.vsync    <= '0;
            vga_menu_out.vblnk    <= '0;
            vga_menu_out.hcount   <= '0;
            vga_menu_out.hsync    <= '0;
            vga_menu_out.hblnk    <= '0;
            vga_menu_out.rgb      <= '0;
        end else begin
            vga_menu_out.vcount <=  vga_menu_in.vcount;
            vga_menu_out.vsync  <=  vga_menu_in.vsync;
            vga_menu_out.vblnk  <=  vga_menu_in.vblnk;
            vga_menu_out.hcount <=  vga_menu_in.hcount;
            vga_menu_out.hsync  <=  vga_menu_in.hsync;
            vga_menu_out.hblnk  <=  vga_menu_in.hblnk;
            if (state == 0)
                vga_menu_out.rgb    <=  rgb_nxt;
            else
                vga_menu_out.rgb    <=  vga_menu_in.rgb ;
        end
    end

    always_comb begin : bg_comb_blk
        if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 100 + xpos && vga_menu_in.hcount <= 115 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 115 + ypos && vga_menu_in.hcount >= 100 + xpos && vga_menu_in.hcount <= 155 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 185 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 100 + xpos && vga_menu_in.hcount <= 155 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 105 + ypos &&  vga_menu_in.vcount <= 145 + ypos && vga_menu_in.hcount >= 145 + xpos && vga_menu_in.hcount <= 160 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 155 + ypos &&  vga_menu_in.vcount <= 195 + ypos && vga_menu_in.hcount >= 145 + xpos && vga_menu_in.hcount <= 160 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 140 + ypos &&  vga_menu_in.vcount <= 155 + ypos && vga_menu_in.hcount >= 100 + xpos && vga_menu_in.hcount <= 155 + xpos)
            rgb_nxt = 12'hf_a_5;



        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 165 + xpos && vga_menu_in.hcount <= 180 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 185 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 165 + xpos && vga_menu_in.hcount <= 225 + xpos)
            rgb_nxt = 12'hf_a_5;

        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 230 + xpos && vga_menu_in.hcount <= 245 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 275 + xpos && vga_menu_in.hcount <= 290 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 140 + ypos &&  vga_menu_in.vcount <= 155 + ypos && vga_menu_in.hcount >= 230 + xpos && vga_menu_in.hcount <= 290 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 115 + ypos && vga_menu_in.hcount >= 230 + xpos && vga_menu_in.hcount <= 290 + xpos)
            rgb_nxt = 12'hf_a_5;

        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 295 + xpos && vga_menu_in.hcount <= 310 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 115 + ypos && vga_menu_in.hcount >= 295 + xpos && vga_menu_in.hcount <= 355 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 185 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 295 + xpos && vga_menu_in.hcount <= 355 + xpos)
            rgb_nxt = 12'hf_a_5;

        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 360 + xpos && vga_menu_in.hcount <= 375 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 150 + ypos &&  vga_menu_in.vcount <= 165 + ypos && vga_menu_in.hcount >= 375 + xpos && vga_menu_in.hcount <= 390 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 165 + ypos &&  vga_menu_in.vcount <= 180 + ypos && vga_menu_in.hcount >= 390 + xpos && vga_menu_in.hcount <= 405 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 180 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 405 + xpos && vga_menu_in.hcount <= 420 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 135 + ypos &&  vga_menu_in.vcount <= 150 + ypos && vga_menu_in.hcount >= 375 + xpos && vga_menu_in.hcount <= 390 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 120 + ypos &&  vga_menu_in.vcount <= 135 + ypos && vga_menu_in.hcount >= 390 + xpos && vga_menu_in.hcount <= 405 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 120 + ypos && vga_menu_in.hcount >= 405 + xpos && vga_menu_in.hcount <= 420 + xpos)
            rgb_nxt = 12'hf_a_5;

        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 115 + ypos && vga_menu_in.hcount >= 425 + xpos && vga_menu_in.hcount <= 485 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 470 + xpos && vga_menu_in.hcount <= 485 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 185 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 430 + xpos && vga_menu_in.hcount <= 485 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 170 + ypos &&  vga_menu_in.vcount <= 195 + ypos && vga_menu_in.hcount >= 425 + xpos && vga_menu_in.hcount <= 440 + xpos)
            rgb_nxt = 12'hf_a_5;

        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 490 + xpos && vga_menu_in.hcount <= 505 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 535 + xpos && vga_menu_in.hcount <= 550 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 140 + ypos &&  vga_menu_in.vcount <= 155 + ypos && vga_menu_in.hcount >= 490 + xpos && vga_menu_in.hcount <= 550 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 115 + ypos && vga_menu_in.hcount >= 490 + xpos && vga_menu_in.hcount <= 550 + xpos)
            rgb_nxt = 12'hf_a_5;

        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 555 + xpos && vga_menu_in.hcount <= 570 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 115 + ypos && vga_menu_in.hcount >= 555 + xpos && vga_menu_in.hcount <= 615 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 185 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 555 + xpos && vga_menu_in.hcount <= 615 + xpos)
            rgb_nxt = 12'hf_a_5;


        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 620 + xpos && vga_menu_in.hcount <= 635 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 150 + ypos &&  vga_menu_in.vcount <= 165 + ypos && vga_menu_in.hcount >= 635 + xpos && vga_menu_in.hcount <= 650 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 165 + ypos &&  vga_menu_in.vcount <= 180 + ypos && vga_menu_in.hcount >= 650 + xpos && vga_menu_in.hcount <= 665 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 180 + ypos &&  vga_menu_in.vcount <= 200 + ypos && vga_menu_in.hcount >= 665 + xpos && vga_menu_in.hcount <= 680 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 135 + ypos &&  vga_menu_in.vcount <= 150 + ypos && vga_menu_in.hcount >= 635 + xpos && vga_menu_in.hcount <= 650 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 120 + ypos &&  vga_menu_in.vcount <= 135 + ypos && vga_menu_in.hcount >= 650 + xpos && vga_menu_in.hcount <= 665 + xpos)
            rgb_nxt = 12'hf_a_5;
        else if (vga_menu_in.vcount >= 100 + ypos &&  vga_menu_in.vcount <= 120 + ypos && vga_menu_in.hcount >= 665 + xpos && vga_menu_in.hcount <= 680 + xpos)
            rgb_nxt = 12'hf_a_5;
        else
            rgb_nxt = vga_menu_in.rgb;
    end


endmodule