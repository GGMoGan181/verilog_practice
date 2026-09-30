`timescale 1ns/1ns
// 组合逻辑 VL6 用8线-3线优先编码器I实现16线-4线优先编码器：两片级联+仲裁
module enc16to4(input wire [15:0] in, output wire [3:0] code, output wire valid);
    assign code  = 4'b0;   // TODO: 高8/低8 各接一片8-3，高位片优先，valid 仲裁
    assign valid = 1'b0;
endmodule

//=====================================================
// 范例模块 enc16to4_ref：参考答案（供对照学习），原模块 enc16to4 请自行完成
// 题目：两片 8-3 优先编码器级联成 16-4：高 8 位片优先
// 思路：高/低半字节各送一片 8-3；高位片有有效输入时取其结果且码字最高位=1，
//       否则取低位片结果且最高位=0；valid 为两片 valid 之或
// 关键点：仲裁只看高位片的 valid（=|in[15:8]），这就是"优先级"
//=====================================================
module enc16to4_ref(input wire [15:0] in, output wire [3:0] code, output wire valid);
    // 8-3 优先编码函数（高bit优先），供两片"芯片"复用
    function [2:0] enc8;
        input [7:0] v;
        begin
            if      (v[7]) enc8 = 3'd7;
            else if (v[6]) enc8 = 3'd6;
            else if (v[5]) enc8 = 3'd5;
            else if (v[4]) enc8 = 3'd4;
            else if (v[3]) enc8 = 3'd3;
            else if (v[2]) enc8 = 3'd2;
            else if (v[1]) enc8 = 3'd1;
            else           enc8 = 3'd0;
        end
    endfunction
    wire hi_v = |in[15:8];              // 高位片 valid
    wire lo_v = |in[7:0];               // 低位片 valid
    // 高位片优先仲裁：拼上第 4 位区分高/低半区
    assign code  = hi_v ? {1'b1, enc8(in[15:8])} : {1'b0, enc8(in[7:0])};
    assign valid = hi_v | lo_v;         // 任意一片有有效输入
endmodule
