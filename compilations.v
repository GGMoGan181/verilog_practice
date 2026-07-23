//异或门
module xor_gate(
    input a,
    input b, 
    output y);
    assign y=a^b;

 endmodule


//21选择器
module mux21(
    input d0,
    input d1,
    input sel,
    output y
);

    assign y= sel? d1:d0;

endmodule
//带进位的一位加法器
module  add1(
    input a,
    input b,
    output sum,
    output carry

);

    assign sum = a^b ;
    assign carry =a&b;


endmodule

//d触发器
module dff(
    input clk,
    input rst_n,
    input d,
    output reg y

);

    always @(posedge clk or negedge rst_n ) begin
        if (rst_n == 0)begin
            y<=1'b0;
        end
        else begin
            y<=d;
        end

    end
endmodule
//计数器
module count4(
    input clk,
    input rst,
    output reg[3:0] count
    
);
    always @(posedge clk ) begin 
        if (rst)begin 
            count<=4'b0;

        end  
        else begin 
            count <=count+1'b1;

        end
    end
endmodule

//2位译码器
module decoder_2to4(
    input [1:0] a,
    input en,
    output reg [3:0] y
);
    always @(*)begin
        if (!en)begin 
            y=4'b0000
        end
        else begin 
            case (a)
             2'b00 : y = 4'b0001;
        
             2'b01 : y = 4'b0010;
             2'b10 : y = 4'b0100;
             2'b11 : y = 4'b1000;
            endcase
            end
        
        

    end
endmodule


//四位移位寄存器
module shift_reg(
    input clk,
    input in,
    input rst_n,

    output reg [3:0]  q
);

    always @(posedge clk or negedge rst_n)begin
    if (!rst_n)begin
        q<=4'b0000;

    end
    else begin
        q<={q[2:0],in};
    end

    end
endmodule

//序列检测器
module sequence_detector(
    input clk,
    input x,
    input rst_n,
    output reg q
);
    parameter IDLE =2'b00,s1 = 2'b01, s10=2'b10,s101=2'b11;
    reg [1:0] state, next_state;
    always @(posedge clk or negedge rst_n)begin 
        if (!rst_n)begin 
            state <= IDLE;
        end
        else begin
            state<= next_state;
        end

    always @(*)begin
        case (state)
        2'b00: next_state= x ? s1:IDLE;

        2'b01: next_state= x ? s1: s10;
        2'b10: next_state= x ? s101: IDLE;

        2'b11: next_state= x ? s1 :IDLE;
        default: next_state = IDLE;
        endcase
    end

    always @(*)begin
        q=(state == s101); 
    end
    end

endmodule



//分频

module clk_divider #(parameter N = 4)(
    input clk,
    input rst_n,
    output reg clk_out
);
    reg [31:0] cut;

    always @(posedge clk or  negedge rst_n)begin
    if (!rst_n)begin
        clk_out<=1'b0;
        cut <= 0;
    end
    else if (cut==(N/2)-1)begin 
        cut<=0;
        clk_out<=~clk_out;

    end
    else begin 
    cut=cut+1;
    end
    end
endmodule

//256 -8 RAM
module single_port_ram(
    input [7:0]din,
    input clk,
    input we,
    input  [7:0]addr,
    output reg [7:0] dout

);
    reg [7:0] ram[255:0]
    always@(posedge clk)begin 
        if (we)begin 
           ram[addr]<= din;

        end
        else begin 
           dout<= ram[addr];
        end
    end
endmodule


//ALU


module simple_alu(
    input [3:0] A ,
    input [3:0] B ,
    input [2:0] op,
    output reg [3:0] Y 


);
    always @(*)begin 
        case (op)
        3'b000: Y = A+B;

        3'b001: Y = A-B;
        3'b010: Y = A |B;
        3'b011: Y = A&B;
        3'b100: Y = A^B;
        3'b101: Y =~A;
        default: Y= 4'b0000 ;
        endcase
    end
endmodule

//in边沿检测
module edge_detector(
    input in,
    input rst_n,
    input clk,
    output pos_edge
);
    reg in1;
    always @(posedge clk or negedge rst_n)begin
        
        if (!rst_n)begin 
            pos_edge<= 0;

        end
        else begin 
            in1<=in;
            end
    end
    
    assign pos_edge = in & ~in1;
    
endmodule

module pwm_gen(
    input clk,
    input rst_n,
    input [7:0] duty,
    output reg pwm_out
);

    // 在这里编写你的代码
    reg [7:0] cut;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)begin 
            pwm_out<=0;
        end 
          
        else if (cut<duty)begin 
            cut<=cut+1;
            pwm_out<=1;
        end
        else begin 
            cut<=0;
            pwm_out <=0;
        end

    end

endmodule

module johnson_cnt(
    input clk,
    input rst_n,
    output reg [3:0] q
);

    // 在这里编写你的代码
    always @(posedge clk or negedge rst_n)begin 
        if (!rst_n)begin 
            q<=0;

        end
        else begin 
            q<={q[2:0],~q[3]};
        end
    end

endmodule

//按键消抖
module key_debounce(
    input key,
    input clk,
    input rst_n,
    output key_out
);
    reg [3:0] cnt;
    reg key_d;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 0;
            key_out <= 0;
            key_d <= 0;
        end else begin
            key_d <= key_in;
            if(key_in != key_d) begin
                cnt <= 0;
            end else if(cnt < 10) begin
                cnt <= cnt + 1;
            end else begin
                key_out <= key_in;
            end
        end
    end
endmodule

module vending_machine(
    input clk,
    input rst_n,
    input coin_05,
    input coin_10,
    output reg despense
);
    paramater IDLE=2'b00, s05=2'b01 ,s10=2'b10 ,s15=2'b11;
    reg [1:0] state;
always@(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin
        state = IDLE;
        despense=0;
    end
    else begin 
        case (state)
        IDLE : begin
            despense<=0;
            if(coin_05) state=s05;
            else if (coin_10) state=s10;
            
        end

        s05 : begin
            despense<=0
        if(coin_05) state =s10;
        else if (coin_10) begin 
            state=IDLE;
             despense<=1;
        end 
        end
        
        s10: if(coin_05 ||coin_10)
        despense <=1;
        state <=LDLE;
        default state <=LDLE;

        endcase
    end

end
endmodule

module bcd_to_7seg(
    input [3:0] bcd_in,
    output reg [6:0] seg_out
);

    always @(*) begin
        case(bcd_in)
            4'd0: seg_out = 7'b1111110;
            4'd1: seg_out = 7'b0110000;
            4'd2: seg_out = 7'b1101101;
            4'd3: seg_out = 7'b1111001;
            4'd4: seg_out = 7'b0110011;
            4'd5: seg_out = 7'b1011011;
            4'd6: seg_out = 7'b1011111;
            4'd7: seg_out = 7'b1110000;
            4'd8: seg_out = 7'b1111111;
            4'd9: seg_out = 7'b1111011;
            default: seg_out = 7'b0000000;
        endcase
    end
endmodule

module parity_gen(
    input [7:0] data,
    output even_parity,
    output odd_parity
);
assign even_parity =^data;
assign odd_parity = ~(^data);
endmodule

module fixed_arbiter(
    input [2:0] req,
    output reg [2:0] grant
);
assign grant[0] = req[0];
assign grant[1] = ~req[0] & req[1];
assign grant[2] = ~req[0] & ~req[1] & req[2];
endmodule

module watchdog_timer(
    input clk,
    input rst_n,
    input feed,
    output reg sys_rst
);
reg [6:0] counter;
always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin
        counter<=0;
        sys_rst<=0;

    end
    else if (feed) begin
        counter<=0;
            sys_rst<=0; 
    end
    else if (counter==100)begin
        counter<=0;
        sys_rst<=1;
    end
    else begin
        counter <=counter+1;
        sys_rst<=0;
    end
end 
endmodule

module pulse_sync(
    input clk_a,
    input rst_n_a,
    input pluse_a,
    input clk_b,
    input rst_n_b,
    output reg pluse_b

),
reg q1,q2;
reg toggle_a
always @(posedge clk_a or negedge rst_n_a)begin 
    if(!rst_a)begin
        toggle_a<=0;
    end
    else if(pluse_a)begin
        toggle_a<=~toggle_a;

    end
    

    always @(posedge clk_b or negedge rst_n_b)begin
        if (!rst_n_b)begin
            q1<=0;
            q2<=0;
            pluse_b<=0;
        end
        else begin 
            q1<= toggle_a;
            q2<=q1;
        end
    end
end
reg q3;
always @(posedge clk_b or negedge rst_n_b)begin
    if(!rst_n_b)begin q3<=0;
    end
    else begin
        q3<=q2;
    end
    assign pluse_b =q2^q3;
end
endmodule

module uart_tx(
    input clk,
    input rst_n,
    input start,
    input [7:0] data,
    output reg tx,
    output reg busy
);
reg [9:0] shift_reg;
reg [3:0] bit_count;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        shift_reg<=0;
        busy<=0;
        tx<=1;
        bit_count<=0;
    end
    else if(start&& !busy)begin
        busy<=1;
        shift_reg<={1'b1,data,1'b0};
        bit_count<=0;      
    end
    else if(busy)begin
        if(bit_count<10)begin
            tx<=shift_reg[0];
            shift_reg<={1'b1,shift_reg[9:1]};
            bit_count<=bit_count+1;
            else begin
                busy<=0;
                bit_count<=0;
            end
        end
    end
end
endmodule

module i2c_detector(
    input clk,
    input rst_n,
    input scl,
    input sda,
    output start_flag,
    output stop_flag
);

reg sda_d;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        sda_d<=1;  
        scl=0;
    end
    else begin 
        sda_d<=sda;
    end
    
end
assign start_flag = scl&(sda_d&sda);
assign stop_flag = scl&(~sda_d&sda);
endmodule

module sync_fifo(
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input [7:0] din,
    output reg [7:0] dout,
    output empty,
    output full
);
reg [7:0] fifo [15:0];
reg [3:0] wr,rd;
reg [3:0] count;
assign empty = (count==0);
assign full = (count==16);
always @(posedge clk or negedge rst_n)begin
    if (!rst_n)begin
        count<=0;
        rd<=0;
        wr<=0;
    end
    else begin
    case(wr_en&&!full,rd_en&&!empty)
        2'b10:begin
        fifo[wr]<=din;
        wr<=wr+1;
        count<=count+1;
        
        end
        2'b01:begin
            dout<=fifo[rd];
            rd<=rd+1;
            count<=count-1
        end
        2'b11:begin
            fifo[wr]<=din;
            dout<=fifo[rd];
            wr<=wr+1;
            rd<=rd+1;
        end  
    endcase
    end
end
endmodule
