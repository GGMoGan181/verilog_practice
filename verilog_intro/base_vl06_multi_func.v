`timescale 1ns/1ns
// 基础语法 VL6 多功能数据处理器：op 选择加/减/与/或等不同运算
module multi_func(input wire [1:0] op, input wire [3:0] a, input wire [3:0] b,
                  output reg [3:0] y);
    always @(*) y = 4'b0;   // TODO: case(op) 加/减/与/或
endmodule

//=====================================================
// 范例模块 multi_func_ref：参考答案（供对照学习），原模块 multi_func 请自行完成
// 题目：op  opcode 选择对 a、b 做加/减/与/或
// 思路：组合逻辑 case 分支，op 的 4 个取值各对应一种运算
// 关键点：always @(*) 敏感列表用 *；case 要写 default 防锁存器
//=====================================================
module multi_func_ref(input wire [1:0] op, input wire [3:0] a, input wire [3:0] b,
                      output reg [3:0] y);
    always @(*) begin
        case (op)
            2'b00:   y = a + b;    // 加（溢出自然截断到 4bit）
            2'b01:   y = a - b;    // 减
            2'b10:   y = a & b;    // 按位与
            2'b11:   y = a | b;    // 按位或
            default: y = 4'b0;     // 全覆盖，避免生成锁存器
        endcase
    end
endmodule
