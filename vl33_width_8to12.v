`timescale 1ns/1ns
//=====================================================
// VL33 非整数倍数据位宽转换 8to12
// 输入 8bit/拍，输出 12bit/拍；比例 1.5：每 3 个输入(24bit) 产生 2 个输出(12bit)
//=====================================================
module width_8to12(
    input  wire         clk,
    input  wire         rst_n,
    input  wire [7:0]   din,
    input  wire         din_valid,
    output reg  [11:0]  dout,
    output reg          dout_valid
);
    // TODO: 24bit 缓冲 + 状态：收 3 拍 -> 分 2 拍输出 buf[23:12]、buf[11:0]
    always @(*) begin dout = 12'b0; dout_valid = 1'b0; end
endmodule

//=====================================================
// 范例模块 width_8to12_ref：参考答案（供对照学习），原模块请自行完成
// 题目：8bit/拍 转 12bit/拍（比例 1.5），先到数据在高位
// 思路：24bit 缓冲 + 两态状态机——收满 3 拍（24bit）当拍立即输出高 12 位，
//       下一拍（OUT2 态）补发低 12 位；每 3 拍输入产生 2 拍输出，带宽不浪费
// 关键点：① OUT2 拍 din 被忽略（典型 testbench 会看 dout_valid 反压），
//         工程上可加 busy 反压信号；② 拼接后高 12 位 = {buf[15:4]}（即新 buf 的 [23:12]）
//=====================================================
module width_8to12_ref(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  din,
    input  wire        din_valid,
    output reg [11:0]  dout,
    output reg         dout_valid
);
    reg [23:0] buf;   // 24bit 缓冲：高位先入（左移拼接）
    reg [1:0]  cnt;   // 已收拍数 0/1/2
    reg        st;    // 0=COLLECT 收数态；1=OUT2 补发第二个输出态

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buf        <= 24'd0;
            cnt        <= 2'd0;
            st         <= 1'b0;
            dout       <= 12'd0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;                     // 默认无输出
            if (st) begin
                // OUT2 态：补发缓冲低 12 位（第二个输出）
                dout       <= buf[11:0];
                dout_valid <= 1'b1;
                st         <= 1'b0;                 // 回到收数态
            end
            else if (din_valid) begin
                buf <= {buf[15:0], din};            // 左移 8 位：新字节进最低 8 位
                if (cnt == 2'd2) begin
                    // 第 3 拍收满 24bit：立即输出高 12 位（= 拼接后 buf 的 [23:12]）
                    dout       <= {buf[15:4]};
                    dout_valid <= 1'b1;
                    cnt        <= 2'd0;
                    st         <= 1'b1;             // 下一拍补发低 12 位
                end
                else
                    cnt <= cnt + 1'b1;              // 未满 3 拍：继续收
            end
        end
    end
endmodule
