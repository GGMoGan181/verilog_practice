`timescale 1ns/1ns
//=====================================================
// 哲K VL3 自动售卖机（中等）
// FSM：投币累计->达到售价出货（可含找零）
//=====================================================
module vending_machine(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] coin,      //币种/投币脉冲编码
    output reg        goods,     //出货
    output reg        change     //找零
);
    // TODO: 状态=累计金额；>=售价出货，超额找零，回初始态
    always @(*) begin goods = 1'b0; change = 1'b0; end
endmodule

//=====================================================
// 范例模块 vending_machine_ref：参考答案，原模块 vending_machine 请自行完成
// 题目：投币累计→达售价出货，超额找零（本例：售价5，coin=01投1/10投2）
// 思路：状态=累计金额 total（金额即状态编码的 Moore 思路）；
//       每拍把币值累加，达到/超过售价：出货一拍、超额则找零一拍、金额清零
// 关键点：① 出货/找零是脉冲，先默认清0再条件置1；
//         ② 币种编码与售价以题目为准，改 add 与阈值即可
//=====================================================
module vending_machine_ref(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] coin,
    output reg        goods,
    output reg        change
);
    localparam PRICE = 4'd5;             // 售价（按题意改）
    reg [3:0] total;                     // 累计金额（=FSM 状态）
    wire [3:0] add = (coin == 2'b01) ? 4'd1 :
                     (coin == 2'b10) ? 4'd2 : 4'd0;   // 币值解码
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            total <= 4'd0; goods <= 1'b0; change <= 1'b0;
        end
        else begin
            goods <= 1'b0; change <= 1'b0;          // 脉冲默认清0
            if (total + add >= PRICE) begin          // 达到/超过售价
                goods  <= 1'b1;                      // 出货一拍
                change <= (total + add > PRICE);     // 超额才找零
                total  <= 4'd0;                      // 回初始态
            end
            else
                total <= total + add;                // 继续累计
        end
    end
endmodule
