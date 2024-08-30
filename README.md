# Blackjack DOUBLE HAND
Game made for Digilent Basys 3 board, written in SystemVerilog.
## Installation

```
git clone https://github.com/BeeJeeEss/systemverilog-blackjack.git
cd systemverilog-blackjack
. env.sh
generate_bitstream.sh
program_fpga.sh
```
## Requirements
The game supports only a multiplayer mode. The set for each player should contain:
- Digilent Basys 3 Board
- VGA display
- Mouse <br>

## Configuration
Connect boards pins (for UART communication) in order given below: <br>

JA2 ----- JA3 <br>
JA3 ----- JA2 <br>

## Rules
In Blackjack, your goal is to have a hand value closer to 21 than the dealer's without exceeding 21. Cards 2-10 are worth their face value, face cards are worth 10, and Aces can be 1 or 11. You can either "Hit" to take another card or "Stand" to keep your current hand. The dealer must hit until reaching 17 or more. You win if your hand is closer to 21 than the dealer's, or if the dealer busts by going over 21.
