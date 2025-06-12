# Getting Started

General:
- Install your preferred HDL simulator (Modelsim, Questa, etc.) and add it to the system path
- Install [Universal Ctags](https://github.com/universal-ctags/ctags) and optionally add it to the path (can use a VSCode settings entry described below instead)
- Install [Verible](https://github.com/chipsalliance/verible) and optionally add it to the path (can use a VSCode settings entry described below instead)

In VSCode:
- Install the Verilog-HDL/SystemVerilog/Bluespec SystemVerilog Extension (by Masahiro Hiramori)
- Install the Ctags Companion Extension (by Gediminas Zlatkus)

# Useful settings (`settings.json`)

Create and place these example settings in a `settings.json` file in this directory.

```json

{
    "ctags-companion.command": "ctags -R --fields=+nKz --langmap=SystemVerilog:+.v -R rtl <path>/<to>/<uvm>/src",
    "verilog.ctags.path": "<path>/<to>/ctags/ctags.exe",

    "verilog.linting.path": "<path>/<to>/<modelsim>/<bin>",
    "verilog.linting.linter": "modelsim",
    "verilog.linting.modelsim.arguments": "-pedanticerrors -qlint -timescale=1ps/1ps",
    "verilog.linting.modelsim.work": "sim/work",

    "verilog.languageServer.veribleVerilogLs.enabled": true,
    "verilog.languageServer.veribleVerilogLs.path": "<path>/<to>/verible/verible-verilog-ls.exe",

    "verilog.formatting.verilogHDL.formatter": "verible-verilog-format",
    "verilog.formatting.systemVerilog.formatter": "verible-verilog-format",
    "verilog.formatting.veribleVerilogFormatter.path": "<path>/<to>/verible/verible-verilog-format.exe"
}

```

Additional Useful Settings:
- If you are supporting Verilog (not SystemVerilog) then you can add the flag `-vlog01compat` to the `verilog.linting.modelsim.arguments` to only support `Verilog 2001` during linting
- Change `verilog.linting.<simulator>` to the correct simulator you are using
    - See Verilog-HDL Extension for more details
- You can replace explicit paths to `verible-verilog-ls.exe`, `verible-verilog-format.exe`, and `ctags.exe` if their directories are in the User or System PATH variables