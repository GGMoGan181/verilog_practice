`timescale 1ns/1ns
//=====================================================
// VL32 非整数倍数据位宽转换 24to128
// 输入 24bit/拍，输出 128bit/拍；128/24 非整数，需缓冲对齐
// 思路：大位宽缓冲寄存器 + 比特计数，攒够 128bit 才输出并左移丢弃
//=====================================================
module width_24to128(
    input  wire         clk,
    input  wire         rst_n,
    input  wire [23:0]  din,
    input  wire         din_valid,
    output reg  [127:0] dout,
    output reg          dout_valid
);
    // TODO: 缓冲 buf(>=128+24bit) + 比特计数 bits；bits>=128 时输出高128位并移位
    always @(*) begin dout = 128'b0; dout_valid = 1'b0; end
endmodule

//=====================================================
// 范例模块 width_24to128_ref：参考答案（供对照学习），原模块请自行完成
// 题目：24bit/拍 转 128bit/拍（非整数倍），数据按先到在高位拼接，攒够 128bit 输出
// 思路：152bit（128+24）大缓冲 + 比特计数：每拍左移 24 位并入新数据；
//       计数 >=128 时取缓冲高 128 位输出，剩余位左移 128 位对齐、计数减 128
// 关键点：① 非整数倍转换的通用模板（buf+bits 计数）；② 一拍只输出一次，
//       24<128 不会一拍积攬够两个输出；③ 先到数据在高位：左移入缓冲
//=====================================================
module width_24to128_ref(
    input  wire         clk,
    input  wire         rst_n,
    input  wire [23:0]  din,
    input  wire         din_valid,
    output reg  [127:0] dout,
    output reg          dout_valid
);
    reg [151:0] buf;    // 大缓冲：最多存 127bit 余量 + 24bit 新数据 = 151bit
    reg [7:0]   bits;   // 缓冲中有效比特数（0~151）

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buf        <= 152'd0;
            bits       <= 8'd0;
            dout       <= 128'd0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;                    // 默认无输出
            if (din_valid) begin
                // 新数据左移入缓冲低位端，先到数据自然在高位
                buf  <= {buf[127:0], din};
                bits <= bits + 8'd24;
                // 攒够 128bit：取高 128 位输出（含本拍新入的 24bit）
                if (bits + 8'd24 >= 8'd128) begin
                    dout       <= {buf[103:0], din};   // 高 104 旧位 + 24 新位 = 128
                    dout_valid <= 1'b1;
                    // 余下 r=bits+24-128 位：左移 128 位后仍 MSB 对齐，保留在缓冲高端
                    buf        <= {buf[127:0], din} << 128;
                    bits       <= bits + 8'd24 - 8'd128;
                end
            end
        end
    end
endmodule
