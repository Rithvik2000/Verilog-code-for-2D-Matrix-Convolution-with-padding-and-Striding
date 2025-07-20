
module Two_D_Conv_with_S_and_P #(parameter Width = 16 )(
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
            ACC <= 0;
            Out_size <= (O1)   *  (O1) ;
             N <= N1;
              M <= M1;
              S <= S1;
              P <= P1;
              N_padded <= 2*P1 + N1; 
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
             ACC <= (ACC + A[Count_1 + N_padded *Count_2 + Count_3 + N_padded *Count_4 ]*B[Count_1 + M*Count_2 ]);
              
                   if (Count_1 == M-1)
                         begin 
                         Count_1 <=0;
                         Count_2 <= Count_2 + 1;
                        
                        end
                      else
                        Count_1 <= Count_1 + 1'b1; 
                     
                
                
                
             end 
   s3 :   OUT[ Count_5 ]  <= ACC;
                  
   s4 :  begin
                ACC <= 0;
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

