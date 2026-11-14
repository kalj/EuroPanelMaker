include <../EuroPanelMaker/panel.scad>


hp = 6;
title = "MM";
margin = 0; // Add extra width on each side for support

pots_mm = [
    [15.24, 90, "POT"],
]; // x (mm), y (mm), label, rotation (degrees)

switches_mm = [
    [15.24, 40, "UP", "DOWN"],
]; // x (mm), y (mm), label above, label below, rotation (degrees)

panel_flipped = false;
generatePanel();
