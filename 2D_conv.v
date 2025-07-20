`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////


module twoD_conv #(parameter Width = 16 )(
 input[Width-1:0] A_in,
 input[Width-1:0] B_in,
 input RST,CLK,
 input[5:0] N1, M1, S1,
 
  
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
 reg [5:0] N, M ,S;
 //wire [3:0] w1;
 
 always@(posedge CLK or posedge RST) begin
 if (RST == 1)
 State <= 4'b0000;
 else
 begin
 
 State <= nxt_State;
 

 
 case (State)
  
                 
  4'b0000: begin             //// Reset
            Count_1  <= 0;
            Count_2 <= 0;
            Count_3 <=0;
            Count_4 <= 0;
            Count_5 <= 0;
            Done <= 0;
            FINAL_OUT <= 0;
            ACC <= 0;
          end
          
   4'b0001: begin                //// writing in Data
              if(Count_1 < N*N )
              A[Count_1] <= A_in;
              
              if(Count_1 < M*M )
              begin
              B[Count_1] <= B_in;
               end
               
             // A[Count_1] <= 0;
             //A[Count_1 + N+M] <= 0;
             
               
               Count_1 <= Count_1 + 1'b1;
              if(Count_1 == N*N)
                Count_1 <= 0;
          end
       
        
   4'b0010 : begin  
             ACC <= (ACC + A[Count_1 + N*Count_2 + Count_3 + N*Count_4 ]*B[Count_1 + M*Count_2 ]);
              
                   if (Count_1 == M-1)
                         begin 
                         Count_1 <=0;
                         Count_2 <= Count_2 + 1;
                        
                        end
                      else
                        Count_1 <= Count_1 + 1'b1; 
                     
                
                
                
             end 
   4'b0011 :   OUT[ Count_5 ]  <= ACC;
                  
   4'b0100 :  begin
                ACC <= 0;
                Count_1 <= 0; 
                Count_2 <= 0;
                Count_5 <= Count_5 + 1;
                Count_3 <= Count_3 + S;
                             if ( Count_3 == N-M)
                             begin
                             Count_4 <= Count_4 + S;
                             Count_3 <= 0;
                             end
                
               
              
               
           end
           
         
   4'b0101 :    begin
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
    
  N = N1;
  M = M1;
  S = S1;
  
  Out_size = ((N-M)/S + 1)*((N-M)/S + 1);
  
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
           if (Count_4 == N-M && Count_3 == N-M)
           nxt_State = 4'b0101; 
          
           
         
           
           else
           nxt_State = 4'b0010;
           end   
           
 
  4'b0101 : nxt_State =   4'b0101;
   
 endcase
 end

endmodule
