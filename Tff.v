`timescale 1ns/1ps
module Tff(
    input  wire data ;
    input clk,rst_n;

    output reg out;
);
    reg q1;
    always@ (posedge clk or negedge rst_n) begin
        if (!rst_n)begin
            out<=1'b0;

        end
        else begin
            if(data)
                q1<=~q1;
            else 
                q1<=q1;

        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            out<=1'b0;
        end
        else begin
            if(q1)
                out<=~out;
            else 
                out<= out;
        end
    end
endmodule