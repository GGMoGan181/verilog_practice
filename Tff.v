`timescale 1ns/1ps
module Tff(
    input  wire data,
    input  wire clk,
    input  wire rst_n,
    output reg  out
);
    reg q1;
    always@ (posedge clk or negedge rst_n) begin
        if (!rst_n)begin
            q1<=1'b0;

        end
        else begin
            if(data)
                q1<=~q1;
            else 
                q1<=q1;

        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            out<=1'b0;
        end
        else begin
            if(q1)
                out<=~out;
            else 
                out<= out;
        end
    end
endmodule

//=====================================================
// 范例模块 Tff_ref：参考答案（供对照学习），原模块 Tff 请自行完成
// 题目：两级 T 触发器级联——data=1 时第一级每拍翻转，第二级以 q1 为 T 输入再翻转
// 思路：T 触发器特征方程 Q(n+1) = T ? ~Q : Q，用两个独立 always 块分别描述两级
// 关键点：① 一个 reg 只能被一个 always 块驱动；② 异步复位低有效，两个 always 都要复位
//=====================================================
module Tff_ref(
    input  wire data,
    input  wire clk,
    input  wire rst_n,
    output reg  out
);
    reg q1;   // 第一级 T 触发器输出

    // 第一级：T 输入 = data，data=1 时每拍翻转（二分频），data=0 时保持
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q1 <= 1'b0;              // 异步复位清零
        else if (data)
            q1 <= ~q1;               // T=1：翻转
        // data=0 时不写 q1，寄存器默认保持，可省略 else 分支
    end

    // 第二级：T 输入 = q1，q1=1 时 out 每拍翻转（对 q1 再二分频）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 1'b0;
        else if (q1)
            out <= ~out;
    end
endmodule