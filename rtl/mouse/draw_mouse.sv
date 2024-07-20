 /**
  * Copyright (C) 2023  AGH University of Science and Technology
  * MTM UEC2
  * Author: Piotr Kaczmarczyk
  *
  * Description:
  * Draw background.
  */


  `timescale 1 ns / 1 ps

module draw_mouse (
          input  logic clk,
          input  logic rst,
          input  logic [11:0] xpos,
          input  logic [11:0] ypos,

  
          vga_if.out vga_mouse_out,
          vga_if.in vga_mouse_in
  
   );

   MouseDisplay inst(
        .blank(vga_mouse_in.vblnk || vga_mouse_in.hblnk),
        .enable_mouse_display_out(),
        .hcount(vga_mouse_in.hcount),
        .pixel_clk(clk),
        .rgb_in(vga_mouse_in.rgb),
        .rgb_out(vga_mouse_out.rgb),
        .vcount(vga_mouse_in.vcount),
        .xpos(xpos),
        .ypos(ypos)
   );
  
  
      always_ff @(posedge clk) begin : bg_ff_blk
          if (rst) begin    
              vga_mouse_out.vsync  <= '0;  
              vga_mouse_out.hsync  <= '0;     
          end else begin   
              vga_mouse_out.vsync  <= vga_mouse_in.vsync;     
              vga_mouse_out.hsync  <= vga_mouse_in.hsync;          
          end
      end
  
   
  endmodule