`timescale 1ns/1ns
// 组合逻辑 VL9 使用3-8译码器①实现逻辑函数：译码最小项+或门得任意函数
module decoder_func(input wire [2:0] in, output wire f);
    wire [7:0] m;   // TODO: 例化 decoder3to8 得最小项
    assign f = 1'b0;   // TODO: f = 所需最小项之或
endmodule

//=====================================================
// 范例模块 decoder3to8_ref / decoder_func_ref：参考答案（供对照学习）
// 原模块 decoder_func 请自行完成
// 题目：用 3-8 译码器 + 或门实现逻辑函数（本例取 f=Σm(1,2,4,7)，即三输入异或）
// 思路：译码器产生全部最小项，函数=所需最小项编号之或
// 关键点：换题目只改"或"的那一行里选中的最小项编号；
//         译码器助手模块命名 _ref 以免与 comb_vl08 的模块重名
//=====================================================
module decoder3to8_ref(input wire [2:0] in, output wire [7:0] y);
    assign y = 8'b0000_0001 << in;   // 独热最小项发生器
endmodule

module decoder_func_ref(input wire [2:0] in, output wire f);
    wire [7:0] m;                       // 最小项向量
    decoder3to8_ref u_dec (.in(in), .y(m));   // 例化译码器
    assign f = m[1] | m[2] | m[4] | m[7];     // f = Σm(1,2,4,7) = in[2]^in[1]^in[0]
endmodule
