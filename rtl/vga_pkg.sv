/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 * Modified by: Konrad Sawina
 * Description:
 * Package with vga related constants adjusted to 1024X768 resolution.
 */

package vga_pkg;

  // Parameters for VGA Display 1024 x 768 @ 60fps using a 65 MHz clock;
  localparam  HOR_PIXELS = 1024;
  localparam  VER_PIXELS = 768;
  localparam  HBLANK_START = 1024;
  localparam  HBLANK_STOP = 1344;
  localparam  HSYNC_START = 1048;
  localparam  HSYNC_STOP = 1184;
  localparam  VBLANK_START = 768;
  localparam  VBLANK_STOP = 806;
  localparam  VSYNC_START = 771;
  localparam  VSYNC_STOP = 777;

  // Add VGA timing parameters here and refer to them in other modules.
  localparam X_CHAR = 10;
  localparam Y_CHAR = 40;
  localparam HEIGHT_CHAR = 256;
  localparam LENGTH_CHAR = 128;
endpackage