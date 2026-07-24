`timescale 1ns/1ps
//a= 4'b110
//拼接{a,1'b0}  *2
//{1'b0,a[3:1]}    无符号除法
//{1'b1,a[3:1]}    有符号除法
//{a[3],a[3:1]}    有符号除法
module multi_sel(
    input d[7:0];
    input clk ,rst_n;
    output reg out[10:0];

    output reg input_grant;


);
    reg count[1:0];
    reg reg_d[11:0];
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count<=1'0;
            input_grant<=1'b0;
        end
        else 
            count<=count+1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            out<=0;
            input_grant<=1'b0;
            reg_d<=0;
        end
        else begin
            case(count)
                2'00: begin 
                    reg_d<=d;
                    out<=reg_d;
                    input_grant<=1'b1;

                end
                 2'01: begin 
                    
                    out<=reg_d+{red_d,1'b0};
                    input_grant<=1'b0;
                    
                end

                 2'10: begin 
                    
                    out<=reg_d+{red_d,1'b0}+ {reg_d,2'b00};
                    input_grant<=1'b0;
                    
                end
                2'11: begin 
                    
                    out<={reg_d,3'b000};
                    input_grant<=1'b0;
                    
                end
                default:begin 
                     out<=d;
                    input_grant<=1'b0;
                end
            endcase
        end
    end
endmodule