`timescale 1ns/1ns
// 入门特别版 VL20 256选1选择器：256 输入 1 输出，8bit 选择信号
module mux256to1(input wire [255:0] d, input wire [7:0] sel, output wire y);
    assign y = 1'b0;   // TODO: assign y = d[sel];
endmodule

//=====================================================
// 范例模块 mux256to1_ref：参考答案，原模块 mux256to1 请自行完成
// 题目：256 选 1：8bit sel 从 256bit 向量中选 1 位
// 思路：8bit sel 恰好覆盖 0~255 全部编码，直接位选即可
// 关键点：位选下标可以是变量；无需 case 256 分支
//=====================================================
module mux256to1_ref(input wire [255:0] d, input wire [7:0] sel, output wire y);
    assign y = d[sel];   // 变量下标位选，天然 256 选 1
endmodule
