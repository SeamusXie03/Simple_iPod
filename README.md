# Simple iPod Implementation on FBGA

## Overview
This repository contains the implementation of a simple iPod on an FBGA (Field-Programmable Gate Array) platform. The project involves generating organ tones for one octave, including the notes "Do Re Mi Fa So La Si Do". The sound frequencies for these notes are [523Hz, 587Hz, 659Hz, 698Hz, 783Hz, 880Hz, 987Hz, 1046Hz].

## Hardware Setup
1. **Clock Divider**: Implement a controllable clock divider using switches SW[3:1]. You can use the initial module `Generate_Arbitrary_Divided_Clk32` to start, but the final submission must include a self-built clock divider. The switches SW[3:1] control the frequency of the generated tones.

2. **Audio Output Control**: Use switch SW[0] to enable audio output in the "On" position and disable it in the "Off" position.

3. **Oscilloscope Visualization**: Modify the code to display the selected audio frequency wave in the "oscilloscope" with appropriate descriptions.

4. **Information Console Mode**: In this mode, the bottom line should display the positions of the switches along with the current audio data in hexadecimal. The top line should contain an interesting message.

5. **LED Control**: Implement a frequency divider to create a 1 Hz clock, controlling eight green LEDs to move from side to side, changing the LED every 1 second.

## Finite State Machines (FSM)
The project involves building Finite State Machines to read sound samples from Flash memory on the card. The Flash contains samples of a song that can be played through an audio D/A (Digital to Analog converter).

## Laboratory Enhancements
In this lab, the goal is to enhance the "simple iPod" by adding an LED strength meter using an embedded PicoBlaze processor. This demonstrates the usage of embedded processors in hardware design. The LED strength meter shows the strength of the audio signal and involves real-time averaging as a basic form of filtering.

## PicoBlaze Integration
1. **Toggle LEDR[0]**: The main program will toggle LEDR[0] every 1 second.

2. **Interrupt Routine**: The interrupt routine is activated each time a new value is read from Flash memory. It accumulates and averages 256 absolute values, updating LEDG[7:0] with the result.

3. **LED Output**: The PicoBlaze interrupt routine outputs the average value to LEDG[7:0] (or LEDR[9:2] for DE1-SoC) with LEDs filling from left to right based on the most significant binary digit of the average.

4. **Reset Accumulator**: After each average value is output to the LEDs, the accumulator is reset to 0 to prepare for the next 256 values.

## Instructions
1. Open the project in your FBGA development environment.
2. Build and program the FPGA with the provided implementation.
3. Test the audio output, oscilloscope visualization, information console mode, and LED control.
4. Observe the LED strength meter behavior with the embedded PicoBlaze processor.

Feel free to explore and modify the code to enhance or customize the iPod implementation based on your preferences and requirements.
