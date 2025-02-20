module spram_sram #(parameter AW=18)
(
  input               clka,
  input               ena,
  input               wea,
  input      [AW-1:0] addra,
  input      [7:0]    dina,
  output reg [7:0]    douta,

  output reg [20:0]   SRAM_ADDR,
  inout      [15:0]   SRAM_DATA,
  output reg          SRAM_WE_n
);

reg [7:0] data;
assign SRAM_DATA = (ena && ~SRAM_WE_n) ? {8'bZZZZZZZZ,data} : 16'hZZZZ;
//reg [7:0] ram[(2**AW)-1:0];

always @(negedge clka)
  if (ena) begin
      SRAM_ADDR = {1'b0, addra};
		if (wea) begin
		   SRAM_WE_n <= 1'b0;			
			data <= dina;
		end
		else begin
			SRAM_WE_n <= 1'b1;
			douta <= SRAM_DATA[7:0];
		end
	end
endmodule
