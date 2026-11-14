include <../EuroPanelMaker/panel.scad>


hp = 8;
title = "JACKS";
margin = 0; // Add extra width on each side for support

jacks = [
    [2, 100, "THONK", "thonkiconn"],
    [6, 100, "STEREO", "thonkiconn_stereo"],
    [2, 75, "T90", "thonkiconn", 90],
    [6, 75, "S180", "thonkiconn_stereo", 180],
    [4, 45, "1/4", "14in"],
]; // x (in HP column), y (mm), label, type, rotation (degrees)

jacks_mm = [
    [20.32, 22, "MM", "35mm"],
]; // x (mm), y (mm), label, type, rotation (degrees)

panel_flipped = false;
generatePanel();
