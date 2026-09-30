`timescale 1ns/1ns
// 时序逻辑 VL1 根据状态转移表实现时序电路：按给定状态表写 FSM
module seq_fsm_table(input wire clk, input wire rst_n, input wire a, output reg q);
    // TODO: 状态寄存器 + 按状态转移表(case)写次态 + 输出
    always @(*) q = 1'b0;
endmodule

//=====================================================
// 范例模块 seq_fsm_table_ref：参考答案，原模块 seq_fsm_table 请自行完成
// 题目：按给定状态转移表写 FSM（本例两状态 Moore 机演示套路）
// 思路：两段式：①状态寄存器按时钟更新；②组合 case 按表查次态；
//       Moore 输出只与现态有关：q = (state==S1)
// 关键点：case 里每个状态的每个输入组合都要查表写全，加 default
//=====================================================
module seq_fsm_table_ref(input wire clk, input wire rst_n, input wire a, output reg q);
    localparam S0 = 1'b0, S1 = 1'b1;      // 状态编码
    reg state, nxt;                        // 现态/次态
    // ① 状态寄存器：异步低复位
    always @(posedge clk or negedge rst_n)
        if (!rst_n) state <= S0;
        else        state <= nxt;
    // ② 次态组合：严格按状态转移表查表
    always @(*) begin
        case (state)
            S0:      nxt = a ? S1 : S0;   // 表：S0 遇 a=1 跳 S1
            S1:      nxt = a ? S1 : S0;   // 表：S1 遇 a=0 回 S0
            default: nxt = S0;
        endcase
    end
    // ③ Moore 输出：只由现态决定
    always @(*) q = (state == S1);
endmodule
