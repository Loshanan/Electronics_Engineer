# 4-Digit 7-Segment Display with Basic Counter

This project demonstrates a 4-digit 7-segment display that shows hexadecimal numbers derived from a 16-bit input.

## Display Overview
The display uses an 11-wire input: 7 wires control the segments (a to g) for each LED, while the other 4 wires select which digit is active among the four. A basic counter with variable output bit lengths is implemented to provide input for the display.

### Top-level overview of the module:
![Top module](images\Top_module.png)

### Block diagram of the display unit:
![Display module](images\Display_Unit.png)

## Display Operation
A common cathode display module is used. The refresh period is divided into four parts, one for each digit, allowing the use of just one nibble-to-LED decoder, a 16x4 multiplexer (mux), a 2x4 demultiplexer (demux), and a simple Moore state machine to control the display.

Below image shows timing diagram for displaying "0006" on the 4-digit 7-segment LED display.
![timing diagram](images\display_example.png)
