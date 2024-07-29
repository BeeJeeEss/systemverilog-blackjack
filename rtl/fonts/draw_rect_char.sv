`timescale 1 ns / 1 ps

module draw_rect_char (

        input  logic clk,
        input  logic rst,
        input  logic [7:0] char_pixels,
        output logic [7:0] char_xy,
        output logic [3:0] char_line,


        vga_if.in vga_in,
        vga_if.out vga_out

    );

    logic [11:0] rgb_nxt;
    logic [10:0] charx;
    logic [10:0] chary;

    import vga_pkg::*;

    vga_if inner();
    vga_if inner2();


    always_ff @(posedge clk) begin

        if(rst) begin
            inner.vcount <= '0;
            inner.vsync  <= '0;
            inner.vblnk  <= '0;
            inner.hcount <= '0;
            inner.hsync  <= '0;
            inner.hblnk  <= '0;
            inner.rgb    <= '0;
        end

        else begin
            inner.vcount <= vga_in.vcount;
            inner.vsync  <= vga_in.vsync;
            inner.vblnk  <= vga_in.vblnk;
            inner.hcount <= vga_in.hcount;
            inner.hsync  <= vga_in.hsync;
            inner.hblnk  <= vga_in.hblnk;
            inner.rgb    <= vga_in.rgb;
        end

    end

    delay #(
        .WIDTH(38),
        .CLK_DEL(2)
    ) u_delay(
        .clk(clk),
        .rst(rst),
        .din({inner.vcount, inner.vsync, inner.vblnk, inner.hcount, inner.hsync, inner.hblnk, inner.rgb}),
        .dout({inner2.vcount, inner2.vsync, inner2.vblnk, inner2.hcount, inner2.hsync, inner2.hblnk, inner2.rgb})
    );

    always_ff @(posedge clk) begin

        vga_out.vcount <= inner2.vcount;
        vga_out.vsync  <= inner2.vsync;
        vga_out.vblnk  <= inner2.vblnk;
        vga_out.hcount <= inner2.hcount;
        vga_out.hsync  <= inner2.hsync;
        vga_out.hblnk  <= inner2.hblnk;
        vga_out.rgb    <= rgb_nxt;

    end


    always_comb begin

        chary = vga_in.vcount - Y_CHAR;
        charx = vga_in.hcount - X_CHAR;
        char_xy = charx[9:3] + 16*chary[9:4];
        char_line = inner2.vcount[3:0] - Y_CHAR[3:0];

    end


    always_comb begin

        if((inner2.vcount >= Y_CHAR) & (inner2.hcount >= X_CHAR) & (inner2.vcount <= Y_CHAR + HEIGHT_CHAR) & (inner2.hcount < X_CHAR + LENGTH_CHAR)) begin

            if(char_pixels[7 - (inner2.hcount - X_CHAR)%8] == 0) begin
                rgb_nxt = vga_in.rgb;
            end

            else begin
                rgb_nxt = 12'h0_0_0;
            end
        end

        else begin
            rgb_nxt = inner2.rgb;
        end

    end


endmodule
