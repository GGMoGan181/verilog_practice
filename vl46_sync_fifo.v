`timescale 1ns/1ns
//=====================================================
// VL46 同步FIFO
// 单一时钟；用计数法或指针法维护满/空标志
//=====================================================
module sync_fifo #(parameter DW = 8, DEPTH = 16)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         wr_en,
    input  wire         rd_en,
    input  wire [DW-1:0] wr_data,
    output reg  [DW-1:0] rd_data,
    output reg           full,
    output reg           empty
);
    // TODO: reg 数组存储 + 写/读指针或计数；同时读写注意满/空更新
    always @(*) rd_data = {DW{1'b0}};
endmodule

//=====================================================
// 范例模块 sync_fifo_ref：参考答案（供对照学习），原模块请自行完成
// 题目：同步 FIFO——单一时钟，计数法维护满/空标志
// 思路：mem 数组 + 写/读指针环状回卷 + cnt 存量计数；满禁写、空禁读，
//       同时读写时存量不变但两个指针都前进
// 关键点：① wr_ok/rd_ok 先行排除非法操作，避免满写/空读破坏数据；
//         ② cnt 更新用 wr_ok-rd_ok，同时读写时自然抵消；③ 全部寄存器单一 always 块驱动
//=====================================================
module sync_fifo_ref #(parameter DW = 8, DEPTH = 16)(
    input  wire          clk,
    input  wire          rst_n,
    input  wire          wr_en,
    input  wire          rd_en,
    input  wire [DW-1:0] wr_data,
    output reg  [DW-1:0] rd_data,
    output reg           full,
    output reg           empty
);
    localparam AW = $clog2(DEPTH);

    reg [DW-1:0] mem [0:DEPTH-1];   // 存储阵列
    reg [AW-1:0] wptr, rptr;        // 写/读指针（环状回卷）
    reg [AW:0]   cnt;               // 存量计数（0~DEPTH，多 1 位）

    wire wr_ok = wr_en && !full;    // 满时禁写
    wire rd_ok = rd_en && !empty;   // 空时禁读

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wptr  <= {AW{1'b0}};
            rptr  <= {AW{1'b0}};
            cnt   <= 0;
            full  <= 1'b0;          // 复位后空：empty=1、full=0
            empty <= 1'b1;
            rd_data <= {DW{1'b0}};
        end
        else begin
            // 写入：写指针环状前进
            if (wr_ok) begin
                mem[wptr] <= wr_data;
                wptr      <= (wptr == DEPTH - 1) ? {AW{1'b0}} : wptr + 1'b1;
            end
            // 读出：读指针环状前进，数据下一拍有效
            if (rd_ok) begin
                rd_data <= mem[rptr];
                rptr    <= (rptr == DEPTH - 1) ? {AW{1'b0}} : rptr + 1'b1;
            end
            // 存量更新：同时读写时 +1-1 抵消
            cnt   <= cnt + wr_ok - rd_ok;
            full  <= (cnt + wr_ok - rd_ok == DEPTH);
            empty <= (cnt + wr_ok - rd_ok == 0);
        end
    end
endmodule
