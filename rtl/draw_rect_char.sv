`timescale 1ns / 1ps

module draw_rect_char(
        input logic clk,
        input logic rst,
        vga_if.in cifi,
        vga_if.out cifo,
        input logic [0:7] char_pixels,
        output logic [7:0] char_xy,
        output logic [3:0] char_line
    );

    import vga_pkg ::*;
    vga_if wire_cd();
    wire [11:0] delayed_rgb;
    wire [3:0] delayed_char_line;
    logic [7:0] char_xy_nxt;
    logic [3:0] char_line_nxt;
    logic [11:0] rgb_nxt;
    logic [10:0] hcount_var;

    delay #(
        .WIDTH(12),
        .CLK_DEL(3)
    )
    u_rgb_delay(
        .din(cifi.rgb),
        .clk,
        .rst,
        .dout(delayed_rgb)
    );

    delay #(
        .WIDTH(4),
        .CLK_DEL(1)
    )
    u_char_line_delay(
        .din(char_line_nxt),
        .clk,
        .rst,
        .dout(delayed_char_line)
    );

    delay #(
        .WIDTH(26),
        .CLK_DEL(3)
    )
    u_char_delay(
        .din({cifi.hcount, cifi.vcount, cifi.hsync, cifi.vsync, cifi.hblnk, cifi.vblnk}),
        .clk(clk),
        .rst,
        .dout({wire_cd.hcount, wire_cd.vcount, wire_cd.hblnk, wire_cd.hsync, wire_cd.vblnk, wire_cd.vsync})
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            cifo.hsync <= '0;
            cifo.vsync <= '0;
            cifo.hblnk <= '0;
            cifo.vblnk <= '0;
            cifo.hcount <= '0;
            cifo.vcount <= '0;
            cifo.rgb <= '0;
            char_xy <= '0;
            char_line <= '0;
        end
        else begin
            cifo.hsync <= wire_cd.hsync;
            cifo.vsync <= wire_cd.vsync;
            cifo.hblnk <= wire_cd.hblnk;
            cifo.vblnk <= wire_cd.vblnk;
            cifo.hcount <= wire_cd.hcount;
            cifo.vcount <= wire_cd.vcount;
            cifo.rgb <= rgb_nxt;
            char_xy <= char_xy_nxt;
            char_line <= delayed_char_line;
        end
    end

    always_comb begin
        hcount_var = cifi.hcount - CHAR_XPOS;
        if((char_pixels[3'(wire_cd.hcount-CHAR_XPOS)] == 1'b1) && (wire_cd.hcount<128+CHAR_XPOS) && (wire_cd.vcount<256+CHAR_YPOS) && (wire_cd.hcount>=CHAR_XPOS) && (wire_cd.vcount>=CHAR_YPOS)) begin
            rgb_nxt = 12'h0_0_0;
        end
        else begin
            rgb_nxt = delayed_rgb;
        end
        char_xy_nxt = {4'((cifi.vcount-CHAR_YPOS)/16),hcount_var[6:3]};
        char_line_nxt = 4'(cifi.vcount-CHAR_YPOS);
    end

endmodule