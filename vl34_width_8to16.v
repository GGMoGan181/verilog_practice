`timescale 1ns/1ns
//=====================================================
// VL34 整数倍数据位宽转换 8to16
// 输入 8bit/拍，输出 16bit/拍；比例 2：每 2 个输入拼成 1 个输出
//=====================================================
module width_8to16(
    input  wire         clk,
    input  wire         rst_n,
    input  wire [7:0]   din,
    input  wire         din_valid,
    output reg  [15:0]  dout,
    output reg          dout_valid
);
    // TODO: 暂存第一拍为高字节，第二拍拼接 {hi,din} 输出并拉高 valid
    always @(*) begin dout = 16'b0; dout_valid = 1'b0; end
endmodule

//=====================================================
// 范例模块 width_8to16_ref：参考答案（供对照学习），原模块请自行完成
// 题目：8bit/拍 转 16bit/拍（整数倍 2:1），先到的字节作高 8 位
// 思路：标志位法——第一拍存高字节置 flag，第二拍拼接 {hi,din} 输出并清 flag
// 关键点：① 整数倍转换无需大缓冲，一个暂存寄存器 + 1bit 标志即可；
//         ② dout_valid 每两拍拉高一次，仅维持一拍
//=====================================================
module width_8to16_ref(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  din,
    input  wire        din_valid,
    output reg [15:0]  dout,
    output reg         dout_valid
);
    reg [7:0] hi;     // 暂存第一拍收到的高字节
    reg       flag;   // 0=等待高字节；1=高字节已存，等低字节

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hi         <= 8'd0;
            flag       <= 1'b0;
            dout       <= 16'd0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;               // 默认无输出
            if (din_valid) begin
                if (!flag) begin
                    hi   <= din;              // 第一拍：存高字节
                    flag <= 1'b1;
                end
                else begin
                    dout       <= {hi, din};  // 第二拍：高字节在前拼接输出
                    dout_valid <= 1'b1;       // 拉高一拍
                    flag       <= 1'b0;       // 回到等待高字节状态
                end
            end
        end
    end
endmodule
