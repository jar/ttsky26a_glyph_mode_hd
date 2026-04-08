## How it Works

This is a standalone VGA demo that runs with or without input, replicating *The
Matrix* Digital Rain effect.

![example VGA output](screenshot.png)

Upon circuit reset, the glyphs will appear to fall from the top of the screen.
Additionally, some glyphs will intermittently change.

You can change the palette with the three pins, `ui_io[2:0]`.

**NOTE** The default VGA timing requires a pixel clock of 25.175 MHz. If you
want to drive higher resolutions, the base clock rate must be adjusted
accordingly with the Display Clocks table below. You must also set the two
pins `ui_io[7:6]` to select your preferred mode.

## How to Test

Plug into a VGA monitor and select this circuit to test. By default, the
circuit must be clocked at (or very near) to **25.175 MHz**. There are four VGA
timing modes, representing four different display resolutions, which must be
both specifically clocked *and* have the pins `ui_io[7:6]` set according to the
following table.

### Display Clocks

**Pins 6 and 7 must be paired with pixel clock**

| `ui_io[7:6]` | Clock (Hz) | VGA Timing Mode             |
|-------------:|-----------:|----------------------------:|
|  (default) 0 |   25175000 |  640 x  480 @ 60 fps ( VGA) |
|            1 |   40000000 |  800 x  600 @ 60 fps (SVGA) |
|            2 |   74250000 | 1280 x  720 @ 60 fps (  HD) |
|            3 |   74250000 | 1920 x 1080 @ 30 fps ( FHD) |
 
### Palette Input

Use **Pins 0, 1, and 2** `ui_io[2:0]` for palette selection:

| `ui_io[2:0]` | Palette    | Example |
|-------------:|:-----------|---------|
|  (default) 0 | Green      |<div style="background:#000;font-weight:bolder;font-family:monospace"><span style="color:#050">#</span><span style="color:#0A0">#</span><span style="color:#0F0">#</span><span style="color:#0F5">#</span><span style="color:#5F5">#</span><span style="color:#5FA">#</span><span style="color:#AFA">#</span><span style="color:#FFF">#</span></div>|
|            1 | Red        |<div style="background:#000;font-weight:bolder;font-family:monospace"><span style="color:#500">#</span><span style="color:#A00">#</span><span style="color:#F00">#</span><span style="color:#F05">#</span><span style="color:#F55">#</span><span style="color:#F5A">#</span><span style="color:#FAA">#</span><span style="color:#FFF">#</span></div>|
|            2 | Blue       |<div style="background:#000;font-weight:bolder;font-family:monospace"><span style="color:#005">#</span><span style="color:#00A">#</span><span style="color:#00F">#</span><span style="color:#05F">#</span><span style="color:#55F">#</span><span style="color:#5AF">#</span><span style="color:#AAF">#</span><span style="color:#FFF">#</span></div>|
|            3 | Grape Soda |<div style="background:#000;font-weight:bolder;font-family:monospace"><span style="color:#505">#</span><span style="color:#A05">#</span><span style="color:#A0A">#</span><span style="color:#F0A">#</span><span style="color:#F0F">#</span><span style="color:#F5F">#</span><span style="color:#FAF">#</span><span style="color:#FFF">#</span></div>|
|            4 | Hellfire   |<div style="background:#000;font-weight:bolder;font-family:monospace"><span style="color:#500">#</span><span style="color:#A00">#</span><span style="color:#F50">#</span><span style="color:#FA0">#</span><span style="color:#FF0">#</span><span style="color:#FF5">#</span><span style="color:#FFA">#</span><span style="color:#FFF">#</span></div>|
|            5 | Monochrome |<div style="background:#000;font-weight:bolder;font-family:monospace"><span style="color:#FFF">#</span><span style="color:#FFF">#</span><span style="color:#FFF">#</span><span style="color:#FFF">#</span><span style="color:#FFF">#</span><span style="color:#FFF">#</span><span style="color:#FFF">#</span><span style="color:#FFF">#</span></div>|
|            6 | Noir       |<div style="background:#000;font-weight:bolder;font-family:monospace"><span style="color:#555">#</span><span style="color:#555">#</span><span style="color:#555">#</span><span style="color:#AAA">#</span><span style="color:#AAA">#</span><span style="color:#AAA">#</span><span style="color:#FFF">#</span><span style="color:#FFF">#</span></div>|
|            7 | Rainbow    |<div style="background:#000;font-weight:bolder;font-family:monospace"><span style="color:#F00">#</span><span style="color:#FA0">#</span><span style="color:#FF0">#</span><span style="color:#0A0">#</span><span style="color:#05F">#</span><span style="color:#A0A">#</span><span style="color:#F0F">#</span><span style="color:#FFF">#</span></div>|

## External hardware

Requires the [TinyVGA PMOD](https://github.com/mole99/tiny-vga)
