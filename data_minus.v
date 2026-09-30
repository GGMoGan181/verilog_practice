`timescale 1ns/1ns

module data_minus(
    input clk,rst_n,
    input  [7:0]a,
    input  [7:0]b,
    
    output reg  [8:0]c
    );
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            c<=0;
        end
        else begin
            if(a>b) c<=a-b;
            else c<=b-a;
            
        end
    end
endmodule

//=====================================================
// 范例模块 data_minus_ref：参考答案（供对照学习），原模块 data_minus 请自行完成
// 题目：时序求 |a-b|——每拍输出两数之差的绝对值（c 比 a/b 晚一拍）
// 思路：大数减小数即绝对值；a-b 与 b-a 必有一非负，位宽 9 位容纳借位
// 关键点：① 输出 c 为 reg，须在时钟沿更新；② 复位分支清零 c
//=====================================================
module data_minus_ref(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [8:0] c
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            c <= 9'd0;                 // 异步复位清零
        else if (a > b)
            c <= a - b;                // a 大：直接减
        else
            c <= b - a;                // b 大：反向减，结果即绝对值
    end
endmodule