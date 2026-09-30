`timescale 1ns/1ns
// 时序逻辑 VL2 根据状态转移图实现时序电路：按给定状态图写 FSM
module seq_fsm_diagram(input wire clk, input wire rst_n, input wire a, output reg q);
    // TODO: 状态寄存器 + 按状态转移图写次态 + 输出
    always @(*) q = 1'b0;
endmodule

//=====================================================
// 范例模块 seq_fsm_diagram_ref：参考答案，原模块 seq_fsm_diagram 请自行完成
// 题目：按状态转移图写 FSM（本例：IDLE->A->B 三态循环，B 态输出 1）
// 思路：图上的"圆圈"=状态、"箭头条件"=case 分支；
//       两段式：状态寄存器 + 次态 case；输出 q=(state==B)
// 关键点：把图上每条箭头的条件写进对应状态分支，不遗漏自环箭头
//=====================================================
module seq_fsm_diagram_ref(input wire clk, input wire rst_n, input wire a, output reg q);
    localparam IDLE = 2'd0, A = 2'd1, B = 2'd2;   // 三个状态
    reg [1:0] state, nxt;
    // ① 状态寄存器
    always @(posedge clk or negedge rst_n)
        if (!rst_n) state <= IDLE;
        else        state <= nxt;
    // ② 次态：按状态转移图的箭头
    always @(*) begin
        case (state)
            IDLE:    nxt = a ? A    : IDLE;   // 箭头：IDLE --a=1--> A，否则自环
            A:       nxt = a ? A    : B;      // 箭头：A --a=0--> B，否则自环
            B:       nxt = a ? IDLE : B;      // 箭头：B --a=1--> IDLE，否则自环
            default: nxt = IDLE;
        endcase
    end
    // ③ Moore 输出：只有 B 态输出 1
    always @(*) q = (state == B);
endmodule
