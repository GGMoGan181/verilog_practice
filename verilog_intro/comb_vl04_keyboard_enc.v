`timescale 1ns/1ns
// 组合逻辑 VL4 用优先编码器①实现键盘编码电路：按键(多输入)优先编码成键码
module keyboard_enc(input wire [7:0] key, output wire [2:0] keycode, output wire press);
    assign keycode = 3'b0;   // TODO: 例化/复用优先编码器对按键编码
    assign press   = 1'b0;
endmodule

//=====================================================
// 范例模块 keyboard_enc_ref：参考答案（供对照学习），原模块 keyboard_enc 请自行完成
// 题目：8 个按键用优先编码器编成 3bit 键码，并给出"有键按下"指示
// 思路：键盘同时按多键时只响应优先级最高的键 → 就是 8-3 优先编码；
//       press 就是"任意键有效"的归约或
// 关键点：编码逻辑与 comb_vl03 同构，此处内联实现保持范例自包含
//=====================================================
module keyboard_enc_ref(input wire [7:0] key, output wire [2:0] keycode, output wire press);
    reg [2:0] code_r;
    always @(*) begin
        if      (key[7]) code_r = 3'd7;   // 高编号键优先
        else if (key[6]) code_r = 3'd6;
        else if (key[5]) code_r = 3'd5;
        else if (key[4]) code_r = 3'd4;
        else if (key[3]) code_r = 3'd3;
        else if (key[2]) code_r = 3'd2;
        else if (key[1]) code_r = 3'd1;
        else             code_r = 3'd0;
    end
    assign keycode = code_r;
    assign press   = |key;               // 有键按下指示
endmodule
