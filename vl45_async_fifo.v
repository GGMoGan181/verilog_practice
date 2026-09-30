`timescale 1ns/1ns
//=====================================================
// VL45 异步FIFO
// 写/读分属两个时钟域；指针用格雷码跨时钟域同步，比较产生 full/empty
//=====================================================
module async_fifo #(parameter DW = 8, AW = 4)(
    input  wire         wr_clk,
    input  wire         rd_clk,
    input  wire         rst_n,
    input  wire         wr_en,
    input  wire         rd_en,
    input  wire [DW-1:0] wr_data,
    output reg  [DW-1:0] rd_data,
    output wire          full,
    output wire          empty
);
    // TODO: 双口存储 + 格雷码写/读指针 + 两级同步 + full/empty 判断
    always @(*) rd_data = {DW{1'b0}};
    assign full = 1'b0;
    assign empty = 1'b1;
endmodule

//=====================================================
// 范例模块 async_fifo_ref：参考答案（供对照学习），原模块请自行完成
// 题目：异步 FIFO——读写分属两个时钟域，格雷码指针跨域同步产生 full/empty
// 思路：① 双口 RAM 存储；② 读写指针各多 1 位（回卷区分满/空），格雷码计数；
//       ③ 对方指针经两级同步器进入本时钟域后比较：
//       写域：wr_gray == {~rd_gray_s[AW:AW-1], rd_gray_s[AW-2:0]} -> full（高两位相反其余相同）
//       读域：rd_gray == wr_gray_s -> empty
// 关键点：① 格雷码相邻只变 1 位，跨域采样不会采到多跳变中间态；② 满/空判断
//       偏保守（同步延迟只会误报不会漏报，安全）；③ 空时禁读、满时禁写
//=====================================================
module async_fifo_ref #(parameter DW = 8, AW = 4)(
    input  wire          wr_clk,
    input  wire          rd_clk,
    input  wire          rst_n,
    input  wire          wr_en,
    input  wire          rd_en,
    input  wire [DW-1:0] wr_data,
    output reg  [DW-1:0] rd_data,
    output wire          full,
    output wire          empty
);
    // 双口存储：写口在 wr_clk 域，读口在 rd_clk 域
    reg [DW-1:0] mem [0:(1<<AW)-1];

    reg  [AW:0] wr_bin, wr_gray;   // 写指针：二进制 + 格雷码（多 1 位用于回卷判满/空）
    reg  [AW:0] rd_bin, rd_gray;
    reg  [AW:0] wr_gray_s1, wr_gray_s2;   // 写指针同步到读域（两级）
    reg  [AW:0] rd_gray_s1, rd_gray_s2;   // 读指针同步到写域（两级）

    wire wr_ok = wr_en && !full;   // 满时禁写
    wire rd_ok = rd_en && !empty;  // 空时禁读

    // 写指针（wr_clk 域）：二进制加 1，再转格雷码
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_bin  <= 0;
            wr_gray <= 0;
        end
        else if (wr_ok) begin
            wr_bin  <= wr_bin + 1'b1;
            wr_gray <= ((wr_bin + 1'b1) >> 1) ^ (wr_bin + 1'b1);   // 二进制转格雷码
        end
    end

    // 读指针（rd_clk 域）
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_bin  <= 0;
            rd_gray <= 0;
        end
        else if (rd_ok) begin
            rd_bin  <= rd_bin + 1'b1;
            rd_gray <= ((rd_bin + 1'b1) >> 1) ^ (rd_bin + 1'b1);
        end
    end

    // 写口：满时禁止写入
    always @(posedge wr_clk) begin
        if (wr_ok)
            mem[wr_bin[AW-1:0]] <= wr_data;   // 低 AW 位作地址
    end

    // 读口：空时禁止读出
    always @(posedge rd_clk) begin
        if (rd_ok)
            rd_data <= mem[rd_bin[AW-1:0]];
    end

    // 两级同步器：写指针 -> 读域
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_gray_s1 <= 0;
            wr_gray_s2 <= 0;
        end
        else begin
            wr_gray_s1 <= wr_gray;
            wr_gray_s2 <= wr_gray_s1;
        end
    end

    // 两级同步器：读指针 -> 写域
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_gray_s1 <= 0;
            rd_gray_s2 <= 0;
        end
        else begin
            rd_gray_s1 <= rd_gray;
            rd_gray_s2 <= rd_gray_s1;
        end
    end

    // 满：写格雷码追上读格雷码一圈——高两位相反、其余位相同
    assign full = (wr_gray == {~rd_gray_s2[AW:AW-1], rd_gray_s2[AW-2:0]});
    // 空：读格雷码 == 同步过来的写格雷码
    assign empty = (rd_gray == wr_gray_s2);
endmodule
