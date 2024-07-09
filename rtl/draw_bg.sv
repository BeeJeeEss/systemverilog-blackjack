module background_display (
        input logic clk,
        input logic rst,
        input logic [10:0] hcount_in, // szerokość liczników (np. z generatora synchronizacji)
        input logic [10:0] vcount_in, // wysokość liczników (np. z generatora synchronizacji)
        input logic [10:0] xpos, // pozycja x początku obrazka
        input logic [10:0] ypos, // pozycja y początku obrazka
        output logic [7:0] pixel_out
    );

    // Parametry
    parameter IMG_WIDTH  = 640;
    parameter IMG_HEIGHT = 480;
    parameter FILE_PATH = "bg.dat"; // Zaktualizowana ścieżka do pliku

    // Rejestry
    logic [7:0] memory [0:IMG_WIDTH*IMG_HEIGHT-1];
    logic [19:0] pixel_index, pixel_index_nxt;
    logic [10:0] imag_x, imag_x_nxt;
    logic [10:0] imag_y, imag_y_nxt;

    // Procedura inicjalizacyjna ładowania danych z pliku
    initial begin
        $readmemh(FILE_PATH, memory);
    end

    // Generowanie wartości następnych
    always_comb begin
        imag_y_nxt = vcount_in - ypos;
        imag_x_nxt = hcount_in - xpos;
        pixel_index_nxt = imag_y_nxt * IMG_WIDTH + imag_x_nxt;
    end

    // Aktualizacja wartości rejestrów na sygnał zegara
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            imag_y <= 0;
            imag_x <= 0;
            pixel_index <= 0;
        end else begin
            imag_y <= imag_y_nxt;
            imag_x <= imag_x_nxt;
            pixel_index <= pixel_index_nxt;
        end
    end

    // Wyjście piksela
    always_comb begin
        if (imag_x < IMG_WIDTH && imag_y < IMG_HEIGHT) begin
            pixel_out = memory[pixel_index];
        end else begin
            pixel_out = 8'h04; // wyświetlanie czerni poza obrazkiem
        end
    end

endmodule
