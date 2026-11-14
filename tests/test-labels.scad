include <../EuroPanelMaker/panel.scad>


hp = 6;
title = "TITLE";
title_x = 20;
title_y = 105;
title_rotate = 15;
margin = 0; // Add extra width on each side for support

labels = [
    [3, 80, "LABEL"],
    [3, 55, "ROT 90", 90],
]; // x (in HP column), y (mm), text, rotation (degrees)

labels_mm = [
    [15, 25, "MM", 180],
]; // x (mm), y (mm), text, rotation (degrees)

panel_flipped = false;
generatePanel();
