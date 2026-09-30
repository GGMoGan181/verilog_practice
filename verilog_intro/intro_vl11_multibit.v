`timescale 1ns/1ns
// 入门特别版 VL11 多位信号：声明/使用多位向量 [3:0]
module multibit(input wire [3:0] a, output wire [3:0] y);
    assign y = 4'b0;   // TODO: 对多位信号做运算/赋值
endmodule

//=====================================================
// 范例模块 multibit_ref：参考答案，原模块 multibit 请自行完成
// 题目：声明/使用多位向量 [3:0]
// 思路：向量可以整体赋值、整体参与运算，无需逐位处理
// 关键点：两边位宽一致；运算溢出时高位自然截断
//=====================================================
module multibit_ref(input wire [3:0] a, output wire [3:0] y);
    assign y = a;          // 整体直连；若题意要运算则如 y = a + 4'b1
endmodule
