`timescale 1ns/1ns
module child_mod(
    input [7:0]data_a,
    input [7:0]data_b,
    input clk,rst_n,
    output reg[7:0] out
);
    reg [7:0] out_reg;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            out_reg<=0;
        end
        else begin
            if(data_a>=data_b) begin
                
                out_reg<=data_a;
            end
            else begin
                out_reg<=data_b;
            end
    end
    assign out=out_reg;
endmodule

module main_mod(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input clk,rst_n,
    output reg [7:0] d
);
    wire [7:0] out1;
    child_mod child1(
        .data_a(a),
        .data_b(b),
        .clk(clk),
        .rst_n(rst_n),
        .out(out1)
    );

    wire[ 7:0] out2;
    child_mod child2(
        .data_a(b),
        .data_b(c),
        .clk(clk),
        .rst_n(rst_n),
        .out(out2)
    );

    wire[ 7:0] out3;
    child_mod child3(
        .data_a(out1),
        .data_b(out2),
        .clk(clk),
        .rst_n(rst_n),
        .out(out3)
    );
    assign d=out3;
    //例化格式
    //原模块名  新名字（
    //   .原端口名（现在的信号名），

    //)；


    // wire [7:0] out1;
    // wire [7:0] out2;
    // child_mod u1(
    //     .data_a(a),
    //     .data_b(b),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .out(out1)
    // );

    // child_mod u2(
    //     .data_a(out1),
    //     .data_b(c),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .out(out2)
    // );

    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n) begin
    //         d<=0;
    //     end
    //     else begin
    //         d<=out2;
    //     end
    // end
endmodule