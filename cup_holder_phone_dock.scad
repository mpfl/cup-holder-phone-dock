/*

Customisable cup holder adapter for a phone

Originally designed for Toyota Yaris cup holder to fit a Samsung Galaxy S8

(c) Matthias Liffers 2018

Released under CC-BY 4.0 license

All dimensions in millimetres

Changelog:

v0.1
 * First release

v0.2
 * Added side walls to dock rest to stop phone falling over when not plugged in
 * Added plug offset for phones where the plug is not dead centre along the y axis
 * Removed roundess from top

v1.0
 * modularised code
 * a bit more friendly for Thingiverse Customizer

*/ 

/* [ Basics ] */

// Diameter of cup holder
holder_diameter = 76; 
// Height of cup holder
holder_height = 60;
// Set to 0 for square edges. Don't set to more than half of the smaller of holder_diameter or holder_height or you'll get a sphere
holder_roundness = 10;

// Phone width
phone_x = 69;
// Phone Depth
phone_y = 9 ;

// Angle at which the phone should lean back
dock_angle = 20;
// Depth at which phone should be inset into the holder
dock_z = 15;

/* [ Back rest ] */

// Add back rest
dock_rest = true;
// Phone back rest height
dock_rest_z = 20;
// Phone back rest width
dock_rest_x = phone_x;
// Phone back rest depth
dock_rest_y = 5;

/* [ Charge plug hole ] */

plug = true; // Add charge plug hole
// Width of charging plug
plug_x = 12.2;
// Depth of charging plug
plug_y = 4.7;
// Length of charging plug, minus the contacts
plug_z = 19;
// Distance of charging plug from front of phone
plug_offset = 3.3;

/* [ Cable routing channel ] */

// Add cable routing channel
cable = true;
// Width of cable routing channel
cable_x = 3;
// Depth of cable routing channel
cable_y = 3;

// Smoothness of all rounded edges. Use a low number for faster rendering, increase when performing final render
round_smoothness= 72;

cos_d_a = cos(dock_angle);
sin_d_a = sin(dock_angle);
tan_d_a = tan(dock_angle);

holder_radius = holder_diameter/2;
dock_drop = (sin_d_a * phone_y / 2) - (cos_d_a * dock_z / 2);
dock_height_add = tan_d_a * (phone_y / 2 + dock_rest_y);
gouge_height = holder_height - ((cos_d_a * plug_z) + (cos_d_a * dock_z) - (sin_d_a * (phone_y - plug_offset)));
rest_setback = (sin_d_a * dock_z / 2) + (cos_d_a * phone_y / 2);

difference() {
    difference() {
        union() {
            // Main body
            translate([0 ,0 , holder_roundness])
                difference() {
                    minkowski() {
                        cylinder(h=(holder_height-(holder_roundness)), r=(holder_radius-holder_roundness), $fn=round_smoothness);
                        sphere(holder_roundness, $fn=round_smoothness);
                    }
                    translate([0, 0, holder_height - holder_roundness])
                        cylinder(h = holder_roundness, r = holder_radius, $fn=round_smoothness);
                }
                // Dock rest
                if (dock_rest)
                    create_dock_rest();
        }
        // Phone inset
        translate([(0 - phone_x) / 2, 0, holder_height + dock_drop])
            rotate(a = (0 - dock_angle), v = [1, 0, 0])
                translate ([0, 0 - (phone_y / 2), 0 - (dock_z / 2)])
                    union() {
                        cube([phone_x, phone_y, dock_z + 1]);
                        if (plug) 
                            create_plug_hole();
                    }
        // Cable holder
        if (cable)
            create_cable_channel();
        // Bottom gouges
        translate([0 - (plug_x + 5) / 2, 0 - holder_radius, 0])
            cube([plug_x + 5, holder_diameter, gouge_height]);
        translate([0 - holder_radius, 0 - (plug_x + 5) / 2, 0])
            cube([holder_diameter, plug_x + 5, gouge_height]);
    }
    // Trim entire cup holder down to just the radius and slice the top off the dock
    difference() {
        cylinder(h = holder_height + dock_rest_z * 2, r = holder_radius * 2, $fn = round_smoothness);
        cylinder(h = holder_height + dock_rest_z + dock_height_add, r = holder_radius, $fn = round_smoothness);
    }
}

module create_dock_rest() {
    translate([0 - (dock_rest_x / 2), rest_setback, holder_height])
        rotate(a = (0 - dock_angle), v = [1, 0, 0])
            translate([0, 0, 0 - dock_height_add])
                union() {
                    cube([dock_rest_x, dock_rest_y, dock_rest_z + dock_height_add]);
                    translate([0 - dock_rest_y, 0 - phone_y, 0])
                        cube([dock_rest_y, phone_y + dock_rest_y, dock_rest_z + dock_height_add]);
                    translate([dock_rest_x, 0 - phone_y, 0])
                        cube([dock_rest_y, phone_y + dock_rest_y, dock_rest_z + dock_height_add]);
                }    
}

module create_cable_channel() {
    translate([0 - (cable_x / 2), holder_radius - cable_y, -1])
        cube([cable_x, cable_y, holder_height +2]);
}

module create_plug_hole() {
    translate([phone_x / 2 - plug_x / 2, plug_offset, 0 - plug_z - 1])
        cube([plug_x, plug_y, plug_z + 2]);
}