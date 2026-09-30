`timescale 1ns/1ns
//=====================================================
// VL36 状态机-重叠序列检测
// 检测目标序列（示例 0110）；命中后利用最长公共前后缀继续检测，允许重叠
//=====================================================
module fsm_overlap(
    input  wire clk,
    input  wire rst_n,
    input  wire a,          //串行输入
    output reg  match       //命中指示
);
    // TODO: 三段/两段式 FSM；命中后按"最长可用后缀"跳转（重叠）
    always @(*) match = 1'b0;
endmodule

//=====================================================
// 范例模块 fsm_overlap_ref：参考答案（供对照学习），原模块请自行完成
// 题目：重叠序列检测（目标 0110），命中后按最长公共前后缀继续检测
// 思路：三段式 FSM；重叠的关键在命中态 S4 的出边：
//       "0110"+1 = "01101" 后缀 "01" -> S2；"0110"+0 = "01100" 后缀 "0" -> S1
// 关键点：① 与非重叠版唯一区别是 S4 的次态；② 典型重叠用例 "0110110"：
//       第一次命中后利用后缀 "01" 可再次命中；③ Moore 输出维持一拍
//=====================================================
module fsm_overlap_ref(
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire match
);
    // 状态编码：已匹配到的 "0110" 前缀长度
    localparam IDLE = 3'd0,   // 未匹配任何前缀
               S1   = 3'd1,   // 已匹配 "0"
               S2   = 3'd2,   // 已匹配 "01"
               S3   = 3'd3,   // 已匹配 "011"
               S4   = 3'd4;   // 已匹配 "0110" -> 命中

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
            IDLE: nxt_state = a ? IDLE : S1;   // 收到 0 才开始匹配
            S1:   nxt_state = a ? S2   : S1;   // "01"->S2；"00" 后缀 "0"->S1
            S2:   nxt_state = a ? S3   : S1;   // "011"->S3；"010" 后缀 "0"->S1
            S3:   nxt_state = a ? IDLE : S4;   // "0111" 无可用后缀；"0110" 命中
            S4:   nxt_state = a ? S2   : S1;   // 重叠："01101"后缀"01"->S2；"01100"后缀"0"->S1
            default: nxt_state = IDLE;
        endcase
    end

    // ③ 组合：Moore 输出，仅 S4 态拉高
    assign match = (cur_state == S4);
endmodule
