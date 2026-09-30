`timescale 1ns/1ns
//=====================================================
// 华W VL1 并串转换（中等）
// 并行数据装入后逐位串行输出（高位先出），busy 指示发送中
//=====================================================
module parallel_to_serial #(parameter DW = 8)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire [DW-1:0] din,
    input  wire         load,       //并行装入
    output reg          dout_serial,//串行输出
    output reg          busy        //发送中
);
    // TODO: load 时装入移位寄存器；逐拍左移输出 MSB；计满 DW 拍清 busy
    always @(*) begin dout_serial = 1'b0; busy = 1'b0; end
endmodule

//=====================================================
// 范例模块 parallel_to_serial_ref：参考答案，原模块 parallel_to_serial 请自行完成
// 题目：load 装入并行数据，之后每拍串行吐出一位（高位先出），busy 指示发送中
// 思路：装入时把 din 左移一位存进移位寄存器并先吐 MSB；
//       之后每拍吐 shifter 的 MSB 并左移；计满 DW 拍清 busy
// 关键点：① busy 期间不响应新 load；② 计数到 DW 才结束，共吐 DW 位
//=====================================================
module parallel_to_serial_ref #(parameter DW = 8)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire [DW-1:0] din,
    input  wire         load,
    output reg          dout_serial,
    output reg          busy
);
    reg [DW-1:0] shifter;   // 移位寄存器
    reg [7:0]    cnt;       // 已发送位数（DW≤256）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shifter <= {DW{1'b0}}; cnt <= 8'd0;
            dout_serial <= 1'b0;   busy <= 1'b0;
        end
        else if (load && !busy) begin          // 装入：先吐 MSB
            shifter     <= din << 1;
            dout_serial <= din[DW-1];
            cnt         <= 8'd1;
            busy        <= 1'b1;
        end
        else if (busy) begin
            if (cnt == DW) begin               // 发完 DW 位
                busy        <= 1'b0;
                dout_serial <= 1'b0;
            end
            else begin
                dout_serial <= shifter[DW-1];  // 吐当前 MSB
                shifter     <= shifter << 1;   // 左移准备下一位
                cnt         <= cnt + 1'b1;
            end
        end
    end
endmodule
