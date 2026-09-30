`timescale 1ns/1ns
// 入门特别版 VL2 wire连线：用 wire 把输入连到输出
module wire_connect(input wire a, output wire y);
    assign y = 1'b0;   // TODO: assign y = a;
endmodule

//=====================================================
// 范例模块 wire_connect_ref：参考答案，原模块 wire_connect 请自行完成
// 题目：用 wire 把输入 a 连到输出 y
// 关键点：连续赋值 assign 即"连线"，方向只能是 左=右 的驱动关系
//=====================================================
module wire_connect_ref(input wire a, output wire y);
    assign y = a;   // 一根导线直连
endmodule
