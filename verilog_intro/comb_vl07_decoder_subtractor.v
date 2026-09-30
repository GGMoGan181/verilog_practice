`timescale 1ns/1ns
// 组合逻辑 VL7 用3-8译码器实现全减器：译码输出最小项+或门组合出差/借位
module decoder_subtractor(input wire a, input wire b, input wire bin,
                          output wire diff, output wire bout);
    wire [7:0] m;   // TODO: 3-8 译码最小项 m0..m7
    assign diff = 1'b0;   // TODO: 差 = 最小项或
    assign bout = 1'b0;   // TODO: 借位 = 最小项或
endmodule

//=====================================================
// 范例模块 decoder_subtractor_ref：参考答案（供对照学习），原模块 decoder_subtractor 请自行完成
// 题目：用 3-8 译码器（最小项发生器）+ 或门实现全减器 diff=a-b-bin
// 思路：译码器把 {a,b,bin} 译成 8 个独热最小项 m0..m7；
//       真值表：diff=Σm(1,2,4,7)，bout=Σm(1,2,3,7)，各取或即可
// 关键点：m = 8'b1 << {a,b,bin} 一行即得独热最小项；
//         任何组合函数都可写成"最小项之或"，这是译码器实现的通用套路
//=====================================================
module decoder_subtractor_ref(input wire a, input wire b, input wire bin,
                              output wire diff, output wire bout);
    wire [7:0] m;                       // m[i]=1 表示输入组合等于 i
    assign m    = 8'b1 << {a, b, bin};  // 3-8 译码：独热最小项
    assign diff = m[1] | m[2] | m[4] | m[7];   // 差 = Σm(1,2,4,7)
    assign bout = m[1] | m[2] | m[3] | m[7];   // 借位 = Σm(1,2,3,7)
endmodule
