module ajc_IW2ASCII_v (IW, Reset, Clock, ICis);
//=============================================================================
// This module is converting the IW information into a string of ASCII 
// characters. This is ONLY needed for debugging purposes. It should be 
// commented out or eliminated when compiling/ synthesizing for FPGA 
// implementation. It is described behaviorally. In the ModelSim wavform, 
// select the display radix for this output signal to be ASCII.
//=============================================================================	
// Input and output ports declarations
//=============================================================================	
input [7:0] IW;
input Reset, Clock;
output reg [95:0] ICis;
//=============================================================================
// Internal wires declarations
//=============================================================================
reg [7:0] iw32, iw10, sbit;
//=============================================================================
always @ (posedge Clock) begin
//=============================================================================
// Converting register numbers to ASCII digit character numbers
//=============================================================================
iw32 = 8'h30 + {6'b000000, IW[3:2]};
iw10 = 8'h30 + {6'b000000, IW[1:0]};
//=============================================================================
// Similarly for the status bit used in the (conditional) JUMP
//=============================================================================
if (IW[3:0] == 4'b0000) sbit = 8'h55;
else if (IW[3:0] == 4'b1000) sbit = 8'h43;
else if (IW[3:0] == 4'b0100) sbit = 8'h4E;
else if (IW[3:0] == 4'b0010) sbit = 8'h56;
else if (IW[3:0] == 4'b0001) sbit = 8'h5A;
else sbit = 8'h3f;
//=============================================================================
// After the IW is passed on to the CU in MC1, the current IC can be 
// idenitified and the corresponding assembly instruction displayed.
//=============================================================================
if (Reset == 1'b1)
	ICis = {8'h52, 8'h53, 8'h54, 8'h20}; //RST;
else case (IW[7:4])
	4'b0000 : ICis = {8'h41, 8'h44, 8'h44, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h52, iw10, 8'h3B}; //ADD
	4'b0001 : ICis = {8'h53, 8'h55, 8'h42, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h52, iw10, 8'h3B}; //SUB
	4'b0010 : ICis = {8'h49, 8'h4E, 8'h43, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h23, iw10, 8'h3B}; //INC
	4'b0011 : ICis = {8'h44, 8'h45, 8'h43, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h23, iw10, 8'h3B}; //DEC
	4'b0100 : ICis = {8'h58, 8'h4F, 8'h52, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h52, iw10, 8'h3B}; //XOR
	4'b0101 : ICis = {8'h41, 8'h4E, 8'h44, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h52, iw10, 8'h3B}; //AND
	4'b0110 : ICis = {8'h4F, 8'h52, 8'h20, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h52, iw10, 8'h3B}; //OR
	4'b0111 : ICis = {8'h43, 8'h50, 8'h59, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h52, iw10, 8'h3B}; //CPY
	4'b1000 : ICis = {8'h53, 8'h48, 8'h52, 8'h41, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h23, iw10, 8'h3B}; //SHRA
	4'b1001 : ICis = {8'h53, 8'h48, 8'h78, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h23, iw10, 8'h3B}; //SHxL
	4'b1010 : ICis = {8'h52, 8'h78, 8'h43, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h23, iw10, 8'h3B}; //RxC
	4'b1011 : ICis = {8'h4C, 8'h44, 8'h20, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h4D, 8'h41, 8'h3B}; //LD
	4'b1100 : ICis = {8'h53, 8'h54, 8'h20, 8'h20, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h4D, 8'h41, 8'h3B}; //ST
	4'b1101 : ICis = {8'h4A, 8'h55, 8'h4D, 8'h50, 8'h20, 8'h69, 8'h66, 8'h20, sbit, 8'h3D, 8'h31, 8'h3B}; //JUMP
	4'b1110 : ICis = {8'h49, 8'h4E, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h50, 8'h42, 8'h53, 8'h57, 8'h3B}; //IN
	4'b1111 : ICis = {8'h4F, 8'h55, 8'h54, 8'h20, 8'h52, iw32, 8'h2c, 8'h20, 8'h4C, 8'h45, 8'h44, 8'h3B}; //OUT
	default : ICis = {8'h4E, 8'h44, 8'h45, 8'h46}; //NDEF
	endcase
end
endmodule