tolerance = 0.3;
$fn = $preview ? 20 : 100;

module switch(width=8, diameter=7){
    cylinder(d = diameter + tolerance*2, h = 8);
    
    translate([0, 0, -7.5])
    cube([width + tolerance * 2, 13 + tolerance * 2, 15], center = true);
}

switch();