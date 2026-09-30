`timescale 1ns/1ns
// 组合逻辑 VL3 优先编码器电路①：8线-3线优先编码（高优先级覆盖）
module priority_enc8to3(input wire [7:0] in, output wire [2:0] code, output wire valid);
    assign code  = 3'b0;   // TODO: 从最高位向下优先编码
    assign valid = 1'b0;   // TODO: |in
endmodule

//=====================================================
// 范例模块 priority_enc8to3_ref：参考答案（供对照学习），原模块 priority_enc8to3 请自行完成
// 题目：8线-3线优先编码器：多位同时有效时，最高位（in[7]）优先
// 思路：if-else 链从最高位往下判，先命中的先编码，天然实现优先级
// 关键点：valid = |in 表示"至少有一位有效"；if-else 顺序即优先级
//=====================================================
module priority_enc8to3_ref(input wire [7:0] in, output wire [2:0] code, output wire valid);
    reg [2:0] code_r;
    always @(*) begin
        if      (in[7]) code_r = 3'd7;   // 最高位优先
        else if (in[6]) code_r = 3'd6;
        else if (in[5]) code_r = 3'd5;
        else if (in[4]) code_r = 3'd4;
        else if (in[3]) code_r = 3'd3;
        else if (in[2]) code_r = 3'd2;
        else if (in[1]) code_r = 3'd1;
        else            code_r = 3'd0;   // 含 in[0] 有效与全无效两种情况
    end
    assign code  = code_r;
    assign valid = |in;                  // 归约或：有任何一位有效即 1
endmodule
