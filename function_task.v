//function 使用
//计算，组合逻辑
//不包含任何延时
//只有input参数，由函数名返回一个值
//调用其他function


//task使用过
//调试，硬件描述
//包含时序控制（wait）
//input output inout
//调用其他task和function

`timescale 1ns/1ns
 function [7:0] begin_end
        input [7:0] data;
        begin
            genvar i;
            generate for(i=0;i<8 ;i=i+1)
                begin : gen_i
                    assign begin_end[i]= data[7-i];
                end
            endgenerate
        end
    endfunction

module function_mod(
    input [7:0]a,
    input [7:0]b,
    output [7:0]c,
    output [7:0]d,
);
   

    assign c=begin_end(a);
    assign d=begin_end(b);
endmodule