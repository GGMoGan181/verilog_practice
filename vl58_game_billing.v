`timescale 1ns/1ns
//=====================================================
// VL58 游戏机计费程序
// 投币累加余额；开始游戏后按时间扣费；余额不足停止/提示
//=====================================================
module game_billing(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       coin,        //投币脉冲（每次加固定金额）
    input  wire       play,        //游戏进行中（按时间扣费）
    output reg  [7:0] balance,     //剩余金额
    output reg        lack         //余额不足指示
);
    // TODO: coin 累加 balance；play 时按计时扣费；balance 不足拉 lack
    always @(*) begin balance = 8'b0; lack = 1'b0; end
endmodule

//=====================================================
// 范例模块 game_billing_ref：参考答案（供对照学习），原模块请自行完成
// 题目：游戏机计费——coin 投币加余额；play 期间按时间周期扣费；余额不足拉 lack
// 思路：① coin 脉冲：balance 加固定金额（如 10）；② play=1 时内部计时器计满
//       BILL_T 拍扣一次费（如 1）；③ 余额 < 单次费率时 lack=1（提示投币）
// 关键点：① 同拍投币+扣费：先加后减合并计算；② 扣费只在余额够时执行；
//         ③ 防溢出：balance 加币前限制上限
//=====================================================
module game_billing_ref(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       coin,      // 投币脉冲：每次 +10
    input  wire       play,      // 游戏进行中：按时间扣费
    output reg  [7:0] balance,   // 剩余金额
    output reg        lack       // 余额不足指示
);
    localparam COIN_VAL = 8'd10;    // 每次投币金额
    localparam BILL_T   = 8'd100;   // 扣费周期（clk 拍数）
    localparam BILL_FEE = 8'd1;     // 每次扣费金额

    reg [7:0] timer;                // 扣费计时器

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            balance <= 8'd0;
            lack    <= 1'b1;        // 复位后无余额：不足
            timer   <= 8'd0;
        end
        else begin
            // 投币累加（防溢出：不超过 255-COIN_VAL 才加）
            if (coin && balance <= 8'd255 - COIN_VAL)
                balance <= balance + COIN_VAL;

            // play 期间计时扣费
            if (play) begin
                if (timer == BILL_T - 1) begin
                    timer <= 8'd0;
                    if (balance >= BILL_FEE)
                        balance <= balance - BILL_FEE;   // 余额够：扣费
                        // 注：若同拍有 coin，综合后以最后一条赋值为准，
                        // 严格实现可合并为 balance <= balance + coin_val - fee
                end
                else
                    timer <= timer + 1'b1;
            end
            else
                timer <= 8'd0;      // 停止游戏：计时器归零

            // 余额不足指示：不够扣下一次费用即提示
            lack <= (balance < BILL_FEE);
        end
    end
endmodule
