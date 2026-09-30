`timescale 1ns/1ns
//============================================================
// 序列检测（状态机 FSM 实现）：每 6 位输入为一组，判断整组是否等于 011100
//   - 固定分组、不重叠：第1~6位为第一组，第7位起是下一组的第一位
//   - 组内一旦某位失配 -> 进 FAIL，本组剩余位不再参与匹配，等到组末统一判 not_match
//   - 组末(第6位, cnt==5)输出脉冲：整组==011100 -> match=1；否则 not_match=1
//   - 状态表示"本组从第1位起已连续匹配到第几位"：
//        IDLE(第1位) ONE(第2位) TWO(第3位) THREE(第4位) FOUR(第5位) FIVE(第6位)
//        FAIL = 本组已失配，等待组末
//   三段式：① 状态/计数寄存器  ② 次态组合  ③ 输出(寄存器,组边界脉冲)
//============================================================
module sequence_detect(
    input  wire clk,
    input  wire rst_n,      //低电平异步复位
    input  wire a,          //串行输入（题目接口信号 a）
    output reg  match,      //整组==011100 指示（组边界脉冲）
    output reg  not_match   //整组!=011100 指示（组边界脉冲）
);
    //状态编码（3 位二进制，0~6）
    localparam IDLE  = 3'd0,   //第1位：尚未匹配
               ONE   = 3'd1,   //已匹配 "0"
               TWO   = 3'd2,   //已匹配 "01"
               THREE = 3'd3,   //已匹配 "011"
               FOUR  = 3'd4,   //已匹配 "0111"
               FIVE  = 3'd5,   //已匹配 "01110"，等待第6位
               FAIL  = 3'd6;   //本组已失配，等待组末

    reg [2:0] state, nxt_state;
    reg [2:0] cnt;             //组内位计数 0~5

    //① 时序：状态寄存器 + 组内计数器（cnt 模6循环）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt   <= 3'd0;
        end
        else begin
            state <= nxt_state;
            cnt   <= (cnt == 3'd5) ? 3'd0 : cnt + 1'b1;
        end
    end

    //② 组合：次态（匹配链 / 失配进 FAIL / 组末回 IDLE）
    always @(*) begin
        case (state)
            IDLE : nxt_state = (a == 1'b0) ? ONE  : FAIL;  //第1位:0->继续,1->本组失配
            ONE  : nxt_state = (a == 1'b1) ? TWO  : FAIL;  //第2位:1->继续,0->失配
            TWO  : nxt_state = (a == 1'b1) ? THREE: FAIL;  //第3位:1->继续,0->失配
            THREE: nxt_state = (a == 1'b1) ? FOUR : FAIL;  //第4位:1->继续,0->失配
            FOUR : nxt_state = (a == 1'b0) ? FIVE : FAIL;  //第5位:0->继续,1->失配
            FIVE : nxt_state = IDLE;                       //第6位读完->组末,回IDLE开新组
            FAIL : nxt_state = (cnt == 3'd5) ? IDLE : FAIL;//失配后等到组末才回IDLE
            default: nxt_state = IDLE;
        endcase
    end

    //③ 时序：输出（仅在组边界 cnt==5 给一拍脉冲，其余拍为0）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            match     <= 1'b0;
            not_match <= 1'b0;
        end
        else if (cnt == 3'd5) begin
            //第6位这一拍：匹配链走到 FIVE 且本位为0 => 整组 011100
            if (state == FIVE && a == 1'b0) begin
                match     <= 1'b1;
                not_match <= 1'b0;
            end
            else begin
                match     <= 1'b0;
                not_match <= 1'b1;
            end
        end
        else begin
            match     <= 1'b0;
            not_match <= 1'b0;
        end
    end
endmodule
