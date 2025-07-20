`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.06.2025 13:15:19
// Design Name: 
// Module Name: TB_for_conv_twoD
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module TB_for_conv_twoD #(parameter Width = 16)();
reg signed [Width-1:0] A;
reg signed [Width-1:0] B;
reg RST, CLK; 
reg[5:0]  N, M, S, P , O;
wire signed [Width-1:0] OUT;
wire Done;
//wire Underflow,Overflow;

    

Two_D_Conv_with_S_and_P  T1(A,B,RST,CLK, N, M, S,P,O, OUT,Done);


always #(6) CLK = ~CLK;



initial begin

CLK = 1;

RST = 0;
N = 6'd4;
M = 6'd3;

S = 1;
P = 1;
O = 4;

#24
RST = 1;
#120
#6
RST = 0;
#18

A = 1;
B= -1;

#12
A = 2;
B= -2;

#12
A = 3;
B= 3;

#12
A = 4;
B= 4;

#12
A = 5;
B= -5;

#12
A = 6;
B= 6;

#12
A = 7;
B= -7;

#12
A = 8;
B= -8;

#12
A = 9;
B= 9;

#12
A = 10;
B= 10;

#12
A =11;
B= 11;

#12
A = 12;
B= 12;

#12
A = 13;
B= 13;

#12
A = 14;
B= 14;

#12
A = 15;
B= 15;

#12
A = 16;
B= 16;

#10000



//RST = 0;
//N = 6'd5;
//M = 6'd5;

//S = 1;

//#20
//RST = 1;
//#100
//#4
//RST = 0;
//#6

//A = 1;
//B= 1;

//#10
//A = 2;
//B= 2;

//#10
//A = 3;
//B= 3;

//#10
//A = 4;
//B= 4;

//#10
//A = 5;
//B= 5;

//#10
//A = 6;
//B= 6;

//#10
//A = 7;
//B= 7;

//#10
//A = 0;
//B= 0;

//#10
//A = 0;
//B= 0;
#1000
$finish;

end
endmodule
