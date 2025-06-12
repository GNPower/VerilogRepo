# set up paths, top-level module, parameters ...
do setenv.do

# add 3rd party simulation libraries (this replaces the vsim command)
do ipgen.do

# compile the source files
do compile.do

# Set the top-level testbench name, used by elab to elaborate the top level
set TOP_LEVEL_NAME $top

# Call the command to elaborate your design and testbench
elab_debug

# Clear previous simulation
restart -f

# add signals to waveform
do waves.do

# run simulation
run -all

# save state of internal memories
do save.do

