![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Glyph Mode HD

The name is a play on the VGA Text Mode, but this project uses glyphs seen in
[The Matrix Digital Rain](https://www.youtube.com/watch?v=SneR61OG4ZI) -- a
brilliant effect from the best science fiction movie since 1999.

![animated VGA output](docs/optimized.gif)

This began as an entry into the [Tiny Tapeout 08
Demoscene](https://tinytapeout.com/competitions/demoscene-tt08-winners/)
competition as a single tile design, earning a 1st and 2nd place in two
categories. It has been submitted as an entry into the [TTSKY26A
Demoscene](https://tinytapeout.com/competitions/demoscene-ttsky26a-announce/).
A number of improvements have been made, while maintaining the single tile
limit, including:

- Four different display resolutions at higher clock--up to ~7x the pixels!
  - 640x480 (VGA) default
  - 1024x768 (XGA)
  - 1280x720 (720p HD)
  - 1920x1080 (Full HD)
- Twice the number of color palettes (8 total) and a mixed palette mode
- Upon reset, the glyphs appear to fall from the top of the display
- Smoother rain animation (fast columns no longer jump two glyphs at a time)
- There are changing glyphs which periodically alternate
- Added 6 more glyphs from the movie (54 total)
- You can pause the animation
- An alternative display mode is supported for a second monitor
- The Verilog source has been improved with better comments

[Read the documentation](docs/info.md) to learn how to use the circuit.

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper
than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com
