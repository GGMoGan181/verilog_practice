`timescale 1ns/1ns
//=====================================================
// DJ VL2 序列检测器（Moore型）（简单）
// Moore FSM：输出只与当前状态有关（命中态输出1）
//=====================================================
module moore_detector(
    input  wire clk,
    input  wire rst_n,
    input  wire a,          //串行输入
    output reg  match       //Moore 输出：仅命中态为1
);
    // TODO: 三段式/两段式 Moore FSM；输出 = (state==命中态)
    always @(*) match = 1'b0;
endmodule

//=====================================================
// 范例模块 moore_detector_ref：参考答案，原模块 moore_detector 请自行完成
// 题目：Moore 型序列检测器（本例检测 "101"，允许重叠）
// 思路：两段式 Moore：状态寄存器 + 次态 case；
//       输出只与现态有关：match = (state==S3)，命中后晚一拍输出
// 关键点：Moore 与 Mealy 的区别就在输出是否只看现态；
//         命中态的转移要按"最长后缀=前缀"回退以支持重叠检测
//=====================================================
module moore_detector_ref(
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  match
);
    localparam S0 = 2'd0,   // 未匹配
               S1 = 2'd1,   // 已匹配 "1"
               S2 = 2'd2,   // 已匹配 "10"
               S3 = 2'd3;   // 已匹配 "101" → 命中
    reg [1:0] state, nxt;
    // ① 状态寄存器
    always @(posedge clk or negedge rst_n)
        if (!rst_n) state <= S0;
        else        state <= nxt;
    // ② 次态（含重叠回退）
    always @(*) begin
        case (state)
            S0:      nxt = a ? S1 : S0;
            S1:      nxt = a ? S1 : S2;    // "11" 后缀"1" 仍是前缀 → S1
            S2:      nxt = a ? S3 : S0;    // "100" 无公共前后缀 → S0
            S3:      nxt = a ? S1 : S2;    // "1011"→S1，"1010"→S2（重叠）
            default: nxt = S0;
        endcase
    end
    // ③ Moore 输出：仅命中态为 1
    always @(*) match = (state == S3);
endmodule
