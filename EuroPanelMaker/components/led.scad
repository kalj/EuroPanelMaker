tolerance = 0.05;
$fn = $preview ? 20 : 100;

module led(d = 3, flange_d = undef) {
    flange_d = flange_d ? flange_d : d + 0.7;
    translate([0, 0, -1])
    {
        cylinder(d = d + (2 * tolerance), h = 2.5);
    
        translate([0, 0, -4])
        cylinder(d = flange_d + (2 * tolerance), h = 4);
    }
}

led();
