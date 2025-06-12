# VerilogRepo
Template repository for a Verilog Repo. Contains everything needed to get up and running for both Synthesis and Simulation

### Contents
- VSCode HDL Integration
- HDL On Git (HOG)

## Steps:

1. Init submodules
    - `git submodule update --init --recursive --remote`
2. Add a Git tag 
    - `git tag -m "First Version" v0.0.1`
    - `git push --tags`
3. Create project
    - `./hog/Do CREATE <Project Name>`
    