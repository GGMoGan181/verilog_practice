`timescale 1ns/1ns
//=====================================================
// 华W VL6 同步FIFO（中等）
// 单时钟 FIFO：计数法/指针法维护 full/empty
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
    // TODO: reg 数组 + 写/读指针或计数；维护满/空
    always @(*) rd_data = {DW{1'b0}};
endmodule

//=====================================================
// 范例模块 sync_fifo_ref：参考答案，原模块 sync_fifo 请自行完成
// 题目：单时钟同步 FIFO：双指针环状存储 + 计数法维护 full/empty
// 思路：写指针 wptr 环状递增写 mem；读指针 rptr 环状递增读；
//       用 cnt 记录存量，写+1 读-1，cnt==DEPTH 满、cnt==0 空；
//       满禁写、空禁读
// 关键点：① 同一拍既写又读时 cnt 不变，不会误报满/空；
//         ② 本例读为寄存器输出（晚一拍），要组合读改 assign+wire
//=====================================================
module sync_fifo_ref #(parameter DW = 8, DEPTH = 16)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         wr_en,
    input  wire         rd_en,
    input  wire [DW-1:0] wr_data,
    output reg  [DW-1:0] rd_data,
    output reg           full,
    output reg           empty
);
    reg [DW-1:0] mem [0:DEPTH-1];   // 存储阵列
    reg [7:0]    wptr, rptr;        // 写/读指针（DEPTH≤256）
    reg [7:0]    cnt;               // 存量计数
    wire wr_ok = wr_en && !full;    // 满禁写
    wire rd_ok = rd_en && !empty;   // 空禁读
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wptr <= 8'd0; rptr <= 8'd0; cnt <= 8'd0;
            full <= 1'b0; empty <= 1'b1; rd_data <= {DW{1'b0}};
        end
        else begin
            if (wr_ok) begin
                mem[wptr] <= wr_data;                          // 写
                wptr <= (wptr == DEPTH-1) ? 8'd0 : wptr + 1'b1; // 环状回卷
            end
            if (rd_ok) begin
                rd_data <= mem[rptr];                          // 读（寄存输出）
                rptr <= (rptr == DEPTH-1) ? 8'd0 : rptr + 1'b1;
            end
            cnt   <= cnt + wr_ok - rd_ok;                      // 存量更新
            full  <= (cnt + wr_ok - rd_ok == DEPTH);           // 下拍满?
            empty <= (cnt + wr_ok - rd_ok == 8'd0);            // 下拍空?
        end
    end
endmodule
