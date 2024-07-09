/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Package with vga related constants.
 */

 package vga_pkg;

    // Parameters for VGA Display 800 x 600 @ 60fps using a 40 MHz clock;
    localparam HOR_PIXELS = 800;
    localparam VER_PIXELS = 600;
    localparam HOR_BLANK_START = 800;
    localparam VER_BLANK_START = 600;
    localparam HOR_SYNC_START = 840;
    localparam VER_SYNC_START = 601;
    localparam VER_SYNC_STOP = 605;
    localparam H_MAX = 1056;
    localparam V_MAX = 628;
    localparam HOR_SYNC_STOP = 968;
    localparam xpos = 20;
    localparam ypos = 30;
    
    // Add VGA timing parameters here and refer to them in other modules.
    
    endpackage