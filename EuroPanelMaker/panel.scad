use <components/jack_35mm.scad>
use <components/jack_14in.scad>
use <components/led.scad>
use <components/pot_rv16.scad>
use <components/pot_rd901f.scad>
use <components/mounting_tab.scad>
use <components/switch.scad>
use <components/switch_sr16.scad>
use <components/key.scad>
use <components/spacer.scad>
use <components/speaker.scad>

eurorack_h = 128.5;
eurorack_w = 5.08;

panel_thickness = 2; // thickness
component_depth = 1;
text_depth = 1.4;

rib_margin = 8;
rib_thickness = 3;
    
hp = 6;
w = hp * eurorack_w;
c = w / 2;

title = "Test";
title_font_size = 4.5;
title_font = "Liberation Sans:style=bold";
title_x = w / 2;
title_y = 118;
title_rotate = 0;

pots = [];
pots_rd901f = [];
leds = [];
jacks = []; // [x (in HP column), y (mm), label, size (35mm or 14in), rotation (degrees)]
switches = [];
switches_sr16 = [];
labels = [];
keys = [];
rectangular_holes = []; // [3, 100, x1, y1, x2, y2]
circular_holes = []; // [3, 100, dia]
spacers = [];
speakers = []; // x (in HP column), y (mm), speaker hole diameter, mount diameter, distance between two opposite screws

pots_rd901f_mm = [];
pots_mm = [];
leds_mm = [];
jacks_mm = []; 
switches_mm = [];
switches_sr16_mm = [];
labels_mm = [];
keys_mm = [];
rectangular_holes_mm = []; // [3, 100, x1, y1, x2, y2]
circular_holes_mm = []; // [10, 100, dia]
spacers_mm = [];

label_font = "Liberation Sans:style=bold";
label_font_size = 3;
pot_label_distance = 12;
pot_label_font_size = 3;
jack_label_distance = 8;
jack_label_font_size = 3;
jack_14in_label_distance = 12;
jack_14in_label_font_size = 3;
switch_label_distance = 12;
switch_label_font_size = 3;
key_label_distance = 14;
key_label_font_size = 3;

// Flip panel for 3D printing
panel_flipped = false;
panel_translate_x = panel_flipped ? w : 0;
panel_translate_z = panel_flipped ? panel_thickness : 0;
panel_rotate = panel_flipped ? 180 : 0;

margin = 0;

// Board mount

boardmount_board = [];
// [length,
//   width,
//   hole_yoffset,
//   hole_zoffset, 
//   hole_diam,
//   offset]
boardmount_with_frame=false;

boardmount_wedges=[];
// [ [xoffset, size] ]


module boardmount_wedge(params)
{
    y = params[0];
    size = params[1] ? params[1] : 4;
    thickness = params[2] ? params[2] : 1;
    angle = params[3] ? params[3] : 0;

    depth = thickness/2 * tan(abs(angle));

    translate([0,y+thickness/2,0])
        rotate([-90,0,angle])
    {
        translate([depth, 0, -thickness/2])
        linear_extrude(thickness)
        {
            polygon([[0,0], [-(size+depth),0], [0,(size+depth)]]);
        }
    }
}

module generate_boardmount()
{
    if(boardmount_board)
    {
        board_length = boardmount_board[0];
        board_width = boardmount_board[1];
        holes = boardmount_board[2];
        hole_diam = boardmount_board[3];

        thickness=2;
        board_zoffset = 12;
        length = board_length;
        height = board_zoffset + board_width;
        yoffset=boardmount_board[4]? boardmount_board[4] : (eurorack_h-board_length)/2;

        translate([hp*eurorack_w-thickness,yoffset,-rib_thickness])
        {
            for(w=boardmount_wedges) {
                boardmount_wedge(w);
            }

            translate([0,0,-height])
            {
                if($preview) translate([-thickness-2,0,0]) #cube([2, board_length, board_width]);

                difference()
                {
                    if(boardmount_with_frame)
                    {
                        union() {
                            difference()
                            {
                                frame_thickness=3;
                                cube([thickness,length,height]);
                                translate([-1,frame_thickness, frame_thickness])
                                    cube([thickness+2,length-frame_thickness*2,board_width-frame_thickness*2]);
                            }
                            intersection()
                            {
                                cube([thickness,length,height]);
                                n=20;
                                angle=40;
                                separation=13;
                                mesh_thickness=2;

                                union() {
                                    for(i=[-n:n]) {
                                        translate([thickness/2,length/2+i*separation,0])
                                        {
                                            rotate([angle,0,0]) cube([thickness,mesh_thickness,1000], center=true);
                                            rotate([-angle,0,0]) cube([thickness,mesh_thickness,1000], center=true);
                                        }
                                    }

                                    for(hole = holes) {
                                        y=hole[0] < 0 ? board_length+hole[0] : hole[0];
                                        z=hole[1] < 0 ? board_width+hole[1] : hole[1];
                                        translate([0,y,z])
                                            rotate([0,90,0])
                                            cylinder(d=hole_diam+4, h=thickness);
                                    }
                                }

                            }
                        }
                    }
                    else
                    {
                        cube([thickness,length,height]);
                    }

                    for(hole =holes) {
                        y=hole[0] < 0 ? board_length+hole[0] : hole[0];
                        z=hole[1] < 0 ? board_width+hole[1] : hole[1];
                        translate([-1,y,z])
                            rotate([0,90,0])
                            cylinder(d=hole_diam, h=20);
                    }
                }
            }
        }
    }
}


module generatePanel() {
    $fn = $preview ? 20 : 100;

    echo("Panel Maker:", hp = hp, w = w, title = title);   

    translate([panel_translate_x, 0, panel_translate_z])
    rotate([0, panel_rotate, 0])
    difference(){
        union(){
            generate_boardmount();
            translate([-margin, 0, 0])
            union() {
                cube([w + margin * 2, eurorack_h, panel_thickness]);
                
                translate([0, rib_margin, -rib_thickness])
                cube([w + margin * 2, eurorack_h - rib_margin * 2, rib_thickness]);
            }
        }
        
        union(){
            generate_title();
            generate_mounting_holes();
            
            for (idx = [0 : len(pots)]) {
                if (pots[idx]) {
                    echo("POT:", idx = pots[idx]);
                    generate_pots(pots[idx], eurorack_w * pots[idx][0]);
                }
            }

            for (idx = [0 : len(pots_mm)]) {
                if (pots_mm[idx]) {
                    echo("POT:", idx = pots_mm[idx]);
                    generate_pots(pots_mm[idx], pots_mm[idx][0]);
                }
            }
            
            for (idx = [0 : len(pots_rd901f)]) {
                if (pots_rd901f[idx]) {
                    echo("POTS RD901F:", idx = pots_rd901f[idx]);
                    generate_pots_rd901f(pots_rd901f[idx], eurorack_w * pots_rd901f[idx][0]);
                }
            }
            
            for (idx = [0 : len(pots_rd901f_mm)]) {
                if (pots_rd901f_mm[idx]) {
                    echo("POTS RD901F:", idx = pots_rd901f_mm[idx]);
                    generate_pots_rd901f(pots_rd901f_mm[idx], pots_rd901f_mm[idx][0]);
                }
            }
                     
            for (idx = [0 : len(leds)]) {
                if (leds[idx]) {
                    echo("LED:", idx = leds[idx]);
                    generate_leds(leds[idx], eurorack_w * leds[idx][0]);
                }
            }

            for (idx = [0 : len(leds_mm)]) {
                if (leds_mm[idx]) {
                    echo("LED:", idx = leds_mm[idx]);
                    generate_leds(leds_mm[idx], leds_mm[idx][0]);
                }
            }
            
            for (idx = [0 : len(jacks)]) {
                if (jacks[idx]) {
                    echo("JACK:", idx = jacks[idx]);
                    generate_jacks(jacks[idx], eurorack_w * jacks[idx][0]);
                }
            }

            for (idx = [0 : len(jacks_mm)]) {
                if (jacks_mm[idx]) {
                    echo("JACK:", idx = jacks_mm[idx]);
                    generate_jacks(jacks_mm[idx], jacks_mm[idx][0]);
                }
            }
            
            for (idx = [0 : len(switches)]) {
                if (switches[idx]) {
                    echo("SWITCH:", idx = switches[idx]);
                    generate_switches(switches[idx], eurorack_w * switches[idx][0]);
                }
            }
            
            for (idx = [0 : len(switches_sr16)]) {
                if (switches_sr16[idx]) {
                    echo("SWITCH SR16:", idx = switches_sr16[idx]);
                    generate_switches_sr16(switches_sr16[idx], eurorack_w * switches_sr16[idx][0]);
                }
            }            
            
            for (idx = [0 : len(switches_sr16_mm)]) {
                if (switches_sr16_mm[idx]) {
                    echo("SWITCH SR16 (mm):", idx = switches_sr16_mm[idx]);
                    generate_switches_sr16(switches_sr16_mm[idx], switches_sr16_mm[idx][0]);
                }
            }
            
            for (idx = [0 : len(switches_mm)]) {
                if (switches_mm[idx]) {
                    echo("SWITCH:", idx = switches_mm[idx]);
                    generate_switches(switches_mm[idx], switches_mm[idx][0]);
                }
            }
 
             for (idx = [0 : len(keys)]) {
                if (keys[idx]) {
                    echo("KEY:", idx = keys[idx]);
                    generate_keys(keys[idx], eurorack_w * keys[idx][0]);
                }
            }

            for (idx = [0 : len(keys_mm)]) {
                if (keys_mm[idx]) {
                    echo("KEY:", idx = keys_mm[idx]);
                    generate_keys(keys_mm[idx], keys_mm[idx][0]);
                }
            }
            
            for (idx = [0 : len(labels)]) {
                if (labels[idx]) {
                    echo("LABEL:", idx = labels[idx]);
                    generate_extra_labels(labels[idx], eurorack_w * labels[idx][0]);
                }
            }

            for (idx = [0 : len(labels_mm)]) {
                if (labels_mm[idx]) {
                    echo("LABEL:", idx = labels_mm[idx]);
                    generate_extra_labels(labels_mm[idx], labels_mm[idx][0]);
                }
            }
            
            for (idx = [0 : len(rectangular_holes)]) {
                if (rectangular_holes[idx]) {
                    echo("HOLE:", idx = rectangular_holes[idx]);
                    generate_rectangular_holes(rectangular_holes[idx], eurorack_w * rectangular_holes[idx][0]);
                }
            }
            
            for (idx = [0 : len(rectangular_holes_mm)]) {
                if (rectangular_holes_mm[idx]) {
                    echo("HOLE:", idx = rectangular_holes_mm[idx]);
                    generate_rectangular_holes(rectangular_holes_mm[idx], rectangular_holes_mm[idx][0]);
                }
            }

            for (idx = [0 : len(circular_holes)]) {
                if (circular_holes[idx]) {
                    echo("HOLE:", idx = circular_holes[idx]);
                    generate_circular_holes(circular_holes[idx], eurorack_w * circular_holes[idx][0]);
                }
            }
            
            for (idx = [0 : len(circular_holes_mm)]) {
                if (circular_holes_mm[idx]) {
                    echo("HOLE:", idx = circular_holes_mm[idx]);
                    generate_circular_holes_mm(circular_holes_mm[idx], circular_holes_mm[idx][0]);
                }
            }
            
            for (idx = [0 : len(spacers)]) {
                if (spacers[idx]) {
                    echo("SPACER:", idx = spacers[idx]);
                    generate_spacers(spacers[idx], eurorack_w * spacers[idx][0]);
                }
            }
            
            for (idx = [0 : len(spacers_mm)]) {
                if (spacers_mm[idx]) {
                    echo("SPACER_MM:", idx = spacers_mm[idx]);
                    generate_spacers(spacers_mm[idx], spacers_mm[idx][0]);
                }
            }
            
            for (idx = [0 : len(speakers)]) {
                if (speakers[idx]) {
                    echo("SPEAKERS:", idx = speakers[idx]);
                    generate_speakers(speakers[idx], eurorack_w * speakers[idx][0]);
                }
            }
            
        }
    }

}

module generate_speakers(params = [3, 100, 3], xpos){
    translate([xpos, params[1], 0 ])
        #speaker(d=params[2], mount=params[3], screw=params[4]);
}

module generate_spacers(params = [3, 100, 3], xpos){
    translate([xpos, params[1], 0 ])
        spacer(m=params[2]);
}

module generate_rectangular_holes(params = [3, 100, 25, 20, 30, 30], xpos) {
    translate([xpos, params[1], 0 ])
    union() {
        #cube([params[2], params[3], panel_thickness*2], center=true);
        
        translate([0, 0, -panel_thickness])
        #cube([params[4], params[5], panel_thickness], center=true);   
    }
}

module generate_circular_holes(params = [3, 100, 25, 20, 30, 30], xpos) {
    translate([xpos, params[1], 0 ])
    union() {
        translate([0, 0, -rib_thickness/2])
        #cylinder(r=params[2]/2, (panel_thickness + rib_thickness)*2, center=true);
    }
}
    
module generate_title() {
    translate([title_x, title_y, panel_thickness - text_depth])
    rotate([0, 0, title_rotate])
    linear_extrude(height = text_depth + 1)
    text(title, font = title_font, size = title_font_size, halign = "center"); 
}

module generate_mounting_holes(params=[2, 95, "Label"]) {
    if (hp == 1 || hp == 2){
        translate([eurorack_w/2, 3, 0])
        cylinder(r = 1.6, h = 10, center = true);
        
        translate([eurorack_w/2, eurorack_h - 3, 0])
        cylinder(r = 1.6, h = 10, center = true);
            
        
            
    } else {
        hull(){
            translate([6, 3, 0])
            cylinder(r = 1.6, h = 10, center = true);
            
            translate([9, 3, 0])
            cylinder(r = 1.6, h = 10, center = true);
        }
        
        hull(){
            translate([6, eurorack_h - 3, 0])
            cylinder(r = 1.6, h = 10, center = true); 
            
            translate([9, eurorack_h - 3, 0])
            cylinder(r = 1.6, h = 10, center = true);  
        }
    }
    
    if (hp >= 5){
        hull(){
            translate([w - 6, 3, 0])
            cylinder(r = 1.6, h = 10, center = true);
            
            translate([w - 9, 3, 0])
            cylinder(r = 1.6, h = 10, center = true);
        }
        hull(){
            translate([w - 6, eurorack_h - 3, 0])
            cylinder(r = 1.6, h = 10, center = true);
            
            translate([w - 9, eurorack_h - 3, 0])
            cylinder(r = 1.6, h = 10, center = true);
        }
    } 
}

module generate_extra_labels(params, width) {
    translate([width, params[1], panel_thickness - text_depth ])
    rotate([0, 0, params[3] ? params[3] : 0])
    linear_extrude(height = text_depth + 1)
    text(params[2], font = label_font, size = label_font_size, halign = "center");
}

module generate_pots(params, width) {
    translate([width, params[1], component_depth])
    rotate([0, 0, params[3] ? params[3] : 0])
    #pot_rv16();

    translate([width, params[1] + pot_label_distance, panel_thickness - text_depth])
    linear_extrude(height = text_depth + 1)
    text(params[2], font = label_font, size = pot_label_font_size, halign = "center", valign = "center");
}

module generate_pots_rd901f(params, width) {
    translate([width, params[1], component_depth])
    rotate([0, 0, params[3] ? params[3] : 0])
    #pot_rd901f();

    translate([width, params[1] + pot_label_distance, panel_thickness - text_depth])
    linear_extrude(height = text_depth + 1)
    text(params[2], font = label_font, size = pot_label_font_size, halign = "center", valign = "center");
}

module generate_jacks(params, width){
    if (!params[3] || params[3] == "35mm") {
        translate([width, params[1], component_depth])
        rotate([0, 0, params[4] ? params[4] : 0])
        #jack_35mm();

        translate([width, params[1] + jack_label_distance, panel_thickness - text_depth])
        linear_extrude(height = text_depth + 1)
        text(params[2], font = label_font, size = jack_label_font_size, halign = "center", valign = "center");
    } else if (params[3] == "14in") {
        translate([width, params[1], component_depth])
        rotate([0, 0, params[4] ? params[4] : 0])
        #jack_14in();

        translate([width, params[1] + jack_14in_label_distance, panel_thickness - text_depth])
        linear_extrude(height = text_depth + 1)
        text(params[2], font = label_font, size = jack_14in_label_font_size, halign = "center", valign = "center");
    }
}

module generate_switches(params, width){
    cdepth = alist_get(params[5], "component_depth", component_depth);
    switch_size = alist_get(params[5], "size", 8);


    translate([width, params[1], cdepth])
    rotate([0, 0, params[4] ? params[4] : 0])
    #switch(switch_size);

    translate([width, params[1] + switch_label_distance, panel_thickness - text_depth])
    linear_extrude(height = text_depth + 1)
    text(params[2], font = label_font, size = switch_label_font_size, halign = "center", valign = "center");
    
    translate([width, params[1] - switch_label_distance, panel_thickness - text_depth])
    linear_extrude(height = text_depth + 1)
    text(params[3], font = label_font, size = switch_label_font_size, halign = "center", valign = "center");
}

module generate_switches_sr16(params, xpos) {
    translate([xpos, params[1], component_depth - 1])
    rotate([0, 0, params[3] ? params[3] : 0])
    #switch_sr16();

    translate([xpos, params[1] + pot_label_distance, panel_thickness - text_depth])
    linear_extrude(height = text_depth + 1)
    text(params[2], font = label_font, size = pot_label_font_size, halign = "center", valign = "center");
}

module generate_keys(params, width){
    translate([width, params[1], component_depth])
    #key();

    translate([width, params[1] + key_label_distance, panel_thickness - text_depth])
    linear_extrude(height = text_depth + 1)
    text(params[2], font = label_font, size = key_label_font_size, halign = "center", valign = "center");
}

function alist_get(alist, key, default) = (!alist  || search([key], alist) == [[]]) ? default :
    alist[search([key],alist)[0]][1];

module generate_leds(params, width){
    cdepth = alist_get(params[3], "component_depth", component_depth);
    flange_diam = alist_get(params[3], "flange_diam", 6);

    translate([width, params[1], cdepth])
        #led(params[2], flange_diam);

}

// uncomment the following line for testing, otherwise it causes panels to generate twice
//generatePanel();