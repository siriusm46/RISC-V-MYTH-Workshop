\m4_TLV_version 1d: tl-x.org
\SV 
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/bd1f186fde018ff9e3fd80597b7397a1c862cf15/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\TLV
   |calc
      @0
         $reset = *reset;
      @1
         $cnt = $reset ? 0 : (>>1$cnt + 1);
         $valid = $cnt;
         $valid_or_reset = $valid || $reset;
      ?$valid_or_reset
         @1
            $val1[31:0] = >>2$out;       //Modification for memory
            $val2[31:0] = $rand2[3:0];
            //ADD
            $sum[31:0] = $val1 + $val2;
            //SUB
            $diff[31:0] = $val1 - $val2;
            //MUL
            $prod[31:0] = $val1 * $val2;
            //DIV
            $quot[31:0] = $val1 / $val2;
            //OUT
         @2
            //Free Running Counter
            $mem_mux[31:0] = $reset ? 32'b0 : ($op[2:0] == 3'b101) ? $out : $mem_mux;
            $out[31:0] =  ($reset || !$valid)  ? 32'b0 : ($op[2] ? >>2$mem_mux : (($op[1] ? ( $op[0] ? $quot : $prod ) : ( $op[0] ? $diff : $sum ))));
      
      // Macro instantiations for calculator visualization(disabled by default).
      // Uncomment to enable visualisation, and also,
      // NOTE: If visualization is enabled, $op must be defined to the proper width using the expression below.
      //       (Any signals other than $rand1, $rand2 that are not explicitly assigned will result in strange errors.)
      //       You can, however, safely use these specific random signals as described in the videos:
      //  o $rand1[3:0]
      //  o $rand2[3:0]
      //  o $op[x:0]
   
   m4+cal_viz(@3) // Arg: Pipeline stage represented by viz, should be atleast equal to last stage of CALCULATOR logic.

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   
\SV
   endmodule
