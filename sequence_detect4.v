`timescale 1ns/1ns
//============================================================
// 状态机(FSM)实现：带 data_valid 门控的序列检测，检测有效位序列 0110
//   - data_valid=1：本拍 data 有效，按输入发生状态转移
//   - data_valid=0：本拍 data 无效，状态保持(自环)，丢弃该输入
//   - 检测到 0110 时进入 S4，match=1（允许重叠检测）
//   三段式：① 状态寄存器  ② 次态组合逻辑  ③ 输出组合逻辑
//============================================================
module sequence_detect(
    input  wire clk,
    input  wire rst_n,       //低电平异步复位
    input  wire data,        //串行输入数据
    input  wire data_valid,  //数据有效指示，高有效
    output reg  match        //序列 0110 匹配指示
);
    //状态编码：状态表示"已匹配到的 0110 前缀长度"
    localparam IDLE = 3'd0,   //未匹配任何前缀
               S1 = 3'd1,   //已匹配 "0"
               S2 = 3'd2,   //已匹配 "01"
               S3 = 3'd3,   //已匹配 "011"
               S4 = 3'd4;   //已匹配 "0110" -> 检测成功

    reg [2:0] cur_state, nxt_state;

    //① 时序逻辑：状态寄存器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cur_state <= IDLE;
        else
            cur_state <= nxt_state;
    end

    //② 组合逻辑：次态（data_valid=0 时保持当前状态，丢弃无效输入）
    always @(*) begin
        if (!data_valid)
            nxt_state = cur_state;
        else begin
            case (cur_state)
                IDLE: nxt_state = data ? IDLE : S1;  //data=0->匹配"0"->S1；data=1无用->IDLE
                S1:   nxt_state = data ? S2 : S1;    //data=1->"01"->S2；data=0->"00"后缀"0"->S1
                S2:   nxt_state = data ? S3 : S1;    //data=1->"011"->S3；data=0->"010"后缀"0"->S1
                S3:   nxt_state = data ? IDLE : S4;  //data=0->"0110"命中->S4；data=1->"0111"->IDLE
                S4:   nxt_state = data ? S2 : S1;    //重叠："01101"后缀"01"->S2；"01100"后缀"0"->S1
                default: nxt_state = IDLE;
            endcase
        end
    end

    //③ 组合逻辑：Moore 输出，仅 S4 拉高 match
    always @(*) begin
        match = (cur_state == S4);
    end
endmodule
