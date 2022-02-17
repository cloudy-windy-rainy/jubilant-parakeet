module nco(	o_gen_clk,
		i_nco_num,
		clk,
		rst_n	);
output		o_gen_clk;

input	[31:0] i_nco_num;
input		clk;
input		rst_n;

reg	[31:0]	cnt;
reg		o_gen_clk;



always @(posedge clk or negedge	rst_n)	begin
	if(rst_n == 1'b0) begin
		cnt	<=32'd0;
		o_gen_clk	<=1'd0;
	end else begin
		if(cnt>=i_nco_num/2-1) begin
			cnt <=32'd0;
			o_gen_clk <=~o_gen_clk;	
		end else begin
			cnt<=cnt+1'b1;
		end
	end
end
endmodule



module fnd_dec 	(	o_seg,
							i_num	);
							
output 	[6:0]			o_seg;
input		[3:0]			i_num;

reg		[6:0]	o_seg;


always @(i_num) begin
	case(i_num)
		4'd0: o_seg = 7'b111_1110	;
		4'd1: o_seg = 7'b011_0000	;
		4'd2: o_seg = 7'b110_1101	;
		4'd3: o_seg = 7'b111_1001	;
		4'd4: o_seg = 7'b011_0011	;
		4'd5: o_seg = 7'b101_1011	;
		4'd6: o_seg = 7'b101_1111	;
		4'd7: o_seg = 7'b111_0000	;
		4'd8: o_seg = 7'b111_1111	;
		4'd9: o_seg = 7'b111_1011	;
		4'd10: o_seg = 7'b111_0111	;
		default : o_seg = 7'b000_0000;
	endcase
	
end
endmodule 



//--------------------------------------
// 0~59--> 2 seperated Segments
//--------------------------------------


module		double_fig_sep(
										o_left,
										o_right,
										i_double_fig	);

										
output	[3:0]						o_left	;
output	[3:0]						o_right	;

input		[5:0]						i_double_fig;

assign		o_left = i_double_fig / 10;
assign		o_right = i_double_fig % 10;

endmodule
										

//--------------------------------------
// 0~59 --> 2 Seperated Segments
//--------------------------------------										

module		led_disp(
								o_seg,
								o_seg_dp,
								o_seg_enb,
								i_six_digit_seg,
								i_six_dp,
								clk,
								rst_n			);
								
output	[5:0]				o_seg_enb	;	
output						o_seg_dp		;
output	[6:0]				o_seg;

input		[41:0]			i_six_digit_seg	;
input		[5:0]				i_six_dp				;

input							clk					;
input							rst_n					;

wire							gen_clk;


nco							u_nco(
											.o_gen_clk(	gen_clk	),
											.i_nco_num	(32'd5000),
											.clk			(	clk	),
											.rst_n		(rst_n	));
											
											
reg	[3:0]				cnt_common_node	;
always	@(posedge	gen_clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_common_node <= 4'd0;
	end else begin
		if(cnt_common_node >=4'd5)begin
			cnt_common_node <=4'd0;
		end else begin
			cnt_common_node	<= cnt_common_node +1'b1;
		end
	end
end

reg 	[5:0]	o_seg_enb	;

always @(cnt_common_node) begin
	case(cnt_common_node)
		4'd0 : o_seg_enb = 6'b111110;
		4'd1 : o_seg_enb = 6'b111101;
		4'd2 : o_seg_enb = 6'b111011;
		4'd3 : o_seg_enb = 6'b110111;
		4'd4 : o_seg_enb = 6'b101111;
		4'd5 : o_seg_enb = 6'b011111;
	endcase
end

reg			o_seg_dp	;


always @(cnt_common_node) begin
	case(cnt_common_node)
		4'd0 : o_seg_dp = i_six_dp[0];
		4'd1 : o_seg_dp = i_six_dp[1];
		4'd2 : o_seg_dp = i_six_dp[2];
		4'd3 : o_seg_dp = i_six_dp[3];
		4'd4 : o_seg_dp = i_six_dp[4];
		4'd5 : o_seg_dp = i_six_dp[5];	
	endcase
end

reg	[6:0]	o_seg;
always	@(cnt_common_node) begin
				case (cnt_common_node)
						4'd0 : o_seg = i_six_digit_seg[6:0];
						4'd1 : o_seg = i_six_digit_seg[13:7];
						4'd2 : o_seg = i_six_digit_seg[20:14];
						4'd3 : o_seg = i_six_digit_seg[27:21];
						4'd4 : o_seg = i_six_digit_seg[34:28];
						4'd5 : o_seg = i_six_digit_seg[41:35];
				endcase
end



endmodule
	

module		hms_cnt(
							o_hms_cnt,
							o_max_hit,
							i_max_cnt,
							clk,
							rst_n		);
							
output		[5:0]		o_hms_cnt;
output					o_max_hit;

input			[5:0]		i_max_cnt;
input						clk		;
input						rst_n		;




reg			[5:0]		o_hms_cnt;

reg						o_max_hit;


always @(posedge	clk or negedge rst_n) begin

	if(rst_n == 1'b0) begin
		o_hms_cnt <= 6'd0;
		o_max_hit <= 1'b0;
		
	end else begin
		if(o_hms_cnt>=i_max_cnt) begin
			o_hms_cnt <= 6'd0;
			o_max_hit <= 1'b1;
		end else begin
			o_hms_cnt <= o_hms_cnt+ 1'b1;
			o_max_hit <= 1'b0;
		end
	end
end


endmodule

//=========================================
//debounce
//=========================================

module debounce(
						o_sw,
						i_sw,
						clk		);

output				o_sw;

input					i_sw;
input					clk;


reg					dly1_sw	;

always @(posedge clk)begin
	dly1_sw <= i_sw;
end


reg					dly2_sw	;
always @(posedge clk)begin
	dly2_sw <= dly1_sw;
end


assign				o_sw = dly1_sw | ~dly2_sw;

endmodule

module	minsec(
						o_sec,
						o_min,
						o_hour,
						o_max_hit_sec,
						o_max_hit_min,
						o_max_hit_hour,
						i_hour_clk,
						i_sec_clk,
						i_min_clk,
						clk,
						rst_n		);
						
						
output	[5:0]		o_sec	;
output	[5:0]		o_min	;
output	[5:0]		o_hour;



output				o_max_hit_sec;
output				o_max_hit_min;
output				o_max_hit_hour;


input					i_sec_clk;
input					i_min_clk;
input					i_hour_clk;

input					clk;
input					rst_n;


wire					max_hit_sec	;
hms_cnt				u0_hms_cnt(
										.o_hms_cnt(o_sec			),
										.o_max_hit(o_max_hit_sec),
										.i_max_cnt(6'd59			),
										.clk	(	i_sec_clk		),
										.rst_n(	rst_n				));
										
										
wire					max_hit_min	;

hms_cnt				u1_hms_cnt(
										.o_hms_cnt(o_min			),
										.o_max_hit(o_max_hit_min),
										.i_max_cnt(6'd59			),
										.clk	(	i_min_clk		),
										.rst_n(	rst_n				));

wire					max_hit_hour	;

hms_cnt				u2_hms_cnt(
										.o_hms_cnt(o_hour			),
										.o_max_hit(o_max_hit_hour),
										.i_max_cnt(6'd59			),
										.clk	(	i_hour_clk		),
										.rst_n(	rst_n				));



endmodule

module controller(
						o_mode,
						o_position,
						o_sec_clk,
						o_min_clk,
						o_hour_clk,
						i_max_hit_sec,
						i_max_hit_min,
						i_max_hit_hour,
						i_sw0,
						i_sw1,
						i_sw2,
						clk,
						rst_n		);
						

						
output				o_mode		;
output				o_position	;
output				o_sec_clk	;
output				o_min_clk	;
output				o_hour_clk	;
	

input					i_max_hit_sec	;
input					i_max_hit_min	;						
input					i_max_hit_hour	;

input					i_sw0;
input					i_sw1;
input					i_sw2;

input					clk;
input					rst_n;

parameter			MODE_CLOCK = 1'b0	;
parameter			MODE_SETUP = 1'b1	;

parameter			POS_SEC = 1'b0		;
parameter			POS_MIN = 1'b1		;

wire					clk_slow				;

nco					u_nco_db(
									.o_gen_clk	(	clk_slow		),
									.i_nco_num	( 32'd500000	),
									.clk		 	(clk				),
									.rst_n		(rst_n			));
									
									
wire					sw0					;
wire					sw1					;
wire					sw2					;

debounce				u_debouce0(
										.o_sw	(	sw0				),
										.i_sw	(	i_sw0				),
										.clk	(	clk				));
										
										
debounce				u_debouce1(
										.o_sw	(	sw1				),
										.i_sw	(	i_sw1				),
										.clk	(	clk				));
										
debounce				u_debouce2(
										.o_sw	(	sw2				),
										.i_sw	(	i_sw2				),
										.clk	(	clk				));
										
										
								
																				
reg				o_mode					;
//always @(posedge i_sw0 or negedge rst_n) begin

always @(posedge sw0 or negedge rst_n) begin
	if(rst_n == 1'b0)begin
		o_mode <= MODE_CLOCK;
	end else begin
		o_mode <= o_mode + 1'b1;
	end
end

reg				o_position	;

always @(posedge sw1 or negedge rst_n) begin
	if(rst_n == 1'b0)begin
		o_position <= POS_SEC;
	end else begin
		if(o_position >= POS_MIN ) begin
			o_position <= POS_SEC;
		end else begin
			o_position <= o_position + 1'b1;
		end
	end
end



wire		clk_1hz	;
nco		u_nco(
					.o_gen_clk ( clk_1hz),
					.i_nco_num ( 32'd50000000	),
					.clk			( clk				),
					.rst_n		(	rst_n			));
					
reg	 	o_sec_clk	;
reg		o_min_clk	;

always @(*) begin
	case(o_mode)
		MODE_CLOCK : begin
			o_sec_clk <= clk_1hz;
			o_min_clk <= i_max_hit_sec;
		end
		MODE_SETUP : begin
		case(o_position)
			POS_SEC : begin
//				o_sec_clk <= ~i_sw2;
				o_sec_clk <= ~sw2;
				o_min_clk <= 1'b0;
			end
			POS_MIN : begin
				o_sec_clk <= 1'b0;
				o_min_clk <= ~sw2;
			end
		endcase
		end
	endcase
end

endmodule 


module	top_hms_clock(	
								o_seg_enb,
								o_seg_dp,
								o_seg,
								i_sw0,
								i_sw1,
								i_sw2,
								clk,
								rst_n		);


output	[5:0]				o_seg_enb	;								
output						o_seg_dp		;
output	[6:0]				o_seg			;

input							i_sw0			;
input							i_sw1			;
input							i_sw2			;
input							clk			;
input							rst_n			;


wire							mode			;
wire							position		;
wire							sec_clk		;
wire							min_clk		;
wire							hour_clk		;
wire							max_hit_hour;
wire							max_hit_sec	;
wire							max_hit_min	;

controller					u_ctrl(
										.o_mode	( mode			),
										.o_position(	position	),
										.o_sec_clk(	sec_clk		),
										.o_min_clk(	min_clk		),
										.o_hour_clk( hour_clk	),
										.i_max_hit_sec(max_hit_sec),
										.i_sw0(	i_sw0				),
										.i_sw1(	i_sw1				),
										.i_sw2(	i_sw2				),
										.clk	(	clk				),
										.rst_n(	rst_n				));
										
										
wire	[5:0]				sec;
wire	[5:0]				min;
wire	[5:0]				hour;
minsec					u_minsec(
										.o_sec(	sec				),
										.o_min(	min				),
										.o_hour( hour				),
										.o_max_hit_sec(	max_hit_sec	),
										.o_max_hit_min(	max_hit_min	),
										.o_max_hit_hour(	max_hit_hour),
										.i_sec_clk(	sec_clk		),
										.i_min_clk(	min_clk		),
										.i_hour_clk( hour_clk	),
										.clk(	clk					),
										.rst_n(	rst_n				));
										
wire	[3:0]				sec_l;
wire	[3:0]				sec_r;

double_fig_sep			u0_dfs(
									.o_left(	sec_l					),
									.o_right(sec_r					),
									.i_double_fig(	sec			));
									
wire	[3:0]				min_l;
wire	[3:0]				min_r;

double_fig_sep			u1_dfs(
									.o_left(	min_l					),
									.o_right(min_r					),
									.i_double_fig(	min			));
									

wire	[3:0]				hour_l;
wire	[3:0]				hour_r;

double_fig_sep			u2_dfs(
									.o_left(	hour_l					),
									.o_right(hour_r					),
									.i_double_fig(	hour			));									
									
									
									
wire	[6:0]			sec_l_seg;
wire	[6:0]			sec_r_seg;

fnd_dec				u0_fnd_dec(
										.o_seg	(	sec_l_seg	),
										.i_num	(	sec_l			));
fnd_dec				u1_fnd_dec(
										.o_seg	(	sec_r_seg	),
										.i_num	(	sec_r			));										
										
									
wire	[6:0]			min_l_seg;
wire	[6:0]			min_r_seg;
				
fnd_dec				u2_fnd_dec(
										.o_seg	(	min_l_seg	),
										.i_num	(	min_l			));
fnd_dec				u3_fnd_dec(
										.o_seg	(	min_r_seg	),
										.i_num	(	min_r			));	

wire	[6:0]			hour_l_seg;
wire	[6:0]			hour_r_seg;
				
fnd_dec				u4_fnd_dec(
										.o_seg	(	hour_l_seg	),
										.i_num	(	hour_l			));
fnd_dec				u5_fnd_dec(
										.o_seg	(	hour_r_seg	),
										.i_num	(	hour_r			));								

							

wire	[41:0]		six_digit_seg	;
assign				six_digit_seg = {{2{7'd000_0000}}, hour_l_seg, hour_r_seg, min_l_seg, min_r_seg, sec_l_seg, sec_r_seg };
led_disp				u_led_disp(
										.o_seg	(o_seg			),
										.o_seg_dp(o_seg_dp		),
										.o_seg_enb(o_seg_enb		),
										.i_six_digit_seg(six_digit_seg),
										.i_six_dp	(6'd0			),
										.clk			(clk			),
										.rst_n		(rst_n		));
										



endmodule


module	buzz(	o_buzz,
					i_buzz_en,
					clk,
					rst_n	);

output	o_buzz;
input		i_buzz_en;
input		clk;
input		rst_n;


  
parameter	C = 200000;
parameter	D = 181000;
parameter	E = 162000;
parameter	F = 152500;
parameter	G = 133500;
parameter	A = 120000;
parameter	B_f= 112000;
parameter	B = 105000;
parameter	C_Hi = 100000;
wire	clk_beat;


nco	u_nco_beat (	
							.o_gen_clk ( clk_beat),
							.i_nco_num (25000000),
							.clk ( clk ),
							.rst_n ( rst_n ));
reg	[4:0] cnt;

always @ (posedge clk_beat or negedge rst_n ) begin
	if(rst_n == 1'b0 ) begin
		cnt <= 5'd0;
	end else begin
		if (cnt == 5'd24 ) begin
			cnt <= 5'd0;
		end else begin
	 		cnt <= cnt + 1'd1;
		end
	end
end
reg [31:0] 	nco_num;
always @ (*) begin
	case (cnt)
		5'd00 : nco_num = C;
		5'd01 : nco_num = D;
		5'd02 : nco_num = E;
		5'd03 : nco_num = F;
		5'd04 : nco_num = G;
		5'd05 : nco_num = A;
		5'd06 : nco_num = B;
		5'd07 : nco_num = C_Hi;	
	
		5'd08 : nco_num = C;
		5'd09 : nco_num = D;
		5'd10 : nco_num = C;
		5'd11 : nco_num = F;
		5'd12 : nco_num = E;
		5'd13 : nco_num = C;
		5'd14 : nco_num = D;
		5'd15 : nco_num = C;
		5'd16 : nco_num = G;
		5'd17 : nco_num = F;
		5'd18 : nco_num = C;
		5'd19 : nco_num = C_Hi;
		5'd20 : nco_num = A;
		5'd21 : nco_num = F;
		5'd22 : nco_num = E;
		5'd23 : nco_num = D;
		5'd24 : nco_num = B_f;
		5'd25 : nco_num = A;
		5'd26 : nco_num = F;
		5'd27 : nco_num = G;
		5'd28 : nco_num = F;
		5'd29 : nco_num = F;
		
	endcase
end
wire	buzz;
nco	u_nco_buzz ( 	.o_gen_clk ( buzz),
							.i_nco_num ( nco_num),
							.clk ( clk),
							.rst_n ( rst_n)	);

assign	o_buzz = buzz & i_buzz_en;
endmodule
