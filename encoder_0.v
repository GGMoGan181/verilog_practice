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