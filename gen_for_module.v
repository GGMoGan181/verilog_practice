`timescale 1ns/1ns
module gen_for_module(
    input [7:0]data,
    output [7:0]out
);

//使用在普通赋值语句
    genvar i;
    generate for(i=0;i<8 ;i=i+1)
        begin : gen_i
            assign out[i]= data[7-i];
        end
    endgenerate
    
    
    //integer for使用在always语句中
    // integer j;
    //reg [7:0]out_reg;
    // always @(data) begin
    //     for(j=0; j<8; j=j+1)begin
    //         out_reg[j]=data[7-j];
    //     end
    // end
    //assign out=out_reg;
      
endmodule

//=====================================================
// 范例模块 gen_for_module_ref：参考答案（供对照学习），原模块 gen_for_module 请自行完成
// 题目：用 generate for 实现 8 位数据按位反序
// 思路：genvar 在综合展开时生成 8 份并行硬件，每份只是一根连线交叉
// 关键点：① genvar 只能用于 generate 块；② 每个循环体用 begin:名字 命名便于定位；
//         ③ 等价的简洁写法是拼接运算符 {data[0],...,data[7]} 或循环左移
//=====================================================
module gen_for_module_ref(
    input  [7:0] data,
    output [7:0] out
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_rev
            // 展开后：out[0]=data[7]、out[1]=data[6] … out[7]=data[0]
            assign out[i] = data[7-i];
        end
    endgenerate

    // 等价写法（不用 generate）：拼接反序
    // assign out = {data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7]};
endmodule