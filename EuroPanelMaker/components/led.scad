tolerance = 0.05;
$fn = $preview ? 20 : 100;

module led(d = 3) {
    translate([0, 0, -1])
    {
        cylinder(d = d + (2 * tolerance), h = 2.5);
    
        translate([0, 0, -4])
        cylinder(d = d + 0.7 + (2 * tolerance), h = 4);
    }
}

led();
