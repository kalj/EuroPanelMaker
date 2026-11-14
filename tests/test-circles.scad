include <../EuroPanelMaker/panel.scad>


hp = 6;
title = "CIRC";
margin = 0; // Add extra width on each side for support

circular_holes = [
    [3, 95, 10],
];

circular_holes_mm = [
    [15, 50, 20],
]; // x (mm), y (mm), diameter (mm)

panel_flipped = false;
generatePanel();
