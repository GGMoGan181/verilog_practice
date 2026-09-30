`timescale 1ns/1ns
// 组合逻辑 VL10 数据选择器实现逻辑电路：用 MUX 查表实现任意逻辑函数
module mux_logic(input wire a, input wire b, input wire c, output wire f);
    assign f = 1'b0;   // TODO: 以部分变量作 sel，数据端接常量/剩余变量实现真值表
endmodule

//=====================================================
// 范例模块 mux_logic_ref：参考答案（供对照学习），原模块 mux_logic 请自行完成
// 题目：用数据选择器实现逻辑函数（本例 f = a^b^c）
// 思路：拿 a、b 作 MUX 选择端，4 个数据端按真值表接 c/~c/常量：
//       ab=00 → f=c；ab=01 → f=~c；ab=10 → f=~c；ab=11 → f=c
// 关键点：n 变量函数用 2^(n-1) 选 1 MUX：选择端接 n-1 个变量，
//         数据端接剩余变量的 0/1/原/反 四种之一
//=====================================================
module mux_logic_ref(input wire a, input wire b, input wire c, output wire f);
    wire [1:0] sel = {a, b};                 // 选择端接 a、b
    // 数据端按真值表化简结果接 c 或 ~c
    assign f = (sel == 2'b00) ?  c :
               (sel == 2'b01) ? ~c :
               (sel == 2'b10) ? ~c : c;      // sel==11
endmodule
