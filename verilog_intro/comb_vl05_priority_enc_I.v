`timescale 1ns/1ns
// 组合逻辑 VL5 优先编码器 I：另一种规格优先编码器（注意有效电平/输出编码）
module priority_enc_I(input wire [7:0] in, output wire [2:0] code);
    assign code = 3'b0;   // TODO: 按题意有效电平与编码方向实现
endmodule

//=====================================================
// 范例模块 priority_enc_I_ref：参考答案（供对照学习），原模块 priority_enc_I 请自行完成
// 题目：另一种规格的优先编码器：输入低电平有效（0 表示请求）
// 思路：先把低有效输入取反成高有效的请求向量 req，
//       再按"下标大者优先"的 if-else 链编码
// 关键点：有效电平转换只在入口做一次；若题目要求低有效输出，
//         在出口再取反一次 ~code_r 即可
//=====================================================
module priority_enc_I_ref(input wire [7:0] in, output wire [2:0] code);
    wire [7:0] req = ~in;          // 低有效 → 高有效请求
    reg  [2:0] code_r;
    always @(*) begin
        if      (req[7]) code_r = 3'd7;   // 最高位优先
        else if (req[6]) code_r = 3'd6;
        else if (req[5]) code_r = 3'd5;
        else if (req[4]) code_r = 3'd4;
        else if (req[3]) code_r = 3'd3;
        else if (req[2]) code_r = 3'd2;
        else if (req[1]) code_r = 3'd1;
        else             code_r = 3'd0;
    end
    assign code = code_r;          // 若题意输出低有效：assign code = ~code_r;
endmodule
