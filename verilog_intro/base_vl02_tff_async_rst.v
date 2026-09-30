`timescale 1ns/1ns
// 基础语法 VL2 异步复位的串联T触发器：T FF 级联，异步低复位
module tff_chain(input wire clk, input wire rst_n, input wire t, output reg q);
    reg q0;   // TODO: 两级 T 触发器串联，posedge clk / negedge rst_n
    always @(*) q = 1'b0;
endmodule

//=====================================================
// 范例模块 tff_chain_ref：参考答案（供对照学习），原模块 tff_chain 请自行完成
// 题目：两级 T 触发器串联（第一级输出作第二级的 T 输入），异步低复位
// 思路：T 触发器特性：T=1 时钟沿翻转，T=0 保持；
//       第一级 T=t，第二级 T=q0，两级都用 posedge clk 且 negedge rst_n 异步清零
// 关键点：异步复位要把 negedge rst_n 写进敏感列表，复位分支优先级最高
//=====================================================
module tff_chain_ref(input wire clk, input wire rst_n, input wire t, output reg q);
    reg q0;   // 第一级 T 触发器输出
    // 第一级：T 输入为 t
    always @(posedge clk or negedge rst_n)
        if (!rst_n)      q0 <= 1'b0;      // 异步低复位
        else if (t)      q0 <= ~q0;       // T=1 翻转
        // else 保持（不写即保持）
    // 第二级：T 输入为第一级输出 q0，形成串联
    always @(posedge clk or negedge rst_n)
        if (!rst_n)      q  <= 1'b0;
        else if (q0)     q  <= ~q;
endmodule
