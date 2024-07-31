  /**
   * Author: Borys Strzebonski
   *
   * Description:
   * Draw buttons with texts DEAL, HIT, and STAND. Buttons depend on input 'state'.
   */

  `timescale 1 ns / 1 ps

module draw_buttons (
        input  logic clk,
        input  logic rst,

        vga_if.out vga_btn_out,
        vga_if.in vga_btn_in
    );

    import vga_pkg::*;
    `include "letters_bitmap.sv"

    // Parameters for button positions and sizes
    localparam btn1_x = 100;
    localparam btn1_y = 400;

    localparam btn2_x = 300;
    localparam btn2_y = 400;

    localparam btn3_x = 500;
    localparam btn3_y = 400;

    localparam btn_width = 100;
    localparam btn_height = 50;

    // Scaling factor for the letters
    localparam scale_factor = 3;
    localparam letter_spacing = 1;

    // Position of the text within the buttons
    localparam letter_width = 5 * scale_factor + letter_spacing;
    localparam text_offset_y = 15;

    // Calculate horizontal offset for centering text
    localparam text1_width = 4 * letter_width - letter_spacing; // Width of "DEAL"
    localparam text2_width = 3 * letter_width - letter_spacing; // Width of "HIT"
    localparam text3_width = 5 * letter_width - letter_spacing; // Width of "STAND"

    localparam text1_offset_x = (btn_width - text1_width) / 2;
    localparam text2_offset_x = (btn_width - text2_width) / 2;
    localparam text3_offset_x = (btn_width - text3_width) / 2;

    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;
    logic state;

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
        state = 1;
        if (vga_btn_in.vblnk || vga_btn_in.hblnk) begin
            rgb_nxt = 12'h0_0_0;
        end else begin
            // Draw the buttons
            if ((vga_btn_in.hcount >= btn1_x) && (vga_btn_in.hcount < btn1_x + btn_width) &&
                    (vga_btn_in.vcount >= btn1_y) && (vga_btn_in.vcount < btn1_y + btn_height)&&(state != 0)) begin
                // Draw Button 1: Red
                // Draw letters DEAL
                if ((vga_btn_in.hcount >= btn1_x + text1_offset_x) && (vga_btn_in.hcount < btn1_x + text1_offset_x + text1_width) &&
                        (vga_btn_in.vcount >= btn1_y + text_offset_y) && (vga_btn_in.vcount < btn1_y + text_offset_y + (7 * scale_factor))) begin
                    automatic int char_index = (vga_btn_in.hcount - btn1_x - text1_offset_x) / (5 * scale_factor + letter_spacing);
                    logic [6:0][4:0] current_char;
                    case (char_index)
                        0: current_char = letter_D;
                        1: current_char = letter_E;
                        2: current_char = letter_A;
                        3: current_char = letter_L;
                        default: current_char = letter_A; // Default to 'A' if out of range
                    endcase
                    if (current_char[6 - (vga_btn_in.vcount - btn1_y - text_offset_y) / scale_factor][((vga_btn_in.hcount - btn1_x - text1_offset_x) % (5 * scale_factor + letter_spacing)) / scale_factor])
                        rgb_nxt = 12'hF_F_F; // White text
                    else
                        rgb_nxt = 12'hF_0_0; // Red button background
                end else
                    rgb_nxt = 12'hF_0_0; // Red button background
            end else if ((vga_btn_in.hcount >= btn2_x) && (vga_btn_in.hcount < btn2_x + btn_width) &&
                    (vga_btn_in.vcount >= btn2_y) && (vga_btn_in.vcount < btn2_y + btn_height)&&(state == 1)) begin
                // Draw Button 2: Blue
                // Draw letters HIT
                if ((vga_btn_in.hcount >= btn2_x + text2_offset_x) && (vga_btn_in.hcount < btn2_x + text2_offset_x + text2_width) &&
                        (vga_btn_in.vcount >= btn2_y + text_offset_y) && (vga_btn_in.vcount < btn2_y + text_offset_y + (7 * scale_factor))) begin
                    automatic int char_index = (vga_btn_in.hcount - btn2_x - text2_offset_x) / (5 * scale_factor + letter_spacing);
                    logic [6:0][4:0] current_char;
                    case (char_index)
                        0: current_char = letter_H;
                        1: current_char = letter_I;
                        2: current_char = letter_T;
                        default: current_char = letter_H; // Default to 'H' if out of range
                    endcase
                    if (current_char[6 - (vga_btn_in.vcount - btn2_y - text_offset_y) / scale_factor][((vga_btn_in.hcount - btn2_x - text2_offset_x) % (5 * scale_factor + letter_spacing)) / scale_factor])
                        rgb_nxt = 12'hF_F_F; // White text
                    else
                        rgb_nxt = 12'h0_0_F; // Blue button background
                end else
                    rgb_nxt = 12'h0_0_F; // Blue button background
            end else if ((vga_btn_in.hcount >= btn3_x) && (vga_btn_in.hcount < btn3_x + btn_width) &&
                    (vga_btn_in.vcount >= btn3_y) && (vga_btn_in.vcount < btn3_y + btn_height)&&(state == 1)) begin
                // Draw Button 3: Green
                // Draw letters STAND
                if ((vga_btn_in.hcount >= btn3_x + text3_offset_x) && (vga_btn_in.hcount < btn3_x + text3_offset_x + text3_width) &&
                        (vga_btn_in.vcount >= btn3_y + text_offset_y) && (vga_btn_in.vcount < btn3_y + text_offset_y + (7 * scale_factor))) begin
                    automatic int char_index = (vga_btn_in.hcount - btn3_x - text3_offset_x) / (5 * scale_factor + letter_spacing);
                    logic [6:0][4:0] current_char;
                    case (char_index)
                        0: current_char = letter_S;
                        1: current_char = letter_T;
                        2: current_char = letter_A;
                        3: current_char = letter_N;
                        4: current_char = letter_D;
                        default: current_char = letter_S; // Default to 'S' if out of range
                    endcase
                    if (current_char[6 - (vga_btn_in.vcount - btn3_y - text_offset_y) / scale_factor][((vga_btn_in.hcount - btn3_x - text3_offset_x) % (5 * scale_factor + letter_spacing)) / scale_factor])
                        rgb_nxt = 12'hF_F_F; // White text
                    else
                        rgb_nxt = 12'h0_F_0; // Green button background
                end else
                    rgb_nxt = 12'h0_F_0; // Green button background
            end else begin
                // The rest of active display pixels:
                rgb_nxt = vga_btn_in.rgb;
            end
        end
    end

endmodule
