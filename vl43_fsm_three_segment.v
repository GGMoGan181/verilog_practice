`timescale 1ns/1ns
//=====================================================
// VL43 根据状态转移写状态机-三段式
// 三段式：① 状态寄存器(时序) ② 次态(组合) ③ 输出(组合或时序)
//=====================================================
module fsm_three_segment(
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  match
);
    // TODO: 按给定状态转移图，用三段式写出（状态寄存器/次态/输出分开）
    always @(*) match = 1'b0;
endmodule

//=====================================================
// 范例模块 fsm_three_segment_ref：参考答案（供对照学习），原模块请自行完成
// 题目：三段式状态机（以检测序列 110 为例，允许重叠）
// 思路：三段式结构——① 时序块只存状态；② 组合块只算次态；③ 输出单独一块
// 关键点：① 三段式职责分离清晰，是最推荐的工程写法；② 本例用 Mealy 输出
//         （match 依赖现态+输入，命中当拍即拉高）；改 Moore 则 match=(cur_state==命中态)；
//         ③ 重叠处理：S2 收到 1 时回 S1（"11" 后缀仍是 "1"）
//=====================================================
module fsm_three_segment_ref(
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  match
);
    // 状态：已匹配的 "110" 前缀长度
    localparam IDLE = 2'd0,   // 未匹配
               S1   = 2'd1,   // 已匹配 "1"
               S2   = 2'd2;   // 已匹配 "11"

    reg [1:0] cur_state, nxt_state;

    // 第一段：时序逻辑，只做状态寄存
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cur_state <= IDLE;
        else
            cur_state <= nxt_state;
    end

    // 第二段：组合逻辑，只算次态
    always @(*) begin
        case (cur_state)
            IDLE:    nxt_state = a ? S1 : IDLE;   // 收到 1 开始匹配
            S1:      nxt_state = a ? S2 : IDLE;   // "11"->S2；"10" 无可用后缀
            S2:      nxt_state = a ? S1 : IDLE;   // "111" 后缀 "1"->S1；"110" 命中回 IDLE
            default: nxt_state = IDLE;
        endcase
    end

    // 第三段：输出逻辑（Mealy：现态 S2 且输入 0 即命中）
    always @(*) begin
        match = (cur_state == S2) && (a == 1'b0);
    end
endmodule
