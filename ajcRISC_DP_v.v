module ajcRISC_DP_v (Reset, Clock, PB1, SW, LEDs, IW, SR_CNVZ, 
	RST_PC, LD_PC, CNT_PC, LD_IR, LD_R0, LD_R1, LD_R2, LD_R3,
	LD_TXR, LD_TYR, LD_TK, LD_SR, LD_MABR, LD_MAXR, LD_MAR, RW, 
	LD_IPDR, LD_OPDR, SRC1_SEL, SRC2_SEL, WB_SEL, ALU_FS);


input Reset, Clock, PB1, RST_PC, LD_PC, CNT_PC, LD_IR, 
	LD_R0, LD_R1, LD_R2, LD_R3, LD_TXR, LD_TYR, LD_TK,LD_SR, 
	LD_MABR, LD_MAXR, LD_MAR, RW, LD_IPDR, LD_OPDR;
input [1:0] SRC1_SEL, SRC2_SEL, WB_SEL;
input [3:0] SW, ALU_FS;
output [7:0] LEDs, IW;
output [3:0] SR_CNVZ;

wire [7:0] SRC1, SRC2, WB, R0out, R1out, R2out, R3out, RFout, PMout, IRout, IPDRout,
	DMout, ALU_Result;
wire [9:0] PCout, MARout, MABRin, MAXRin, MABRout, MAXRout, MARin;
wire [3:0] ALU_CNVZ, SRout;

//Central multiplexer to WB bus
ajc_nbit_4to1mux_v #8 WB_mux (.d3(8'b00000000), .d2(IPDRout), .d1(DMout), .d0(ALU_Result), .s(WB_SEL), .f(WB));

//4-register register file
ajc_nbit_reg_v #8 R0 (.ld(LD_R0), .d(WB), .reset(Reset), .clock(Clock), .q(R0out));
ajc_nbit_reg_v #8 R1 (.ld(LD_R1), .d(WB), .reset(Reset), .clock(Clock), .q(R1out));
ajc_nbit_reg_v #8 R2 (.ld(LD_R2), .d(WB), .reset(Reset), .clock(Clock), .q(R2out));
ajc_nbit_reg_v #8 R3 (.ld(LD_R3), .d(WB), .reset(Reset), .clock(Clock), .q(R3out));

//Selection of SRC1 and SRC2
ajc_nbit_4to1mux_v SRC1_sel (.d3(R3out), .d2(R2out), .d1(R1out), .d0(R0out), .s(SRC1_SEL), .f(SRC1));
ajc_nbit_4to1mux_v SRC2_sel (.d3(R3out), .d2(R2out), .d1(R1out), .d0(R0out), .s(SRC2_SEL), .f(SRC2));

//ALU instantiation and CNVZ register
ajc_8bit_ALU ALU_struc (.Func_Sel(ALU_FS), .Operand_X(SRC1), .Operand_Y(SRC2), .Const_K(IRout[1:0]), .Cin(SRout[3]),
				.ALU_Result(ALU_Result), .ALU_CNVZ(ALU_CNVZ));
ajc_nbit_reg_v #4 CNVZ_reg (.ld(LD_SR), .d(ALU_CNVZ), .reset(Reset), .clock(Clock), .q(SRout));
assign SR_CNVZ = SRout;

//PM interface
ajc_nbit_cntup_v #10 PC (.ld(LD_PC), .d(MARout), .reset(RST_PC), .cntup(CNT_PC), .clock(Clock), .q(PCout));
ajcRISC_ROM_v PM (.address(PCout), .clock(~Clock), .q(PMout));
ajc_nbit_reg_v #8 IR (.ld(LD_IR), .d(PMout), .reset(Reset), .clock(Clock), .q(IRout));
assign IW = IRout;

//DM interface
assign MABRin = (IW[7:4] == 4'b1101) ? {PMout[7], PMout[7], PMout} : {PMout, 2'b00};
assign MAXRin = (IW[7:4] == 4'b1101) ? PCout : {SRC1[7], SRC1[7], SRC1};
ajc_nbit_reg_v #10 MABR (.ld(LD_MABR), .d(MABRin), .reset(Reset), .clock(Clock), .q(MABRout));
ajc_nbit_reg_v #10 MAXR (.ld(LD_MAXR), .d(MAXRin), .reset(Reset), .clock(Clock), .q(MAXRout));
assign MARin = MABRout + MAXRout;
ajc_nbit_reg_v #10 MAR (.ld(LD_MAR), .d(MARin), .reset(Reset), .clock(Clock), .q(MARout));
ajcRISC_RAM_v DM (.address(MARout),.clock(~Clock), .data(SRC1), .wren(RW), .q(DMout));

//I/O P's interface
ajc_nbit_reg_v #8 OPDR (.ld(LD_OPDR), .d(SRC1), .reset(Reset), .clock(Clock), .q(LEDs));
ajc_nbit_reg_v #8 IPDR (.ld(LD_IPDR), .d({3'b000, PB1, SW}), .reset(Reset), .clock(Clock), .q(IPDRout));

endmodule

