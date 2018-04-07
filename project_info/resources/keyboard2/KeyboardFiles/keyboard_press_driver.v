module light(
  input outCode,
  output [0:0] LEDR
);
always @(*)
if (outCode == 2'h29) LEDR <= 1; 
endmodule 
