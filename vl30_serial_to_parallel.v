`timescale 1ns/1ns
//=====================================================
// VL30 数据串转并电路
// 串行 din 逐位移入，收满 8 位后并行输出 dout 并拉高 dout_valid
//=====================================================
module serial_to_parallel(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       din,        //串行输入（高位先入）
    input  wire       din_valid,
    output reg  [7:0] dout,       //并行输出
    output reg        dout_valid  //收满一字节脉冲
);
    // TODO: 移位寄存器 + 位计数，计满 8 位输出
    always @(*) begin dout = 8'b0; dout_valid = 1'b0; end
endmodule

//=====================================================
// 范例模块 serial_to_parallel_ref：参考答案（供对照学习），原模块请自行完成
// 题目：串转并——din_valid 有效时逐位移入 din（高位先入），收满 8 位后
//       并行输出 dout 并拉高 dout_valid 一拍
// 思路：8 位移位寄存器左移入位 + 3 位计数器计满 8 位
// 关键点：① 左移 {shift[6:0],din} 使最先到达的位落在高位；② valid 仅维持一拍；
//         ③ 复位分支清零所有寄存器
//=====================================================
module serial_to_parallel_ref(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       din,
    input  wire       din_valid,
    output reg  [7:0] dout,
    output reg        dout_valid
);
    reg [7:0] shift;   // 移位窗口：暂存已收到的位
    reg [2:0] cnt;     // 已收位数 0~7

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift      <= 8'b0;
            cnt        <= 3'b0;
            dout       <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;                 // 默认无效，仅收满那拍拉高
            if (din_valid) begin
                shift <= {shift[6:0], din};     // 左移入位：先到的位逐步移到高位
                if (cnt == 3'd7) begin          // 本拍是第 8 位：收满一字节
                    dout       <= {shift[6:0], din};   // 直接拼出完整字节输出
                    dout_valid <= 1'b1;         // 拉高一拍
                    cnt        <= 3'd0;         // 计数回零，开始下一字节
                end
                else
                    cnt <= cnt + 1'b1;          // 未满 8 位：继续计数
            end
        end
    end
endmodule
