`timescale 1ns / 1ps


module Tb_for_FP_2D_Conv #(parameter Width = 32)();
reg [Width-1:0] A;
reg [Width-1:0] B;
reg RST, CLK; 
reg[5:0]  N, M, S,P,O;
wire [Width-1:0] OUT;
wire Done;

//wire Underflow,Overflow;

    

FP_2D_Conv FPC1 (A,B,RST,CLK, N, M, S,P,O, OUT,Done);


always #(10) CLK = ~CLK;



initial begin

CLK = 1;
#5
RST = 0;
N = 6'd3;
M = 6'd2;
P = 1;

S = 1;
O = N + 2*P - (M -1);

#40
RST = 1;
#200
#8
RST = 0;
#12

A = 32'b01000000000011001100110011001101;
B=  32'b01000000000011001100110011001101;

#20

A = 32'b00111111110000000000000000000000;
B=  32'b01000000101100000000000000000000;

#20

A = 32'b01000000101100000000000000000000;
B=  32'b01000000000011001100110011001101;

#20

A = 32'b01000000000011001100110011001101;
B=  32'b01000000000011001100110011001101;
#20

A = 32'b00111111110000000000000000000000;
B=  32'b01000000101100000000000000000000;
#20

A = 32'b01000000000011001100110011001101;
B=  32'b01000000000011001100110011001101;

#20

A = 32'b00111111110000000000000000000000;
B=  32'b01000000101100000000000000000000;

#20

A = 32'b01000000000011001100110011001101;
B=  32'b01000000000011001100110011001101;

#20

A = 32'b01000000000011001100110011001101;
B=  32'b01000000101100000000000000000000;


#3000



//RST = 0;
//N = 6'd3;
//M = 6'd2;

//S = 1;

//#200
//RST = 1;
//#1000
//#40
//RST = 0;
//#60

//A = 32'b01000000000011001100110011001101;
//B=  32'b01000000000011001100110011001101;

//#100

//A = 32'b01000000000011001100110011001101;
//B=  32'b01000000000011001100110011001101;

//#100

//A = 32'b01000000000011001100110011001101;
//B=  32'b01000000000011001100110011001101;

//#100

//A = 32'b01000000000011001100110011001101;
//B=  32'b01000000000011001100110011001101;
//#100

//A = 32'b01000000000011001100110011001101;
//B=  32'b01000000000011001100110011001101;
//#100

//A = 32'b01000000000011001100110011001101;
//B=  32'b01000000000011001100110011001101;

//#100

//A = 32'b01000000000011001100110011001101;
//B=  32'b01000000000011001100110011001101;

//#100

//A = 32'b01000000000011001100110011001101;
//B=  32'b01000000000011001100110011001101;

//#100

//A = 32'b01000000000011001100110011001101;
//B=  32'b01000000000011001100110011001101;


#3000
$finish;

end  
endmodule



/*   C- code to check corectness 
#include <stdio.h>
#include <stdlib.h>

#define IMAGE_SIZE 5
#define KERNEL_SIZE 2
#define OUTPUT_SIZE 4  // Same-size output

void convolve2D(float input[IMAGE_SIZE][IMAGE_SIZE],
                float kernel[KERNEL_SIZE][KERNEL_SIZE],
                float output[OUTPUT_SIZE][OUTPUT_SIZE]) {
    int pad = 0;

    for (int i = 0; i < OUTPUT_SIZE; i++) {
        for (int j = 0; j < OUTPUT_SIZE; j++) {
            float sum = 0.0;
            for (int ki = 0; ki < KERNEL_SIZE; ki++) {
                for (int kj = 0; kj < KERNEL_SIZE; kj++) {
                    int ii = i + ki - pad;
                    int jj = j + kj - pad;

                    if (ii >= 0 && ii < OUTPUT_SIZE && jj >= 0 && jj < OUTPUT_SIZE) {
                        sum += input[ii][jj] * kernel[ki][kj];
                    }
                }
            }
            output[i][j] = sum;
        }
    }
}

int main() {
    float input[IMAGE_SIZE][IMAGE_SIZE] = {
        {0, 0, 0, 0, 0},
        {0, 2.2, 1.5, 5.5, 0},
        {0, 2.2, 1.5, 2.2, 0},
        {0, 1.5, 2.2, 2.2, 0},
        {0, 0, 0, 0, 0}
    };

    float kernel[KERNEL_SIZE][KERNEL_SIZE] = {
        {2.2, 5.5},
        {2.2, 2.2}
    };

    float output[OUTPUT_SIZE][OUTPUT_SIZE] = {0};

    convolve2D(input, kernel, output);

    printf("2D Convolution Output:\n");
    for (int i = 0; i < OUTPUT_SIZE; i++) {
        for (int j = 0; j < OUTPUT_SIZE; j++) {
            printf("%6.2f ", output[i][j]);
        }
        printf("\n");
    }

    return 0;
    
} */




/*  Output:

2D Convolution Output:
  4.84   8.14  15.40  12.10 
 16.94  21.23  41.69  16.94 
 15.40  21.23  25.08   9.68 
  8.25  15.40  16.94   4.84 */
