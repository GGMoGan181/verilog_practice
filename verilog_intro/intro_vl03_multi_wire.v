`timescale 1ns/1ns
// 入门特别版 VL3 多wire连接：声明中间 wire 连接多个门
module multi_wire(input wire a, input wire b, output wire y);
    wire w1, w2;       // TODO: 用中间 wire 串接门电路
    assign y = 1'b0;
endmodule

//=====================================================
// 范例模块 multi_wire_ref：参考答案，原模块 multi_wire 请自行完成
// 题目：声明中间 wire，把多个门串起来（本例：与门→非门 链）
// 思路：每根中间 wire 代表一段连线，先声明后 assign 驱动
// 关键点：wire 只能被一条 assign/一个门驱动；具体门链以题目图为准
//=====================================================
module multi_wire_ref(input wire a, input wire b, output wire y);
    wire w1, w2;          // 中间连线
    assign w1 = a & b;    // 第一级：与门
    assign w2 = ~w1;      // 第二级：非门（合起来即与非）
    assign y  = w2;       // 输出级
endmodule
