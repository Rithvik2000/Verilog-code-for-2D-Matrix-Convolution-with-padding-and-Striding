

module FP_2D_Conv #(parameter Width = 32 /*Out_size = 4 */)(
input[Width-1:0] A_in,
 input[Width-1:0] B_in,
 input RST,CLK,
 input[5:0] N1, M1, S1, P1, O1,
 
  
    output reg [Width-1:0] FINAL_OUT,
   output  reg Done
    );
    
    
    
 reg signed [Width-1:0] A[63:0];
 reg signed [Width-1:0] B[63:0];
 reg signed [Width-1:0] OUT[63:0];
 
 reg [3:0] State , nxt_State ;
 reg [Width-1:0] ACC;
 reg [5:0] Out_size ;
 
 reg [5:0] Count_1, Count_2, Count_3,Count_4,Count_5; 
 reg [5:0] N, M ,S,P,N_padded;
 //wire [3:0] w1;
 
 localparam s0 = 4'b0000,
            s1 = 4'b0001,
            s2 = 4'b0010,
            s3 = 4'b0011,
            s4 = 4'b0100,
            s5 = 4'b0101;
 
 integer i;
    

 
 
 
 wire [Width -1 :0] w1, w2, w3;
 reg [Width-1:0] temp_reg_1,temp_reg_2;
 reg rst_mac;
 
 
 
 MAC mc1( w1, w2, CLK, rst_mac, PP, w3);
 assign w1 = temp_reg_1;
 assign w2 = temp_reg_2;




 
  
 
    

 always@(posedge CLK or posedge RST) begin
 if (RST == 1)
 begin
 State <= s0;
 
  for (i = 0; i < 64 ; i = i+1)
   begin
    A[i] <= 0;
    B[i] <= 0;
    OUT[i] <= 0;
   end
 end
 else
 begin
 
 State <= nxt_State;
 

 
 case (State)
  
                 
  s0    : begin             //// Reset
            Count_1  <= 0;
            Count_2 <= 0;
            Count_3 <=0;
            Count_4 <= 0;
            Count_5 <= 0;
            Done <= 0;
            FINAL_OUT <= 0;
            // ACC <= 0;
            Out_size <= (O1)   *  (O1) ;
             N <= N1;
              M <= M1;
              S <= S1;
              P <= P1;
              N_padded <= 2*P1 + N1; 
              rst_mac <= 1;
          end
          
   s1    : begin       
              Count_1 <= Count_1 + 1'b1;
   
            //// writing in Data
              if(Count_1 < N*N )
              A[Count_1 + P*(N + 2*P + 1) + Count_3] <= A_in;
              
              if(Count_1 < M*M )
              B[Count_1] <= B_in;
                             
             // A[Count_1] <= 0;
             //A[Count_1 + N+M] <= 0;
             
               
               
              if(Count_1 == N*N)
               begin
                Count_1 <= 0;
                Count_2 <= 0;
                Count_3 <= 0;
               end
               
             else if(Count_2 == N-1 )
               begin
               Count_3 <= Count_3 + 2*P;
               Count_2 <= 0;
               end
             else
                Count_2 <= Count_2 + 1'b1;
                
                
                
               
                
          end
       
      
   s2   : begin  
           //  ACC <= (ACC + A[Count_1 + N_padded *Count_2 + Count_3 + N_padded *Count_4 ]*B[Count_1 + M*Count_2 ]);
              temp_reg_1 <= A[Count_1 + N_padded *Count_2 + Count_3 + N_padded *Count_4 ];
              temp_reg_2 <= B[Count_1 + M*Count_2 ];  
              
              
              
                   if (Count_1 == M-1)
                         begin 
                         Count_1 <=0;
                         Count_2 <= Count_2 + 1;
                        
                        end
                      else
                        begin
                        Count_1 <= Count_1 + 1'b1; 
                        rst_mac <= 0;
                       end
                     
                
                
                
             end 
             
             
   s3 :  begin
          OUT[ Count_5 ]  <= ACC;
          rst_mac <= 1;
         end
                  
   s4 :  begin
               // ACC <= 0;
                Count_1 <= 0; 
                Count_2 <= 0;
                Count_5 <= Count_5 + 1;
                Count_3 <= Count_3 + S;
                             if ( Count_3 == N_padded -M)
                             begin
                             Count_4 <= Count_4 + S;
                             Count_3 <= 0;
                             end
                
               
              
               
           end
           
         
   s5 :    begin
                if (Count_5 > 0) 
                 begin
                FINAL_OUT <= OUT[Out_size- (Count_5 )];
                Count_5 <= Count_5 - 1;
                Done <= 1;
                 end
                else 
                  begin
                   Done <= 0;
                   FINAL_OUT <= 0;
                  end
                end

  endcase 
  end 

 end
 
 
 
 
 always@(*) begin
    
 ACC = w3;
  

  
 case(State)

 4'b0000 :  begin 
         nxt_State =  4'b0001;
         end
         
4'b0001 : begin
         if(Count_1 == N*N)
                 nxt_State =  4'b0010;
                 
                
                 else
                 begin
                 nxt_State =  4'b0001;
                 
                 end
         end
         
         
  4'b0010 : begin  
              
            if (Count_2 == M-1 && Count_1 == M-1)
             nxt_State =  4'b0011;
            else
            nxt_State =  4'b0010; 
           
            
          end        
  4'b0011 : nxt_State =   4'b0100;        
  4'b0100: begin
  
           
            
           if (Count_4 == N_padded-M && Count_3 == N_padded-M)
           nxt_State = 4'b0101; 
          
           
         
           
           else
           nxt_State = 4'b0010;
           end   
           
 
  4'b0101 : nxt_State =   4'b0101;
   
 endcase
 end

endmodule





///////////////////////////// MAC ////////////////////////////////////

module MAC #(parameter N = 32, M = 23, P = N-M-1)(
 input[N-1:0] A1,
 input[N-1:0] B1,
 input CLK, RST,
  
 output [N-1:0] PP,OUT,
 output reg UnderFlow,
 output reg OverFlow
);

reg[N-1:0] AC1 = 0;
wire o1,o2,u1,u2;


    Floating_Point_Multiplier M01 (A1,B1,PP,u1,o1);
    FloatAdder A01(PP,AC1,OUT,u2,o2);

always@(*) begin
  if(A1[N-2:0]==0 && B1[N-2:0] ==0)
      begin
        UnderFlow <= 0;
        OverFlow <= 0;
      end
  
  else
     begin
        UnderFlow <= u1|u2;
        OverFlow <= o1|o2;
     end
end
 
 
    
  always@(posedge CLK or posedge RST)  begin
  if (RST == 1)
  AC1 <= 0;
  else
  AC1 <= OUT;
  end
    
    
endmodule


/////////////////////   Floating Point Multipler ////////////

module Floating_Point_Multiplier #(parameter N = 32, M = 23, P = N-M-1)(
  input[N-1:0] A,
  input[N-1:0] B,
  
   output [N-1:0] FINAL_OUT,
   output UnderFlow,
   output OverFlow
   
    );
    
    wire[2*M+1:0] C;
    wire[1:0] C2;
    wire[N-2:0] OUT;
    
  
   //Multilying Mantissa
   Fixed_Point_Multipler M1({1'b1,A[M-1:0]},{1'b1,B[M-1:0]},C);
   
   // Shifting Operation, 2M+1 bit output from multiplier, select M-bits on MSB
   // starting after the first 1
     assign OUT[M-1:0]  = (C[2*M+1])? C[2*M:M+1]:C[2*M-1:M];
     
     
   //  Adding the Exponents
   Adder_1 A1(A[N-2:M],B[N-2:M],C[2*M+1],{C2,OUT[N-2:M]});
   
   
  // overflow and underflow
  assign OverFlow = (( ~C2[1] ) & C2[0]);
  assign UnderFlow = C2[1] ;
  
  // Sign bit Computation
  assign FINAL_OUT[N-1] = A[N-1]^B[N-1];
  
  // 3-input MUX
  assign FINAL_OUT[N-2:0] = OverFlow == 1 ? {N{1'b1}}:( UnderFlow ? {N{1'b0}}: OUT); 
     
endmodule



//M = 10,23,52
module Fixed_Point_Multipler #(parameter M = 23)(
input[M:0] A,
input[M:0] B,
output [(2*M)+1:0] OUT
);

assign OUT = A*B;
endmodule

// p =5,8,11
module Adder_1 #(parameter P = 8)( 
input[P-1:0] A,
input[P-1:0] B,
input Shift,
output [P+1:0] OUT
);

wire[P+1:0] Bias;

assign Bias = -127 ;  // 2's Compliment of -15,-127,-1023,
assign OUT = A+B+Bias+(Shift);
endmodule



////////////////////   Floating Point Adder  ////////////////


module FloatAdder #(parameter N = 32, M = 23, P = N-M-1)(
  input[N-1:0] A,
  input[N-1:0] B,
  
   output reg [N-1:0] FINAL_OUT,
   output reg UnderFlow_Ad,
   output reg OverFlow_Ad
    );
    
    wire[M-1:0] M1,M2;
    wire[P+1:0] E1,E2;
    reg S;
    reg[P+1:0] UnFlow1;
    reg[P+1:0] UnFlow2;
    
    reg [P-1:0] shift;
    reg [M:0] a1,b1;
    
    
    wire[M+2:0] in;
    reg [M+2:0] C1;
    
 
    reg [4:0]out;  
    
  
   
    
    assign M1 = A[M-1:0];
    assign M2 = B[M-1:0];
    assign E1 = A[N-2:M];
    assign E2 = B[N-2:M];
    assign S1 = A[N-1];
    assign S2 = B[N-1];
    
    
   always@(*) begin
   
 
    //COMPARE EXPONENT
      if (E1 > E2)
        begin
        shift = E1 - E2;
        a1 = {1'b1,M1};
        if (shift <= 23)
            b1 ={1'b1,M2}>>(shift);
        else
           b1 = 0;
        S = A[N-1];
        end
       
      else if (E2 > E1)
        begin
        shift = E2 - E1;
        b1 = {1'b1,M2};
        if (shift <= 23)
            a1 = {1'b1,M1}>>(shift);
        else
           a1 = 0;
        S = B[N-1];
        end  
        
        else // e1 == e2
        begin
        
        b1 = {1'b1,M2};
        a1 = {1'b1,M1};
         
      
            if (M1 > M2)
            begin
            S = A[N-1];
            end
            
          else if (M2 > M1)
            begin
            S = B[N-1];
            end
            
          else
            S = B[N-1];
        
      end
  end
    
     
     //Adding Mantissa
   Fixed_Point_Adder F1  ( {A[N-1],1'b0,a1},   {B[N-1], 1'b0,b1},  in);
  
   
    always@(*) begin 
 
   if(A == 0 && B==0)
     FINAL_OUT = 0;
   else if ( A == 0)
     FINAL_OUT = B;
   else if (B == 0)
     FINAL_OUT = A;
   else
     begin
 
    out = 5'b00000;
 
     if (in[24]) begin
        out = 5'b11000;
        
    end else if (in[23]) begin
        out = 5'b10111;
        
    end else if (in[22]) begin
        out = 5'b10110;
        
    end else if (in[21]) begin
        out = 5'b10101;
        
    end else if (in[20]) begin
        out = 5'b10100;
        
    end else if (in[19]) begin
        out = 5'b10011;
        
    end else if (in[18]) begin
        out = 5'b10010;
        
    end else if (in[17]) begin
        out = 5'b10001;
        
    end else if (in[16]) begin
        out = 5'b10000;
        
    end else if (in[15]) begin
        out = 5'b01111;
        
    end else if (in[14]) begin
        out = 5'b01110;
        
    end else if (in[13]) begin
        out = 5'b01101;
        
    end else if (in[12]) begin
        out = 5'b01100;
        
    end else if (in[11]) begin
        out = 5'b01011;
        
    end else if (in[10]) begin
        out = 5'b01010;
        
    end else if (in[9]) begin
        out = 5'b01001;
        
    end else if (in[8]) begin
        out = 5'b01000;
        
    end else if (in[7]) begin
        out = 5'b00111;
        
    end else if (in[6]) begin
        out = 5'b00110;
       
    end else if (in[5]) begin
        out = 5'b00101;
        
    end else if (in[4]) begin
        out = 5'b00100;
       
    end else if (in[3]) begin
        out = 5'b00011;
       
    end else if (in[2]) begin
        out = 5'b00010;
        
    end else if (in[1]) begin
        out = 5'b00001;
        
    end else if (in[0]) begin
        out = 5'b00000;
      
    end

      FINAL_OUT[N-1] = S;
      
      UnFlow1 = (E1 - (23-out));
      UnFlow2 = (E2 - (23-out));
      
         if ((out) == 24)
           C1 =  in >> 1;
         else
          C1 =  in << (23-out);
        
     
     //overflow and underflow
      
     
       if ((E1 >= E2) && (UnFlow1[P+1] == 0) && (UnFlow1[P] == 1))
         begin
          FINAL_OUT[N-2:0] = 31'b1111111111111111111111111111111;
          OverFlow_Ad = 1;
         end
         
       else if ((E1 >= E2)&&(UnFlow1[P+1] == 1))
         begin
          FINAL_OUT[N-2:0] = 0;
          UnderFlow_Ad = 1;
         end
         
      
     
        else if ((E2 > E1 )&& (UnFlow2[P+1] == 0) && (UnFlow2[P] == 1))
         begin
          FINAL_OUT[N-2:0] = 31'b1111111111111111111111111111111;
          OverFlow_Ad = 1;
         end
         
        else if ((E2 > E1)&&(UnFlow2[P+1] == 1))
         begin
          FINAL_OUT[N-2:0] = 0;
          UnderFlow_Ad = 1;
         end
         
        else if (E1 == 0 && E2 == 0 && M1 == 0 && M2 == 0)
        begin
          FINAL_OUT[N-2:0] = 0;
           UnderFlow_Ad = 0;
           OverFlow_Ad = 0;
        end
       
        
         
       else
         begin
         FINAL_OUT[M-1:0] = C1[M-1:0];
         FINAL_OUT[N-2:M] =(E1>=E2) ?(E1 - (23-out) ):(E2 - (23-out) );
         UnderFlow_Ad = 0;
         OverFlow_Ad = 0;
         end
      
    end
end

endmodule



module Fixed_Point_Adder #(parameter M = 23)(
input[M+2:0] A,
input[M+2:0] B,
output reg [M+2:0] OUT
);
 
 reg [M+1:0] a11,b11;
 
 always@(*) begin 
  if (A[M+2] == B[M+2]) 
     OUT = A + B;
  else if (A[M+1:0] > B[M+1:0])
     OUT = A - B;
     else
     OUT = B-A;
    
 end 
endmodule


 
// always@(posedge CLK or posedge RST) begin
// if (RST == 1)
// State <= 4'b0000;
// else
// begin
 
// State <= nxt_State;
 

 
// case (State)
  
                 
//  4'b0000: begin             //// Reset
//            Count_1  <= 0;
//            Count_2 <= 0;
//            Count_3 <=0;
//            Count_4 <= 0;
//            Count_5 <= 0;
//            Done <= 0;
//            FINAL_OUT_1 <= 0;
//            ACC = 32'd0;
//            rst_mac = 1;
//          end
          
//   4'b0001: begin                //// writing in Data
//              if(Count_1 < n*n )
//              A[Count_1] <= A_in;
              
//              if(Count_1 < m*m )
//              begin
//              B[Count_1] <= B_in;
//               end
               
//             // A[Count_1] <= 0;
//             //A[Count_1 + N+M] <= 0;
             
               
//               Count_1 <= Count_1 + 1'b1;
//              if(Count_1 == n*n)
//               begin
//                Count_1 <= 0;
                
//               end
//          end
       
        
//   4'b0010 : begin  
//            // ACC <= (ACC + A[Count_1 + N*Count_2 + Count_3 + N*Count_4 ]*B[Count_1 + M*Count_2 ]);
//              temp_reg_1 <= A[Count_1 + n*Count_2 + Count_3 + n*Count_4 ];
//              temp_reg_2 <= B[Count_1 + m*Count_2 ];
//                   if (Count_1 == m-1)
//                         begin 
//                         Count_1 <=0;
//                         Count_2 <= Count_2 + 1;
                        
//                        end
//                      else
//                        Count_1 <= Count_1 + 1'b1; 
//                        rst_mac <= 0;
                
                
                
//             end 
             
//   4'b0011 :   begin
//               OUT_2[ Count_5 ]  <= ACC; 
//               rst_mac = 1;
//               end
                  
//   4'b0100 :  begin
//                ACC <= 32'd0;
//                Count_1 <= 0; 
//                Count_2 <= 0;
//                Count_5 <= Count_5 + 1;
//                Count_3 <= Count_3 + S;
//                             if ( Count_3 == n-m)
//                             begin
//                             Count_4 <= Count_4 + S;
//                             Count_3 <= 0;
//                             end
                
               
              
               
//           end
           
         
//   4'b0101 :    begin
//                if (Count_5 > 0) 
//                 begin
//                FINAL_OUT_1 <= OUT_2[Out_size- (Count_5 )];
//                Count_5 <= Count_5 - 1;
//                Done <= 1;
//                 end
//                else 
//                  begin
//                   Done <= 0;
//                   FINAL_OUT_1 <= 0;
//                  end
//                end

//  endcase 
//  end 

// end
 
 
 
 
// always@(*) begin
    
//  n = N1;
//  m = M1;
//  S = S1;
  
//  ACC = w3;
  
   
// // Out_size = ((n-m)/S + 1)*((n-m)/S + 1);
  
// case(State)

// 4'b0000 :  begin 
//         nxt_State =  4'b0001;
//         end
         
//4'b0001 : begin
//         if(Count_1 == n*n)
//                 nxt_State =  4'b0010;
                 
                
//                 else
//                 begin
//                 nxt_State =  4'b0001;
                 
//                 end
//         end
         
         
//  4'b0010 : begin  
              
//            if (Count_2 == m-1 && Count_1 == m-1)
//             nxt_State =  4'b0011;
//            else
//            nxt_State =  4'b0010; 
           
            
//          end        
//  4'b0011 : nxt_State =   4'b0100;        
//  4'b0100: begin
//           if (Count_4 == n-m && Count_3 == n-m)
//           nxt_State = 4'b0101; 
          
           
         
           
//           else
//           nxt_State = 4'b0010;
//           end   
           
 
//  4'b0101 : nxt_State =   4'b0101;
   
// endcase
// end

//endmodule

////////////////////////////////////////////////////////////////////
