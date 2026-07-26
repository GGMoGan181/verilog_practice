`timescalse 1ns/1ns
//超前四位进位加法器

module lac_4(
    input [3:0]a,
    input [3:0]b,
    input c_1,
    output wire [3:0]s,
    output wire c0
    );

    wire [3:0]g;
    wire [3:0]p;
    wire [3:0]c;
    genvar i;
    generate for(i=0;i<4; i=i+1)
        begin : gen_i
           assign g[i]=a[i] & b[i];
           assign p[i]=a[i] ^ b[i];

        end  
    endgenerate

    assign c[0]=g[0] | p[0] & c_1;
    assign c[1]=g[1] | p[1] & c[0];
    assign c[2]=g[2] | p[2] & c[1];
    assign c[3]=g[3] | p[3] & c[2];
    //注意这里要用 |  运算
    assign c0=c[3];
    
    assign s[0]= p[0] & c_1;
    assign s[1]= p[1] & c[0];
    assign s[2]= p[2] & c[1];
    assign s[3]= p[3] & c[2];

endmodule