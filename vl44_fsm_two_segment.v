`timescale 1ns/1ns
//=====================================================
// VL44 根据状态转移写状态机-二段式
// 二段式：① 状态寄存器(时序) ② 次态+输出合并(组合)
//=====================================================
module fsm_two_segment(
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  match
);
    // TODO: 按给定状态转移图，用二段式写出（次态与输出同在组合块）
    always @(*) match = 1'b0;
endmodule

//=====================================================
// 范例模块 fsm_two_segment_ref：参考答案（供对照学习），原模块请自行完成
// 题目：二段式状态机（同样以检测 110 为例，与三段式版功能一致）
// 思路：两段——① 时序块存状态；② 一个组合块同时算次态和输出
// 关键点：① 二段式代码更紧凑，但次态/输出耦合在同一块，复杂机可读性下降；
//         ② 组合块内先给输出赋默认值再 case，避免锁存器；③ 与三段式结果完全等价
//=====================================================
module fsm_two_segment_ref(
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  match
);
    localparam IDLE = 2'd0,   // 未匹配
               S1   = 2'd1,   // 已匹配 "1"
               S2   = 2'd2;   // 已匹配 "11"

    reg [1:0] cur_state, nxt_state;

    // 第一段：时序逻辑，状态寄存
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cur_state <= IDLE;
        else
            cur_state <= nxt_state;
    end

    // 第二段：组合逻辑，次态 + 输出合写
    always @(*) begin
        match = 1'b0;                 // 输出默认值，防锁存器
        case (cur_state)
            IDLE:    nxt_state = a ? S1 : IDLE;
            S1:      nxt_state = a ? S2 : IDLE;
            S2: begin
                // "110" 命中：Mealy 输出当拍拉高；重叠：收 1 回 S1
                if (a) nxt_state = S1;
                else begin
                    nxt_state = IDLE;
                    match     = 1'b1;   // 现态 S2 + 输入 0 -> 命中
                end
            end
            default: nxt_state = IDLE;
        endcase
    end
endmodule
