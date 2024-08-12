module LFSR (
        input clk,
        input rst,
        output reg [3:0] rnd
    );

    wire feedback = random[3] ^ random[2]; // Wybrane bity do sprzężenia zwrotnego

    reg [3:0] random, random_next;
    reg [3:0] count, count_next; // Zwiększony rozmiar licznika do 4 bitów, aby śledzić 16 stanów
    reg valid; // Flaga, aby sprawdzić, czy liczba jest w zakresie 1-13

    always @ (posedge clk or posedge rst)
    begin
        if (rst)
        begin
            random <= 4'b1111; // Ustawienie wartości początkowej na niezerową
            count <= 0;
            rnd <= 1; // Inicjalizacja wyniku na 1
        end

        else
        begin
            random <= random_next;
            count <= count_next;

            if (valid) // Jeżeli liczba jest w zakresie 1-13
                rnd <= random; // Przypisz ją do wyjścia
        end
    end

    always @ (*)
    begin
        random_next = random; // Stan domyślny pozostaje bez zmian
        count_next = count;

        random_next = {random[2:0], feedback}; // Przesunięcie w lewo o jeden bit, wypełnione bitem feedback
        count_next = count + 1;

        valid = (random_next >= 1 && random_next <= 13); // Sprawdzenie, czy liczba jest w zakresie 1-13

        if (count == 15) // Po 15 przesunięciach (pełny cykl 4-bitowego rejestru)
        begin
            count_next = 0;
        end
    end

endmodule
