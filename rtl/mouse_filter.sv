module mouse_filter (
    input logic clk,          // Sygnał zegara
    input logic rst,          // Sygnał resetu
    input logic mouse_pressed, // Wejściowy sygnał od myszki
    output logic single_pulse // Wyjściowy sygnał, tylko jeden puls podczas przytrzymania
);

    logic mouse_pressed_d1; // Opóźniona wersja sygnału myszki

    // Flip-flopy do opóźnienia sygnału
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mouse_pressed_d1 <= 0;
            single_pulse <= 0;
        end else begin
            mouse_pressed_d1 <= mouse_pressed;
            
            // Generowanie jednego pulsującego sygnału, gdy myszka jest wciśnięta
            if (mouse_pressed && !mouse_pressed_d1) begin
                single_pulse <= 1;
            end else begin
                single_pulse <= 0;
            end
        end
    end

endmodule
