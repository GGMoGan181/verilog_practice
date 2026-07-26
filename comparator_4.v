`timescale 1ns/1ns
//四位数值比较器
module comparator_4(
    input [3:0]a,
    input [3:0]b,
    output wire y0,
    output wire y1,
    output wire y2

);
    assign y2=(a[3]>b[3] | (a[3]==b[3])&& (a[2]>b[2]) | (a[3]==b[3])&& (a[2]==b[2])&& (a[1]>b[1]) | (a[3]==b[3])&& (a[2]==b[2])&& (a[1]==b[1]) &&(a[0]>b[0]));
    assign y1=(a[3]==b[3])&& (a[2]==b[2])&& (a[1]==b[1]) &&(a[0]==b[0]);
    assign y0= (~y2) && (~y1);

endmodule