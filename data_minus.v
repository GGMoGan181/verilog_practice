`timescale 1ns/1ns

module data_minus(
    input clk,rst_n,
    input  [7:0]a,
    inout [7:0]b,
    
    output reg  [8:0]c
    );
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            c<=0;
        end
        else begin
            if(a>b) c<=a-b;
            else c<=b-a;
            
        end
    end
endmodule