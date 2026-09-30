//verilog中的各种状态
// 1 高电平
// 0 低电平
// x 不确定是1 or 0
// z 高阻态
//在case语句中
//case识别1 0  
//casex识别1 0 x和z
//casez识别1 0 z

module encoder_0(
    input [8:0] in,
    output reg[3:0] out
);

    always@(*) begin
        casex(in)
        9'bxxxxxxxx1: out = 4'b0000;  // in[0] 最高优先
        9'bxxxxxxx10: out = 4'b0001;  // in[1]，仅在 in[0]=0 时匹配
        9'bxxxxxx100: out = 4'b0010;  // in[2]，仅在 in[1:0]=0 时匹配
        9'bxxxxx1000: out = 4'b0011;
        9'bxxxx10000: out = 4'b0100;
        9'bxxx100000: out = 4'b0101;
        9'bxx1000000: out = 4'b0110;
        9'bx10000000: out = 4'b0111;
        9'b100000000: out = 4'b1000;  // in[8] 最低优先
        default:       out = 4'b1111;
            
        endcase
    end
endmodule

//=====================================================
// 范例模块 encoder_0_ref：参考答案（供对照学习），原模块 encoder_0 请自行完成
// 题目：9 位输入的优先编码器，in[0] 优先级最高、in[8] 最低，输出对应编号
// 思路：casex 中 x 作"不关心"通配，分支自上而下匹配，天然实现优先级
// 关键点：① casex 把 x/z 都当通配，casez 只把 z(或 ?)当通配；
//         ② default 分支必须有，避免锁存器
//=====================================================
module encoder_0_ref(
    input  [8:0] in,
    output reg [3:0] out
);
    always @(*) begin
        casex (in)               // x 为通配位，自上而下第一个匹配的分支生效
            9'bxxxxxxxx1: out = 4'd0;   // in[0]=1，最高优先
            9'bxxxxxxx10: out = 4'd1;   // in[1]=1 且 in[0]=0
            9'bxxxxxx100: out = 4'd2;
            9'bxxxxx1000: out = 4'd3;
            9'bxxxx10000: out = 4'd4;
            9'bxxx100000: out = 4'd5;
            9'bxx1000000: out = 4'd6;
            9'bx10000000: out = 4'd7;
            9'b100000000: out = 4'd8;   // 仅 in[8]=1，最低优先
            default:      out = 4'd15;  // 全 0：输出无效标记 1111
        endcase
    end
endmodule