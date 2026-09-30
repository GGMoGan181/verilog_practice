`timescale 1ns/1ns
//=====================================================
// 哲K VL2 使用握手信号实现跨时钟域数据传输（较难）
// req/ack 握手：源域发 req 并保持数据稳定，目的域采样后回 ack
//=====================================================
module handshake_cdc #(parameter DW = 8)(
    input  wire         src_clk,
    input  wire         dst_clk,
    input  wire         rst_n,
    input  wire [DW-1:0] din,
    input  wire         din_valid,
    output reg  [DW-1:0] dout,
    output reg           dout_valid
);
    // TODO: 源域 req 寄存器+数据锁存；目的域两级同步 req->采样->ack；源域等 ack 撤销
    always @(*) begin dout = {DW{1'b0}}; dout_valid = 1'b0; end
endmodule

//=====================================================
// 范例模块 handshake_cdc_ref：参考答案，原模块 handshake_cdc 请自行完成
// 题目：req/ack 四相握手跨时钟域传数据
// 思路：源域：din_valid 时锁存数据并拉 req，等 ack 同步回来后撒 req；
//       目的域：req 两级同步，升沿锁数据+给 dout_valid 一拍并拉 ack，
//       看到 req 撤销后再撒 ack
// 关键点：① 数据在 req 拉高期间全程稳定，目的域才能安全采；
//         ② req/ack 跨域都要两级同步；③ 四相=req↑ ack↑ req↓ ack↓
//=====================================================
module handshake_cdc_ref #(parameter DW = 8)(
    input  wire         src_clk,
    input  wire         dst_clk,
    input  wire         rst_n,
    input  wire [DW-1:0] din,
    input  wire         din_valid,
    output reg  [DW-1:0] dout,
    output reg           dout_valid
);
    reg          req;                 // 源域请求
    reg [DW-1:0] data_lat;            // 源域数据锁存（req 期间稳定）
    reg          ack1, ack2;          // ack 回源域两级同步
    reg          req1, req2, req3;    // req 入目的域两级同步+边沿检测
    reg          ack;                 // 目的域应答
    // 源域：发 req / 等 ack 后撤销
    always @(posedge src_clk or negedge rst_n)
        if (!rst_n) begin
            req <= 1'b0; data_lat <= {DW{1'b0}}; ack1 <= 1'b0; ack2 <= 1'b0;
        end
        else begin
            ack1 <= ack;  ack2 <= ack1;             // ack 同步回源域
            if (din_valid && !req) begin            // 空闲且有新数据：发请求
                data_lat <= din;
                req      <= 1'b1;
            end
            else if (req && ack2)                   // 看到 ack：撤销请求
                req <= 1'b0;
        end
    // 目的域：同步 req、采数据、回 ack
    always @(posedge dst_clk or negedge rst_n)
        if (!rst_n) begin
            req1 <= 1'b0; req2 <= 1'b0; req3 <= 1'b0;
            ack <= 1'b0; dout <= {DW{1'b0}}; dout_valid <= 1'b0;
        end
        else begin
            req1 <= req; req2 <= req1; req3 <= req2;   // req 两级同步+打拍
            if (req2 && !req3) begin                   // req 升沿：采数据
                dout       <= data_lat;
                dout_valid <= 1'b1;
                ack        <= 1'b1;
            end
            else
                dout_valid <= 1'b0;                    // valid 只给一拍
            if (!req2 && req3)                         // req 已撤销：撒 ack
                ack <= 1'b0;
        end
endmodule
