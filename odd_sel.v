`timescale 1ns/1ps

//单目运算
//a=&d  是否全是1
//a=^d  奇偶校验
//a=|d  是否全为0

module odd_sel(
    input data[31;0];
    input sel;
    output cheak;

);
    wire cheak_temp;
    assign cheak_temp=^data;
    assign cheak=sel ?cheak_temp : ~cheak_temp;
    
    
endmodule