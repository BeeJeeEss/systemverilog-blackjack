------------------------------------------------------------------------
-- mouse_displayer.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zolt�n
--          Copyright 2006 Digilent, Inc.
-- Modified : Piotr Kaczmarczyk
-- Modified : Lukasz Mayer
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device           : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the implementation of a mouse cursor.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- Mouse position is received from the mouse_controller, horizontal and
-- vertical counters are received from vga_module and if the counters
-- are inside the mouse cursor bounds, then the mouse is sent to the
-- screen.
-- The mouse display module can be also used as an overlay of the VGA
-- signal, also blanking the VGA screen, if the red_in, green_in, blue_in
-- and the blank_in signals are used.
-- In this application the signals mentioned and their corresponding code
-- lines are commented, therefore the mouse display module only generates
-- the RGB signals to display the cursor, and the VGA controller decides
-- whether or not to display the cursor.
-- The mouse cursor is 16x16 pixels and uses 2 colors: white and black.
-- For the color encoding 2 bits are used to be able to use transparency.
-- The cursor is stored in a 256X2 bit distributed ram memory. If the current
-- pixel of the mouse is "00" then output color is black, if "01" then is
-- white and if "10" or "11" then the pixel is transparent and the input
-- R, G and B signals are passed to the output.
-- In this way, the mouse cursor will not be a 16x16 square, instead will
-- have an arrow shape.
-- The memory address is composed from the difference of the vga counters
-- and mouse position: xdiff is the difference on 4 bits (because cursor
-- is 16 pixels width) between the horizontal vga counter and the xpos
-- of the mouse. ydiff is the difference on 4 bits (because cursor
-- has 16 pixels in height) between the vertical vga counter and the
-- ypos of the mouse. By concatenating ydiff and xidff (in this order)
-- the memory address of the current pixel is obtained.
-- A distributed memory implementation is forced by the attributes, to save
-- BRAM resources.
-- If the blank input from the vga_module is active, this means that current
-- pixel is not inside visible screen and color outputs are set to black
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- pixel_clk      - input pin, representing the pixel clock, used
--                - by the vga_controller for the currently used
--                - resolution, generated by a dcm. 25MHz for 640x480,
--                - 40MHz for 800x600 and 108 MHz for 1280x1024.
--                - This clock is used to read pixels from memory
--                - and output data on color outputs.
-- xpos           - input pin, 10 bits, from mouse_controller
--                - the x position of the mouse relative to the upper
--                - left corner
-- ypos           - input pin, 10 bits, from mouse_controller
--                - the y position of the mouse relative to the upper
--                - left corner
-- hcount         - input pin, 11 bits, from vga_module
--                - the horizontal counter from the vga_controller
--                - tells the horizontal position of the current pixel
--                - on the screen from left to right.
-- vcount         - input pin, 11 bits, from vga_module
--                - the vertical counter from the vga_controller
--                - tells the vertical position of the currentl pixel
--                - on the screen from top to bottom.
-- rgb_out        - output pin, 12 bits, to vga hardware module.
--                - rgb output channel (11:8 - r, 7:4 - g, 3:0 - b)
------------------- Signals used when the mouse display is in overlay mode

-- blank          - input pin, from vga_module
--                - if active, current pixel is not in visible area,
--                - and color outputs should be set on 0.
-- rgb_in         - input pin, 12 bits, from effects_layer
--                - rgb channel input of the image to be displayed
--                - (11:8 - red, 7:4 - green, 3:0 - blue)
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- simulation library
--library UNISIM;
--use UNISIM.VComponents.all;

-- the mouse_displayer entity declaration
-- read above for behavioral description and port definitions.
entity MouseDisplay is
port (
   pixel_clk: in std_logic;
   xpos     : in std_logic_vector(11 downto 0);
   ypos     : in std_logic_vector(11 downto 0);

   hcount   : in std_logic_vector(10 downto 0);
   vcount   : in std_logic_vector(10 downto 0);
   blank    : in std_logic; -- if VGA blank is used

   rgb_in   : in std_logic_vector(11 downto 0);  -- if VGA signal pass-through is used

   enable_mouse_display_out : out std_logic;

   rgb_out  : out std_logic_vector(11 downto 0)
);

-- force synthesizer to extract distributed ram for the
-- displayrom signal, and not a block ram, to save BRAM resources.
attribute rom_extract : string;
attribute rom_extract of MouseDisplay: entity is "yes";
attribute rom_style : string;
attribute rom_style of MouseDisplay: entity is "distributed";

end MouseDisplay;

architecture Behavioral of MouseDisplay is

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

type displayrom is array(0 to 255) of std_logic_vector(1 downto 0);
-- the memory that holds the cursor.
-- 00 - black
-- 01 - white
-- 1x - transparent

constant mouserom: displayrom := (
"00","00","11","11","11","11","11","11","11","11","11","11","11","11","11","11",
"00","01","00","11","11","11","11","11","11","11","11","11","11","11","11","11",
"00","01","01","00","11","11","11","11","11","11","11","11","11","11","11","11",
"00","01","01","01","00","11","11","11","11","11","11","11","11","11","11","11",
"00","01","01","01","01","00","11","11","11","11","11","11","11","11","11","11",
"00","01","01","01","01","01","00","11","11","11","11","11","11","11","11","11",
"00","01","01","01","01","01","01","00","11","11","11","11","11","11","11","11",
"00","01","01","01","01","01","01","01","00","11","11","11","11","11","11","11",
"00","01","01","01","01","01","00","00","00","00","11","11","11","11","11","11",
"00","01","01","01","01","01","00","11","11","11","11","11","11","11","11","11",
"00","01","00","00","01","01","00","11","11","11","11","11","11","11","11","11",
"00","00","11","11","00","01","01","00","11","11","11","11","11","11","11","11",
"00","11","11","11","00","01","01","00","11","11","11","11","11","11","11","11",
"11","11","11","11","11","00","01","01","00","11","11","11","11","11","11","11",
"11","11","11","11","11","00","01","01","00","11","11","11","11","11","11","11",
"11","11","11","11","11","11","00","00","11","11","11","11","11","11","11","11"
);

-- width and height of cursor.
constant OFFSET: std_logic_vector(4 downto 0) := "10000";   -- 16

------------------------------------------------------------------------
-- SIGNALS
------------------------------------------------------------------------

-- pixel from the display memory, representing currently displayed
-- pixel of the cursor, if the cursor is being display at this point
signal mousepixel: std_logic_vector(1 downto 0) := (others => '0');
-- when high, enables displaying of the cursor, and reading the
-- cursor memory.
signal enable_mouse_display: std_logic := '0';

-- difference in range 0-15 between the vga counters and mouse position
signal xdiff: std_logic_vector(3 downto 0) := (others => '0');
signal ydiff: std_logic_vector(3 downto 0) := (others => '0');

signal rgb_nxt  : std_logic_vector(11 downto 0);

begin

   -- compute xdiff
   x_diff: process(hcount, xpos)
   variable temp_diff: std_logic_vector(11 downto 0) := (others => '0');
   begin
         temp_diff := hcount - xpos;
         xdiff <= temp_diff(3 downto 0);
   end process x_diff;

   -- compute ydiff
   y_diff: process(vcount, ypos)
   variable temp_diff: std_logic_vector(11 downto 0) := (others => '0');
   begin
         temp_diff := vcount - ypos;
         ydiff <= temp_diff(3 downto 0);
   end process y_diff;

   -- read pixel from memory at address obtained by concatenation of
   -- ydiff and xdiff

   process(ydiff, xdiff)
   begin
      mousepixel <= mouserom(conv_integer(ydiff & xdiff));
   end process;

   -- set enable_mouse_display high if vga counters inside cursor block
   enable_mouse: process(hcount, vcount, xpos, ypos, mousepixel)
   begin
      if(hcount >= xpos and hcount < (xpos + OFFSET) and
         vcount >= ypos and vcount < (ypos + OFFSET)) and
         (mousepixel = "00" or mousepixel = "01")
      then
         enable_mouse_display <= '1';
      else
         enable_mouse_display <= '0';
      end if;
   end process enable_mouse;

   enable_mouse_display_out <= enable_mouse_display
                               when rising_edge(pixel_clk);

   -- if cursor display is enabled, then, according to pixel
   -- value, set the output color channels.
   rgb : process(enable_mouse_display, mousepixel, blank, rgb_in)
   begin
         -- if in visible screen
         -- (if used, add blank to the sensitivity list)
         if(blank = '0') then
         -- in display is enabled
         if(enable_mouse_display = '1') then
            -- white pixel of cursor
            if(mousepixel = "01") then
               rgb_nxt <= (others => '1');
            -- black pixel of cursor
            elsif(mousepixel = "00") then
               rgb_nxt <= (others => '0');
            -- transparent pixel of cursor
            -- let input pass to output
            -- (if used, add rgb_in to the sensitivity list)
           else
              rgb_nxt <= rgb_in;
            end if;
         -- cursor display is not enabled
         -- let input pass to output.
        else
           rgb_nxt <= rgb_in;
         end if;
      -- not in visible screen, black outputs.
     else
        rgb_nxt <= (others => '0');
     end if;
end process rgb;

rgb_out  <= rgb_nxt   when rising_edge(pixel_clk);

end Behavioral;
