`timescale 1ns / 1ps



module tb_2d_conv #(parameter Width = 16)();
reg signed [Width-1:0] A;
reg signed [Width-1:0] B;
reg RST, CLK; 
reg[5:0]  N, M, S;
wire signed [Width-1:0] OUT;
wire Done;
//wire Underflow,Overflow;

    

twoD_conv T1(A,B,RST,CLK, N, M, S, OUT,Done);


always #(5) CLK = ~CLK;



initial begin

CLK = 1;
#2.5
RST = 0;
N = 6'd4;
M = 6'd2;

S = 2;

#20
RST = 1;
#100
#4
RST = 0;
#6

A = 1;
B= -1;

#10
A = 2;
B= -2;

#10
A = 3;
B= 3;

#10
A = 4;
B= 4;

#10
A = 5;
B= -5;

#10
A = 6;
B= 6;

#10
A = 7;
B= -7;

#10
A = 8;
B= -8;

#10
A = 9;
B= 9;

#10
A = 10;
B= 10;

#10
A =11;
B= 11;

#10
A = 12;
B= 12;

#10
A = 13;
B= 13;

#10
A = 14;
B= 14;

#10
A = 15;
B= 15;

#10
A = 16;
B= 16;

#10000



RST = 0;
N = 6'd5;
M = 6'd5;

S = 1;

#20
RST = 1;
#100
#4
RST = 0;
#6

A = 1;
B= 1;

#10
A = 2;
B= 2;

#10
A = 3;
B= 3;

#10
A = 4;
B= 4;

#10
A = 5;
B= 5;

#10
A = 6;
B= 6;

#10
A = 7;
B= 7;

#10
A = 0;
B= 0;

#10
A = 0;
B= 0;
#1000
$finish;

end  
endmodule