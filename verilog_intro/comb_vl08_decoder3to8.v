`timescale 1ns/1ns
// 组合逻辑 VL8 实现3-8译码器①：3bit 输入译出 8 个独热输出
module decoder3to8(input wire [2:0] in, output wire [7:0] y);
    assign y = 8'b0;   // TODO: y = 1<<in (或 case 独热)
endmodule

//=====================================================
// 范例模块 decoder3to8_ref：参考答案（供对照学习），原模块 decoder3to8 请自行完成
// 题目：3-8 译码器：3bit 输入选中 8 路输出中的唯一一路（独热）
// 思路：把常量 1 左移 in 位，自然得到独热码
// 关键点：移位量是变量 in；等价写法 case(in) 8'd0: y=8'b0000_0001; ...
//=====================================================
module decoder3to8_ref(input wire [2:0] in, output wire [7:0] y);
    assign y = 8'b0000_0001 << in;   // 独热：in=0 时 y=8'b0000_0001，in=7 时 y=8'b1000_0000
endmodule
