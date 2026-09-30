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

module function_mod(
    input [7:0]a,
    input [7:0]b,
    output [7:0]c,
    output [7:0]d
);
    //function 内部只能用过程赋值，不能用 generate/assign
    function [7:0] begin_end;
        input [7:0] data;
        integer i;
        begin
            for(i=0;i<8 ;i=i+1)
                begin_end[i]= data[7-i];
        end
    endfunction

    assign c=begin_end(a);
    assign d=begin_end(b);
endmodule

//=====================================================
// 范例模块 function_mod_ref：参考答案（供对照学习），原模块 function_mod 请自行完成
// 题目：用 function 实现 8 位数据按位反序（a->c、b->d）
// 思路：function 只能描述组合逻辑，以函数名返回单一值，可在多处复用
// 关键点：① function 内用 for 循环逐位拼接；② 也可用拼接运算符一行实现反序
//=====================================================
module function_mod_ref(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] c,
    output [7:0] d
);
    // 函数：返回 data 的按位反序（bit7 变 bit0 …）
    function [7:0] bit_reverse;
        input [7:0] data;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1)
                bit_reverse[i] = data[7-i];   // 逐位映射：目标第 i 位 = 源第 7-i 位
        end
    endfunction

    assign c = bit_reverse(a);   // 同一函数多处调用，硬件上生成两份相同逻辑
    assign d = bit_reverse(b);

    // 等价写法（不用 function）：拼接反序，一行搞定
    // assign c = {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]};
endmodule