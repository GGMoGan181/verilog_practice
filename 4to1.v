`timescale 1ns/1ps
module mux4_1(
    input a[1:0];
    input b[1:0];
    input c[1:0];
    input d[1:0];
    input sel[1:0];
    output mux_out[1:0];

);
    reg [1:0]mux_out_reg;
    always@(*) begin
    
        case(sel)
        2'b00:mux_out_reg=a;
        2'b01 :mux_out_reg=b;
        2'b10:mux_out_reg=c;
        2'b11:mux_out_reg=d;
        default:mux_out_reg=2'b00;
        endcase


    end
    assign mux_out=mux_out_reg;

endmodule