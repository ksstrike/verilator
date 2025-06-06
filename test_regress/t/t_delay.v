// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2003 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

`timescale 100ns/1ns

module t (/*AUTOARG*/
   // Inputs
   clk
   );

   input clk;
   int cyc;

   reg [31:0] dly0;
   wire [31:0] dly1;
   wire [31:0] dly2 = dly1 + 32'h1;
   wire [31:0] dly3;
   wire [31:0] dly4;

   typedef struct packed { int dly; } dly_s_t;
   dly_s_t dly_s;

   assign #(1.2000000000000000) dly1 = dly0 + 32'h1;
   assign #(sub.delay) dly3 = dly1 + 1;
   assign #sub.delay dly4 = dly1 + 1;

   sub sub();

   always @ (posedge clk) begin
      cyc <= cyc + 1;
      if (cyc == 1) begin
         dly0 <= #0 32'h11;
      end
      else if (cyc == 2) begin
         dly0 <= #0.12 dly0 + 32'h12;
      end
      else if (cyc == 3) begin
         if (dly0 !== 32'h23) $stop;
         if (dly2 !== 32'h25) $stop;
      end
      else if (cyc == 4) begin
         dly_s.dly = 55;
         dly0 <= #(dly_s.dly) 32'h55;
         //dly0 <= # dly_s.dly 32'h55;  // Unsupported, issue #2410
      end
      else if (cyc == 99) begin
         if (dly3 !== 32'h57) $stop;
         $write("*-* All Finished *-*\n");
         #100 $finish;
      end
   end

endmodule

module sub;
   realtime delay = 2.3;
endmodule
