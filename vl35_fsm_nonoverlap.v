`timescale 1ns/1ns
//=====================================================
// VL35 状态机-非重叠的序列检测
// 检测目标序列（示例 1011）；命中后回到初始态，不重叠计数
//=====================================================
module fsm_nonoverlap(
    input  wire clk,
    input  wire rst_n,
    input  wire a,          //串行输入
    output reg  match       //命中指示
);
    // TODO: 三段/两段式 FSM；命中那一拍回 IDLE（非重叠）
    always @(*) match = 1'b0;
endmodule

//=====================================================
// 范例模块 fsm_nonoverlap_ref：参考答案（供对照学习），原模块请自行完成
// 题目：非重叠序列检测（目标 1011），命中后直接回 IDLE，不利用重叠后缀
// 思路：三段式 FSM——状态表示"已匹配前缀长度"；非重叠的关键：命中态 S4
//       无条件回 IDLE（而重叠版会按最长公共后缀跳 S1/S2）
// 关键点：① 非重叠版同一位不会被两次命中共用；② Moore 输出：match=(现态==S4)，
//         命中后维持一拍；③ 复位回 IDLE
//=====================================================
module fsm_nonoverlap_ref(
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire match
);
    // 状态编码：已匹配到的 "1011" 前缀长度
    localparam IDLE = 3'd0,   // 未匹配任何前缀
               S1   = 3'd1,   // 已匹配 "1"
               S2   = 3'd2,   // 已匹配 "10"
               S3   = 3'd3,   // 已匹配 "101"
               S4   = 3'd4;   // 已匹配 "1011" -> 命中

    reg [2:0] cur_state, nxt_state;

    // ① 时序：状态寄存器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cur_state <= IDLE;
        else
            cur_state <= nxt_state;
    end

    // ② 组合：次态逻辑
    always @(*) begin
        case (cur_state)
            IDLE: nxt_state = a ? S1   : IDLE;   // 收到 1 才开始匹配
            S1:   nxt_state = a ? S1   : S2;     // "11" 后缀仍是 "1"；"10"->S2
            S2:   nxt_state = a ? S3   : IDLE;   // "101"->S3；"100" 无可用后缀
            S3:   nxt_state = a ? S4   : S2;     // "1011"命中；"1010" 后缀 "10"->S2
            S4:   nxt_state = IDLE;              // 非重叠：命中后无条件回初始态
            default: nxt_state = IDLE;
        endcase
    end

    // ③ 组合：Moore 输出，仅 S4 态拉高
    assign match = (cur_state == S4);
endmodule
