`timescale 1ns/1ns
//=====================================================
// VL47 格雷码计数器
// 二进制计数后转格雷码，或直接按格雷码规律递增（相邻仅1位变化）
//=====================================================
module gray_counter #(parameter N = 4)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        en,
    output reg  [N-1:0] gray
);
    // TODO: bin 计数 -> gray = bin ^ (bin>>1)；或直接用格雷码递推
    always @(*) gray = {N{1'b0}};
endmodule

//=====================================================
// 范例模块 gray_counter_ref：参考答案（供对照学习），原模块请自行完成
// 题目：格雷码计数器——en 有效时递增，输出相邻只变 1 位的格雷码
// 思路：内部二进制计数，输出用公式 gray = bin ^ (bin>>1) 实时转换
// 关键点：① 二进制转格雷码：保留最高位，其余位 = bin[i]^bin[i+1]，即 bin^(bin>>1)；
//         ② 直接对格雷码递推易错，二进制中转最稳；③ en=0 时保持
//=====================================================
module gray_counter_ref #(parameter N = 4)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         en,
    output wire [N-1:0] gray
);
    reg [N-1:0] bin;    // 内部二进制计数器

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bin <= {N{1'b0}};      // 复位清零
        else if (en)
            bin <= bin + 1'b1;     // 使能时递增（自然溢出回卷）
        // en=0：不写 bin，默认保持
    end

    // 二进制 -> 格雷码：G = B ^ (B >> 1)
    assign gray = bin ^ (bin >> 1);
endmodule
