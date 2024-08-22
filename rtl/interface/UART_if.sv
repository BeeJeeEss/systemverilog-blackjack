`timescale 1 ns / 1 ps

interface UART_if;

    logic [3:0] card_values [0:8];
    modport in (input card_values);
    modport out (output card_values);

endinterface 