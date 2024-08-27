  /**
   * Copyright (C) 2024  AGH University of Science and Technology
   * MTM UEC2
   * Authors: Konrad Sawina, Borys Strzeboński
   * Description:
   * Top project module.
   */

  `timescale 1 ns / 1 ps

module top_vga (

        input  logic clk,
        input  logic clk975Mhz,
        input  logic rst,
        input  logic rx,

        output logic tx,
        output logic vs,
        output logic hs,
        output logic [3:0] r,
        output logic [3:0] g,
        output logic [3:0] b,
        inout  logic PS2Clk,
        inout  logic PS2Data
    );

    vga_if wire_tim();
    vga_if wire_bg();
    vga_if wire_mouse();
    vga_if wire_test();
    vga_if wire_delay_rect();
    vga_if wire_btn();
    vga_if wire_card0();
    vga_if wire_menu();
    vga_if wire_text();
    vga_if wire_deck();
    vga_if wire_animation();

    SM_if wire_SM();

    UART_if wire_UART();

    wire [4:0] total_player_value;
    wire [4:0] total_dealer_value;
    wire [2:0] fsm_state;
    wire rx_empty, rd_uart, tx_full, wr_uart;
    wire [7:0] read_data, w_data;
    wire player1;
    wire player2;
    wire left;
    wire right;
    wire [11:0] xpos;
    wire [11:0] ypos;
    wire [1:0] player_state;
    wire [11:0] xpos_nxt;
    wire [11:0] ypos_nxt;
    wire left_nxt;
    wire right_nxt;
    wire deal;
    wire hit;
    wire stand;
    wire start;
    wire decoded_deal;
    wire decoded_dealer_finished;
    wire deal_finished;
    wire dealer_round_finished;
    wire deal_wait_btn;
    wire decoded_start;
    wire start_pressed;
    wire [2:0] animation;
    wire animation_end;
    wire [11:0] rgb_wire;
    wire [12:0] address_wire;
    wire [11:0] rgb_wire1;
    wire [12:0] address_wire1;
    wire [11:0] xpos_card;
    wire [11:0] ypos_card;
    wire [1:0] angle;

    assign vs = wire_mouse.vsync;
    assign hs = wire_mouse.hsync;
    assign {r,g,b} = wire_mouse.rgb;


    vga_timing u_vga_timing (
        .clk,
        .rst,
        .vga_tim(wire_tim)
    );

    draw_bg u_draw_bg (
        .clk,
        .rst,

        .vga_bg_in(wire_tim),
        .vga_bg_out(wire_bg)
    );

    MouseCtl u_MouseCtl (
        .clk(clk975Mhz),
        .rst,

        .left(left),
        .right(right),

        .ps2_data(PS2Data),
        .ps2_clk(PS2Clk),

        .xpos(xpos),
        .ypos(ypos),

        .zpos(),
        .middle(),
        .new_event(),
        .value('0),
        .setx('0),
        .sety('0),
        .setmax_x('0),
        .setmax_y('0)
    );

    hold_mouse u_hold_mouse(
        .clk,
        .rst,

        .left(left),
        .right(right),
        .xpos(xpos),
        .ypos(ypos),

        .left_out(left_nxt),
        .right_out(right_nxt),
        .xposout(xpos_nxt),
        .yposout(ypos_nxt)
    );

    draw_mouse u_draw_mouse (
        .clk,
        .rst,

        .vga_mouse_in(wire_btn),
        .vga_mouse_out(wire_mouse),

        .xpos(xpos_nxt),
        .ypos(ypos_nxt)
    );

    calculate_card u_calculate_card(
        .clk,
        .rst,
        .card_if(wire_SM),
        .total_players_value(total_player_value),
        .total_dealer_value(total_dealer_value)
    );

    blackjack_FSM blackjack_FSM (
        .clk,
        .rst,
        .vga_blackjack_in(wire_menu),
        .SM_out(wire_SM),
        .deal(deal),
        .hit(hit),
        .stand(stand),
        .start(start),
        .selected_player(player_state),
        .total_player_value(total_player_value),
        .total_dealer_value(total_dealer_value),
        .state_btn(fsm_state),
        .deal_card_finished(deal_finished),
        .finished_player_1(dealer_round_finished),
        .decoded_deal,
        .decoded_dealer_finished,
        .decoded_cards(wire_UART),
        .deal_wait_btn(deal_wait_btn),
        .decoded_start,
        .start_pressed(start_pressed),
        .player1(player1),
        .player2(player2),
        .animation(animation),
        .animation_end(animation_end)
    );

    card u_card (
        .clk,
        .rst,
        .SM_in(wire_SM),
        .card_in(wire_menu),
        .card_out(wire_test)
    );

    draw_buttons u_draw_buttons(
        .clk,
        .rst,
        .vga_btn_in(wire_deck),
        .vga_btn_out(wire_btn),
        .state(fsm_state),
        .deal_wait_btn(deal_wait_btn),
        .selected_player(player_state),
        .dealer_finished(decoded_dealer_finished)
    );

    draw_result u_draw_result(
        .clk,
        .rst,
        .state(fsm_state),
        .vga_result_in(wire_bg),
        .vga_result_out(wire_text)
    );

    draw_menu u_draw_menu(
        .clk,
        .rst,
        .vga_menu_in(wire_text),
        .vga_menu_out(wire_menu),
        .state(fsm_state)
    );

    buttons_click u_buttons_click(
        .clk,
        .rst,
        .mouse_x(xpos_nxt),
        .mouse_y(ypos_nxt),
        .left_mouse(left_nxt),
        .deal(deal),
        .hit(hit),
        .stand(stand),
        .start(start),
        .player1(player1),
        .player2(player2)
    );

    player_selector u_player_selector(
        .clk,
        .rst,
        .player_1(player1),
        .player_2(player2),
        .selected_player(player_state)
    );

    draw_deck u_draw_deck (
        .clk,
        .rst,

        .vga_deck_in(wire_animation),
        .vga_deck_out(wire_deck),
        .pixel_addr (address_wire),
        .rgb_pixel(rgb_wire),
        .state(fsm_state)
    );

    image_rom_deck u_image_rom_deck(
        .clk,
        .addrA(address_wire),
        .dout(rgb_wire)
    );

    uart u_uart(
        .clk,
        .rst,
        .rx,
        .tx,
        .r_data(read_data),
        .rd_uart,
        .rx_empty,
        .tx_full,
        .w_data,
        .wr_uart
    );

    uart_encoder u_uart_encoder(
        .clk,
        .rst,
        .tx_full,
        .deal(deal_finished),
        .dealer_finished(dealer_round_finished),
        .cards(wire_SM),
        .wr_uart,
        .w_data,
        .start(start_pressed)
    );

    uart_decoder u_uart_decoder(
        .clk,
        .rst,
        .read_data,
        .rx_empty,
        .rd_uart,
        .decoded_deal,
        .decoded_dealer_finished,
        .decoder_cards(wire_UART),
        .decoded_start
    );

    image_rom_deck u_image_rom_deck1(
        .clk,
        .addrA(address_wire1),
        .dout(rgb_wire1)
    );

    card_animation u_card_animation(
        .clk,
        .rst,
        .xpos(xpos_card),
        .ypos(ypos_card),
        .vga_in(wire_test),
        .angle(angle),
        .animation(animation),
        .animation_end(animation_end)
    );

    draw_animation_card u_draw_animation_card(
        .clk,
        .rst,
        .pixel_addr(address_wire1),
        .rgb_pixel(rgb_wire1),
        .xpos(xpos_card),
        .ypos(ypos_card),
        .vga_deck_in(wire_test),
        .vga_deck_out(wire_animation),
        .angle(angle),
        .animation(animation)
    );

endmodule