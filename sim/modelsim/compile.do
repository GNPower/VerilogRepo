# here you will add compile commands.
# for large projects you can place various compile scripts in the 'compile' subfolder
# its recommended to add the following parameters to any vlog commands: +define+DISABLE_DEFAULT_NET +incdir+$rtl

vlog -sv +define+DISABLE_DEFAULT_NET +incdir+$rtl $rtl/example.sv

vlog -sv +define+DISABLE_DEFAULT_NET +incdir+$rtl $tb/example_tb.sv
