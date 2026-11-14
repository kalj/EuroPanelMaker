include <../EuroPanelMaker/panel.scad>


hp = 4;
title = "LED";
margin = 0; // Add extra width on each side for support

leds = [
    [1, 100, 3],
    [3, 100, 5],
]; // x (in HP column), y (mm), diameter (mm)

leds_mm = [
    [10.16, 40, 5],
]; // x (mm), y (mm), diameter (mm)

panel_flipped = false;
generatePanel();
