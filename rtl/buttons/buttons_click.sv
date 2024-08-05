   /**
    * Author: Borys Strzebonski
    *
    * Description:
    * Draw buttons with texts DEAL, HIT, and STAND. Buttons depend on input 'state'.
    */

   `timescale 1 ns / 1 ps

module buttons_click (
        input  wire clk,
        input  wire rst,
        input  wire [11:0] mouse_x,
        input  wire [11:0] mouse_y,
        input  wire  left_mouse,

        output logic deal,
        output logic hit,
        output logic stand
    );

    logic deal_nxt;
    logic hit_nxt;
    logic stand_nxt;

    logic left_mouse_prev;

    always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
            deal <= 0;
            hit <= 0;
            stand <= 0;
            left_mouse_prev <= 0;
        end else begin
            deal <= deal_nxt;
            hit <= hit_nxt;
            stand <= stand_nxt;
            left_mouse_prev <= left_mouse;
        end
    end

    always_comb begin
        deal_nxt = 0;
        stand_nxt = 0;
        hit_nxt = 0;
        if (left_mouse) begin
            if((mouse_x >= 100)&&(mouse_x<=200)&&(mouse_y>=400)&&(mouse_y<=450))  begin
                deal_nxt = 1;
            end
            else if((mouse_x >= 300)&&(mouse_x<=400)&&(mouse_y>=400)&&(mouse_y<=450)) begin
                hit_nxt = 1;
            end
            else if((mouse_x >= 500)&&(mouse_x<=600)&&(mouse_y>=400)&&(mouse_y<=450)) begin
                stand_nxt = 1;
            end
        end
    end



endmodule
