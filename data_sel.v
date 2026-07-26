`timescale 1ns/1ns
module data_sel(
    input [15:0]data ,
    input [1:0] sel,
    input clk,rst_n,
    output reg [15:0]out,
    output reg valid_out

);
    reg [15:0]d_reg;
    reg [15:0]out_reg;
    wire [3:0]d0;
    wire [3:0]d1;
    wire [3:0]d2;
    wire [3:0]d3;
    assign d0=data[3:0];
    assign d1=data[7:4];
    assign d2=data[11:8];
    assign d3=data[15:12];
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            d_reg<=0;
            valid_out<=1'b0;
            out_reg<=0;
        end
        else begin
            d_reg<=data;
            case(sel)
                2'b00:begin
                    out_reg<=d0;
                    valid_out<=1'b0;
                end
                2'b01:begin
                    out_reg<=d0+d1;
                    valid_out<=1'b1;
                end
                2'b10:begin
                    out_reg<=d0+d1;
                    valid_out<=1'b1;
                end
                2'b11:begin
                    out_reg<=d0+d2;
                    valid_out<=1'b1;
                end
                default:begin
                    out_reg<=0;
                    valid_out<=1'b0;
                end
            endcase
        end

    end

    assign out=out_reg;
    

endmodule