`timescale 1ns/1ns
//=====================================================
// 华W VL5 十六进制计数器（中等）
// 4bit 计数器 0x0~0xF 循环（即模16），可带使能
//=====================================================
module hex_counter(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       en,
    output reg  [3:0] hex      //0~F 循环
);
    // TODO: en 时 hex<=hex+1（4bit 自然回卷即模16）
    always @(*) hex = 4'b0;
endmodule

//=====================================================
// 范例模块 hex_counter_ref：参考答案，原模块 hex_counter 请自行完成
// 题目：带使能的 4bit 十六进制计数器：0~F 循环
// 思路：en 时加1；4bit 位宽自然回卷（F+1=0）即模16，无需额外判断
// 关键点：利用位宽截断实现回卷是最简写法；异步低复位清零
//=====================================================
module hex_counter_ref(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       en,
    output reg  [3:0] hex
);
    always @(posedge clk or negedge rst_n)
        if (!rst_n)  hex <= 4'h0;
        else if (en) hex <= hex + 1'b1;   // 4bit 自然回卷：F→0
        // else 保持
endmodule
