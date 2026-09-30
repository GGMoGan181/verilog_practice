`timescale 1ns/1ns
// 基础语法 VL10 函数实现数据大小端转换：function 做字节序交换
module endian_swap(input wire [31:0] din, output wire [31:0] dout);
    function [31:0] swap;   // TODO: function 内拼接 {din[7:0],din[15:8],din[23:16],din[31:24]}
        input [31:0] v;
        begin swap = v; end
    endfunction
    assign dout = swap(din);
endmodule

//=====================================================
// 范例模块 endian_swap_ref：参考答案（供对照学习），原模块 endian_swap 请自行完成
// 题目：用 function 实现 32bit 数据的字节大小端转换
// 思路：function 内把 4 个字节按相反顺序拼接返回
// 关键点：function 只能组合逻辑、只有一个返回值（赋给函数名）；
//         字节顺序：{原byte0, 原byte1, 原byte2, 原byte3} 反排
//=====================================================
module endian_swap_ref(input wire [31:0] din, output wire [31:0] dout);
    function [31:0] swap;
        input [31:0] v;
        begin
            // v[31:24]=byte3 ... v[7:0]=byte0，反序拼接即大小端互换
            swap = {v[7:0], v[15:8], v[23:16], v[31:24]};
        end
    endfunction
    assign dout = swap(din);   // 调用函数，组合输出
endmodule
