# Blackjack DOUBLE HAND  
A game made for the Digilent Basys 3 board, written in SystemVerilog.

### Installation
```bash
git clone https://github.com/BeeJeeEss/systemverilog-blackjack.git
cd systemverilog-blackjack
. env.sh
generate_bitstream.sh
program_fpga.sh
```

### Requirements
The game supports only multiplayer mode. Each player should have:

- Digilent Basys 3 Board
- VGA display
- Mouse

### Configuration
Connect the board pins (for UART communication) as follows:

- JA2 ----- JA3
- JA3 ----- JA2

### Rules
In Blackjack, your goal is to have a hand value closer to 21 than the dealer's without exceeding 21. Cards 2-10 are worth their face value, face cards are worth 10, and Aces can be 1 or 11. You can either "Hit" to take another card or "Stand" to keep your current hand. The dealer must hit until reaching 17 or more. You win if your hand is closer to 21 than the dealer's, or if the dealer busts by going over 21.
