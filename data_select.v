`timescale 1ns/1ns
//有符号数，最高位1表示负数，0表示正数
module data_select(
    input clk,rst_n,
    input signed [7:0]a,
    inout signed[7:0]b,
    input [1:0]select,
    output reg signed [8:0]out
    );
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            out<=0;
        end
        else begin
            case(select)
                2'b00:begin 
                    out<={a[7],a};
                end
                2'b01:begin
                    out<={b[7],b};
                end
                2'b10:begin
                    out<={a[7],a}+{b[7],b};
                end
                2'b11:begin
                    out<={a[7],a}-{b[7],b};
                end
                default:begin
                    out<=8'b0;
                end
            endcase
        end
    end
endmodule