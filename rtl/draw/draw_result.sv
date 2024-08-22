/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Authors: Konrad Sawina, Borys Strzeboński
 * Description:
 * Module responsible for drawing result writing.
 */

module draw_result (
        input  logic clk,
        input  logic rst,
        input  logic [2:0] state,

        vga_if.out vga_result_out,
        vga_if.in  vga_result_in
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
            vga_result_out.vcount   <= '0;
            vga_result_out.vsync    <= '0;
            vga_result_out.vblnk    <= '0;
            vga_result_out.hcount   <= '0;
            vga_result_out.hsync    <= '0;
            vga_result_out.hblnk    <= '0;
            vga_result_out.rgb      <= '0;
        end else begin
            vga_result_out.vcount <=  vga_result_in.vcount;
            vga_result_out.vsync  <=  vga_result_in.vsync;
            vga_result_out.vblnk  <=  vga_result_in.vblnk;
            vga_result_out.hcount <=  vga_result_in.hcount;
            vga_result_out.hsync  <=  vga_result_in.hsync;
            vga_result_out.hblnk  <=  vga_result_in.hblnk;
            vga_result_out.rgb    <=  rgb_nxt;
        end
    end


    localparam xpos = 500;
    localparam ypos = 234;

    always_comb begin
        rgb_nxt = vga_result_in.rgb;
        case (state)
            3'b011: begin

                if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 185 + ypos && vga_result_in.hcount >= 100 + xpos && vga_result_in.hcount <= 115 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 185 + ypos && vga_result_in.hcount >= 145 + xpos && vga_result_in.hcount <= 160 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 110 + xpos && vga_result_in.hcount <= 125 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 170 + ypos &&  vga_result_in.vcount <= 185 + ypos && vga_result_in.hcount >= 125 + xpos && vga_result_in.hcount <= 135 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 135 + xpos && vga_result_in.hcount <= 150 + xpos)
                    rgb_nxt = 12'hf_a_5;


                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 190 + xpos && vga_result_in.hcount <= 205 + xpos)
                    rgb_nxt = 12'hf_a_5;

                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 230 + xpos && vga_result_in.hcount <= 245 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 275 + xpos && vga_result_in.hcount <= 290 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 120 + ypos &&  vga_result_in.vcount <= 135 + ypos && vga_result_in.hcount >= 245 + xpos && vga_result_in.hcount <= 255 + xpos)
                    rgb_nxt = 12'hf_a_5;

                else if (vga_result_in.vcount >= 135 + ypos &&  vga_result_in.vcount <= 150 + ypos && vga_result_in.hcount >= 255 + xpos && vga_result_in.hcount <= 265 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 150 + ypos &&  vga_result_in.vcount <= 165 + ypos && vga_result_in.hcount >= 265 + xpos && vga_result_in.hcount <= 280 + xpos)
                    rgb_nxt = 12'hf_a_5;
            end
            3'b100: begin
                if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 100 + xpos && vga_result_in.hcount <= 115 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 100 + xpos && vga_result_in.hcount <= 160 + xpos)
                    rgb_nxt = 12'hf_a_5;

                else if (vga_result_in.vcount >= 105 + ypos &&  vga_result_in.vcount <= 195 + ypos && vga_result_in.hcount >= 165 + xpos && vga_result_in.hcount <= 180 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 105 + ypos &&  vga_result_in.vcount <= 195 + ypos && vga_result_in.hcount >= 210 + xpos && vga_result_in.hcount <= 225 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 115 + ypos && vga_result_in.hcount >= 170 + xpos && vga_result_in.hcount <= 220 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 170 + xpos && vga_result_in.hcount <= 220 + xpos)
                    rgb_nxt = 12'hf_a_5;

                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 230 + xpos && vga_result_in.hcount <= 285 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 115 + ypos && vga_result_in.hcount >= 235 + xpos && vga_result_in.hcount <= 290 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 140 + ypos &&  vga_result_in.vcount <= 155 + ypos && vga_result_in.hcount >= 235 + xpos && vga_result_in.hcount <= 285 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 105 + ypos &&  vga_result_in.vcount <= 150 + ypos && vga_result_in.hcount >= 230 + xpos && vga_result_in.hcount <= 245 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 150 + ypos &&  vga_result_in.vcount <= 195 + ypos && vga_result_in.hcount >= 275 + xpos && vga_result_in.hcount <= 290 + xpos)
                    rgb_nxt = 12'hf_a_5;

                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 295 + xpos && vga_result_in.hcount <= 310 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 115 + ypos && vga_result_in.hcount >= 295 + xpos && vga_result_in.hcount <= 355 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 140 + ypos &&  vga_result_in.vcount <= 155 + ypos && vga_result_in.hcount >= 295 + xpos && vga_result_in.hcount <= 355 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 295 + xpos && vga_result_in.hcount <= 355 + xpos)
                    rgb_nxt = 12'hf_a_5;
            end
            3'b101: begin
                if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 100 + xpos && vga_result_in.hcount <= 115 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 115 + ypos && vga_result_in.hcount >= 100 + xpos && vga_result_in.hcount <= 155 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 100 + xpos && vga_result_in.hcount <= 155 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 105 + ypos &&  vga_result_in.vcount <= 195 + ypos && vga_result_in.hcount >= 145 + xpos && vga_result_in.hcount <= 160 + xpos)
                    rgb_nxt = 12'hf_a_5;

                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 165 + xpos && vga_result_in.hcount <= 180 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 105 + ypos &&  vga_result_in.vcount <= 150 + ypos && vga_result_in.hcount >= 210 + xpos && vga_result_in.hcount <= 225 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 140 + ypos &&  vga_result_in.vcount <= 155 + ypos && vga_result_in.hcount >= 165 + xpos && vga_result_in.hcount <= 220 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 115 + ypos && vga_result_in.hcount >= 165 + xpos && vga_result_in.hcount <= 220 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 155 + ypos &&  vga_result_in.vcount <= 170 + ypos && vga_result_in.hcount >= 180 + xpos && vga_result_in.hcount <= 195 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 170 + ypos &&  vga_result_in.vcount <= 185 + ypos && vga_result_in.hcount >= 195 + xpos && vga_result_in.hcount <= 210 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 210 + xpos && vga_result_in.hcount <= 225 + xpos)
                    rgb_nxt = 12'hf_a_5;


                else if (vga_result_in.vcount >= 105 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 230 + xpos && vga_result_in.hcount <= 245 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 105 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 275 + xpos && vga_result_in.hcount <= 290 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 140 + ypos &&  vga_result_in.vcount <= 155 + ypos && vga_result_in.hcount >= 235 + xpos && vga_result_in.hcount <= 285 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 115 + ypos && vga_result_in.hcount >= 235 + xpos && vga_result_in.hcount <= 285 + xpos)
                    rgb_nxt = 12'hf_a_5;

                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 185 + ypos && vga_result_in.hcount >= 295 + xpos && vga_result_in.hcount <= 310 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 100 + ypos &&  vga_result_in.vcount <= 185 + ypos && vga_result_in.hcount >= 340 + xpos && vga_result_in.hcount <= 355 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 305 + xpos && vga_result_in.hcount <= 320 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 170 + ypos &&  vga_result_in.vcount <= 185 + ypos && vga_result_in.hcount >= 320 + xpos && vga_result_in.hcount <= 330 + xpos)
                    rgb_nxt = 12'hf_a_5;
                else if (vga_result_in.vcount >= 185 + ypos &&  vga_result_in.vcount <= 200 + ypos && vga_result_in.hcount >= 330 + xpos && vga_result_in.hcount <= 345 + xpos)
                    rgb_nxt = 12'hf_a_5;
            end
            default :
                rgb_nxt = vga_result_in.rgb;
        endcase
    end







endmodule