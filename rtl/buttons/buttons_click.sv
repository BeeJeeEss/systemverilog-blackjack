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

    // logic mouse_pressed;

    always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
            deal <= 0;
            hit <= 0;
            stand <= 0;
        end else begin
            deal <= deal_nxt;
            hit <= hit_nxt;
            stand <= stand_nxt;
        end
    end

    always_comb begin : bg_comb_blk
        if (left_mouse) begin
            if((mouse_x >= 100)&&(mouse_x<=200)&&(mouse_y>=400)&&(mouse_y<=450))  begin
                deal_nxt = 1;
                hit_nxt = 0;
                stand_nxt = 0;
            end
            else if((mouse_x >= 300)&&(mouse_x<=400)&&(mouse_y>=400)&&(mouse_y<=450)) begin
                hit_nxt = 1;
                deal_nxt = 0;
                stand_nxt = 0;
            end
            else if((mouse_x >= 500)&&(mouse_x<=600)&&(mouse_y>=400)&&(mouse_y<=450)) begin
                stand_nxt = 1;
                hit_nxt = 0;
                deal_nxt = 0;
            end
            else begin
                deal_nxt = 0;
                hit_nxt = 0;
                stand_nxt = 0;
            end
        // mouse_pressed = 1;
        end else begin
        // mouse_pressed = 0;
        end
    end



endmodule
