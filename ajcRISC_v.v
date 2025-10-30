module ajcRISC_v (Reset, Clock, PB1, SW, LEDs, ICis, crtMCis);

input Reset, Clock, PB1;
input [3:0] SW;
output [7:0] LEDs;
output [95:0] ICis;
output [2:0] crtMCis;

wire [7:0] IW;
wire [3:0] SR_CNVZ, ALU_FS;
wire RST_PC, LD_PC, CNT_PC, LD_IR, LD_R0, LD_R1, LD_R2, LD_R3,
	LD_TXR, LD_TYR, LD_TK, LD_SR, LD_MABR, LD_MAXR, LD_MAR, RW, 
	LD_IPDR, LD_OPDR;
wire [1:0] SRC1_SEL, SRC2_SEL, WB_SEL;

ajcRISC_DP_v DP
	(Reset, Clock, PB1, SW, LEDs, IW, SR_CNVZ, 
	RST_PC, LD_PC, CNT_PC, LD_IR, LD_R0, LD_R1, LD_R2, LD_R3,
	LD_TXR, LD_TYR, LD_TK, LD_SR, LD_MABR, LD_MAXR, LD_MAR, RW, 
	LD_IPDR, LD_OPDR, SRC1_SEL, SRC2_SEL, WB_SEL, ALU_FS);

ajcRISC_CU_v CU
	(Reset, Clock, IW, SR_CNVZ, 
	RST_PC, LD_PC, CNT_PC, LD_IR, LD_R0, LD_R1, LD_R2, LD_R3,
	LD_SR, LD_MABR, LD_MAXR, LD_MAR, RW, 
	LD_IPDR, LD_OPDR, SRC1_SEL, SRC2_SEL, WB_SEL, ALU_FS, crtMCis);

ajc_IW2ASCII_v ICdecode (IW, Reset, Clock, ICis);

endmodule