`timescale 1ns/1ns
// 入门特别版 VL13 位运算与逻辑运算：区分按位(&,|,^) 与 逻辑(&&,||,!)
module bit_vs_logic(input wire [1:0] a, input wire [1:0] b,
                    output wire [1:0] y_bit, output wire y_log);
    assign y_bit = 2'b0;  // TODO: 按位与 a & b
    assign y_log = 1'b0;  // TODO: 逻辑与 a && b
endmodule

//=====================================================
// 范例模块 bit_vs_logic_ref：参考答案，原模块 bit_vs_logic 请自行完成
// 题目：区分按位与 & 和逻辑与 &&
// 思路：& 逐位独立运算，结果位宽不变；&& 把整个向量当"非0即真"，
//       结果只有 1bit
// 关键点：a=2'b01,b=2'b10 时 a&b=2'b00 但 a&&b=1'b1，对比记忆
//=====================================================
module bit_vs_logic_ref(input wire [1:0] a, input wire [1:0] b,
                        output wire [1:0] y_bit, output wire y_log);
    assign y_bit = a & b;    // 按位与：2bit 结果
    assign y_log = a && b;   // 逻辑与：a、b 均非0 才为 1
endmodule
