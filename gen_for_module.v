`timescale 1ns/1ns
module (
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