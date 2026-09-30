`timescale 1ns/1ns
// 基础语法 VL8 generate...for 简化代码：用 generate for 批量例化/展开
module gen_for #(parameter N = 4)(input wire [N-1:0] a, input wire [N-1:0] b,
                                 output wire [N-1:0] y);
    // TODO: genvar i; generate for(i=0;i<N;i=i+1) assign y[i]=a[i]&b[i]; endgenerate
    assign y = {N{1'b0}};
endmodule

//=====================================================
// 范例模块 gen_for_ref：参考答案（供对照学习），原模块 gen_for 请自行完成
// 题目：用 generate for 对 N 位逐位展开做与运算
// 思路：genvar 循环变量 + generate for 在编译期展开成 N 条 assign
// 关键点：genvar 声明、for 头、endgenerate 三要素缺一不可；
//         循环体里只能写可综合的结构（assign/例化/always）
//=====================================================
module gen_for_ref #(parameter N = 4)(input wire [N-1:0] a, input wire [N-1:0] b,
                                     output wire [N-1:0] y);
    genvar i;                          // 编译期循环变量（不是 reg/wire）
    generate
        for (i = 0; i < N; i = i + 1) begin : g_bit   // 展开 N 次，begin 建议命名
            assign y[i] = a[i] & b[i];                // 逐位与
        end
    endgenerate
endmodule
