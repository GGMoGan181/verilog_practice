`timescale 1ns/1ns
// 时序逻辑 VL3 ROM的简单实现：只读存储，地址译码输出固定内容
module rom_simple #(parameter AW = 4, DW = 8)(
    input  wire [AW-1:0] addr,
    output reg  [DW-1:0] rdata
);
    // TODO: case(addr) 或 const 数组返回固化数据（组合或同步读）
    always @(*) rdata = {DW{1'b0}};
endmodule

//=====================================================
// 范例模块 rom_simple_ref：参考答案，原模块 rom_simple 请自行完成
// 题目：ROM 简单实现：地址译码输出固化数据（本例组合异步读）
// 思路：case(addr) 把每个地址映射到固化字；未列出地址给 default
// 关键点：组合读敏感列表用 @(*)；若题意要同步读，
//         把 always @(*) 换成 @(posedge clk) 且用 <= 即可
//=====================================================
module rom_simple_ref #(parameter AW = 4, DW = 8)(
    input  wire [AW-1:0] addr,
    output reg  [DW-1:0] rdata
);
    always @(*) begin
        case (addr)                      // 固化内容：按题目 ROM 表填
            4'd0:    rdata = 8'h00;
            4'd1:    rdata = 8'h11;
            4'd2:    rdata = 8'h22;
            4'd3:    rdata = 8'h33;
            4'd4:    rdata = 8'h44;
            4'd5:    rdata = 8'h55;
            4'd6:    rdata = 8'h66;
            4'd7:    rdata = 8'h77;
            4'd8:    rdata = 8'h88;
            4'd9:    rdata = 8'h99;
            4'd10:   rdata = 8'hAA;
            4'd11:   rdata = 8'hBB;
            4'd12:   rdata = 8'hCC;
            4'd13:   rdata = 8'hDD;
            4'd14:   rdata = 8'hEE;
            default: rdata = 8'hFF;      // 最后一个地址兼作 default
        endcase
    end
endmodule
