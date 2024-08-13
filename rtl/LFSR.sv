module LFSR #(
        parameter RANDOM = 13'hF // Parametr początkowy
    )(
        input clk,
        input rst,
        output reg [3:0] rnd
    );

    wire feedback = random[12] ^ random[3] ^ random[2] ^ random[0];

    reg [12:0] random, random_next;
    reg [3:0] count, count_next; // Do śledzenia liczby przesunięć

    always @ (posedge clk or posedge rst)
    begin
        if (rst)
        begin
            random <= RANDOM; // Reset na wartość początkową, która nie jest zerowa
            count <= 0;
            rnd <= 1; // Inicjalizacja wyniku na 1
        end
        else
        begin
            random <= random_next;
            count <= count_next;

            if (random_next[9:6] >= 1 && random_next[9:6] <= 13) // Jeśli wynik jest w zakresie 1-13
                rnd <= random_next[9:6];
        end
    end

    always @ (*)
    begin
        random_next = {random[11:0], feedback}; // Przesunięcie w lewo z uwzględnieniem sprzężenia zwrotnego
        count_next = count + 1;

        if (count == 13)
            count_next = 0;
    end

endmodule
