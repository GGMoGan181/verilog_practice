`timescale 1ns/1ns
//=====================================================
// VL48 多bit MUX同步器
// 多比特数据跨时钟域：源域握手+MUX选通稳定数据，目的域采样（避免直接打拍亚稳态扩散）
//=====================================================
module multibit_mux_sync #(parameter DW = 8)(
    input  wire         src_clk,
    input  wire         dst_clk,
    input  wire         rst_n,
    input  wire [DW-1:0] din,
    input  wire         din_valid,
    output reg  [DW-1:0] dout,
    output reg           dout_valid
);
    // TODO: 源域 req/hold + MUX 保持数据稳定 -> 目的域两级同步采样 + ack 握手
    always @(*) begin dout = {DW{1'b0}}; dout_valid = 1'b0; end
endmodule

//=====================================================
// 范例模块 multibit_mux_sync_ref：参考答案（供对照学习），原模块请自行完成
// 题目：多 bit 数据跨时钟域——MUX 同步器方案（req/ack 握手 + 数据保持）
// 思路：① 源域：din_valid 时锁存数据到 hold_reg（MUX 选通）并拉高 req；
//       ② 目的域：req 两级同步后采 hold_reg（此时数据已稳定多拍，无亚稳态扩散），
//       拉高 ack；③ ack 回源域两级同步后撤销 req，完成一次四相握手
// 关键点：① 多 bit 数据不能直接打两拍（各 bit 采样时刻不一致会错拍）；
//         ② 数据在 req 期间必须保持不变（hold_reg 选通）；③ 只有单 bit 控制信号跨域
//=====================================================
module multibit_mux_sync_ref #(parameter DW = 8)(
    input  wire          src_clk,
    input  wire          dst_clk,
    input  wire          rst_n,
    input  wire [DW-1:0] din,
    input  wire          din_valid,
    output reg  [DW-1:0] dout,
    output reg           dout_valid
);
    // ---------- 源域 ----------
    reg [DW-1:0] hold_reg;   // 数据保持寄存器：req 期间不变（MUX 选通的数据）
    reg          req;        // 跨域请求
    reg          ack_s1, ack_s2;   // ack 两级同步回源域

    // 源域：锁存数据并发起请求，收到 ack 后撤销
    always @(posedge src_clk or negedge rst_n) begin
        if (!rst_n) begin
            hold_reg <= {DW{1'b0}};
            req      <= 1'b0;
            ack_s1   <= 1'b0;
            ack_s2   <= 1'b0;
        end
        else begin
            ack_s1 <= ack_dst;          // ack 打两拍回源域
            ack_s2 <= ack_s1;
            if (din_valid && !req) begin
                hold_reg <= din;        // 锁存新数据（MUX 选通）
                req      <= 1'b1;       // 发起请求
            end
            else if (ack_s2) begin
                req <= 1'b0;            // 目的域已确认：撤销请求
            end
        end
    end

    // ---------- 目的域 ----------
    reg req_s1, req_s2;      // req 两级同步
    reg ack_dst;             // 应答信号

    always @(posedge dst_clk or negedge rst_n) begin
        if (!rst_n) begin
            req_s1     <= 1'b0;
            req_s2     <= 1'b0;
            ack_dst    <= 1'b0;
            dout       <= {DW{1'b0}};
            dout_valid <= 1'b0;
        end
        else begin
            req_s1     <= req;          // req 打两拍消除亚稳态
            req_s2     <= req_s1;
            dout_valid <= 1'b0;         // 默认无输出
            if (req_s2 && !ack_dst) begin
                // req 稳定后采样保持数据：此时 hold_reg 已稳定多拍，多 bit 一致
                dout       <= hold_reg;
                dout_valid <= 1'b1;     // 输出有效一拍
                ack_dst    <= 1'b1;     // 应答，送回源域
            end
            else if (!req_s2)
                ack_dst <= 1'b0;        // req 撤销后释放应答（四相握手）
        end
    end
endmodule
