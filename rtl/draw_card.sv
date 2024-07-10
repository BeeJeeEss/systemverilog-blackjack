
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_card
 Author:        Konrad Sawina
 */
//////////////////////////////////////////////////////////////////////////////
module draw_card
    (
        input  wire  clk,  // posedge active clock
        input  wire  rst,  // high-level active synchronous reset
        input  wire  [11:0] rgb_pixel,
        input  wire  card_symbol,
        input  wire  card_colour,

        input  logic [10:0] vcount_in,
        input  logic        vsync_in,
        input  logic        vblnk_in,
        input  logic [10:0] hcount_in,
        input  logic        hsync_in,
        input  logic        hblnk_in,
        input  logic [11:0] rgb_in,

        output logic [11:0] pixel_addr,

        output logic [10:0] vcount_out,
        output logic        vsync_out,
        output logic        vblnk_out,
        output logic [10:0] hcount_out,
        output logic        hsync_out,
        output logic        hblnk_out,

        output logic [11:0] rgb_out
    );

    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    localparam CARD_XPOS = 20;
    localparam CARD_YPOS = 30;
    localparam CARD_HEIGHT = 79;
    localparam CARD_WIDTH = 55;

    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------
    logic [11:0] rgb_nxt;
    logic [11:0] pixel_addr_nxt;


    //------------------------------------------------------------------------------
    // output register with sync reset
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : out_reg_blk
        if(rst) begin : out_reg_rst_blk
            vcount_out <= '0;
            vsync_out  <= '0;
            vblnk_out  <= '0;
            hcount_out <= '0;
            hsync_out  <= '0;
            hblnk_out  <= '0;
            rgb_out    <= '0;
            pixel_addr <= '0;
        end
        else begin : out_reg_run_blk
            vcount_out <= vcount_in;
            vsync_out  <= vsync_in;
            vblnk_out  <= vblnk_in;
            hcount_out <= hcount_in;
            hsync_out  <= hsync_in;
            hblnk_out  <= hblnk_in;
            rgb_out    <= rgb_nxt;
            pixel_addr <= pixel_addr_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // logic
    //------------------------------------------------------------------------------
    always_comb begin : card_comb_blk
        if (vblnk_in || hblnk_in) begin
            rgb_nxt = 12'h0_0_0;
        end else begin
            if (hcount_in >= CARD_XPOS  && hcount_in  <= CARD_XPOS+CARD_WIDTH && vcount_in  >= CARD_YPOS && vcount_in <= CARD_YPOS+CARD_HEIGHT) begin
                rgb_nxt = rgb_pixel;
                // pixel_addr_nxt = {6'(vcount_in - CARD_YPOS), 6'(hcount_in - CARD_XPOS)};
                pixel_addr_nxt = (vcount_in - CARD_YPOS)*CARD_WIDTH + hcount_in - CARD_XPOS;
            end
            else begin
                pixel_addr_nxt = 0;
                rgb_nxt = rgb_in;
            end

        end
    end

endmodule
