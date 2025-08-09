# Verilog-code-for-2D-Matrix-Convolution-with-padding-and-Striding
A modular 2D matrix convolution unit ( for both floating and fixed-point formats) with configurable padding and stride.

A- Input Matrix Elements in

B- Kernel Matrix Elements in

N- Size of Input Matrix

M- Size of Kernel Matrix

S- Stride Length

P- Padding

O-Output Image Size

Elements of Input Matrix are feed Sequentially, and Covolution Operation is done using only one MAC unit using an FSM and outputs are sent out sequentially once all elements of the Output Matrix are Calculated. 

Simulation Results (Fixed point)

<img width="1887" height="508" alt="Screenshot 2025-07-20 162501" src="https://github.com/user-attachments/assets/894294c6-e91a-4447-9aae-3357a6598a81" />


Input Waveform
<img width="1877" height="409" alt="Screenshot 2025-07-20 162549" src="https://github.com/user-attachments/assets/7a47819a-1cc2-480b-af67-d828ba77e18b" />


<img width="1885" height="424" alt="image" src="https://github.com/user-attachments/assets/57f610a3-8214-4738-9b3d-c710ee741906" />

Post Synthesis Report (for FPGA )


