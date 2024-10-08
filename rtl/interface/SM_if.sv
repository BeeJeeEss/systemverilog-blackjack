`timescale 1 ns / 1 ps

interface SM_if;

    logic [3:0] player_card_values [0:8];
    logic [3:0] dealer_card_values [0:8];
    modport in (input player_card_values, dealer_card_values);
    modport out (output player_card_values, dealer_card_values);

endinterface 