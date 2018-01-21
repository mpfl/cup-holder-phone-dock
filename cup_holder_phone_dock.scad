/*

Customisable cup holder adapter for a phone

Originally designed for Toyota Yaris cup holder to fit a Samsung Galaxy S8

(c) Matthias Liffers 2018

Released under CC-BY 4.0 license

All dimensions in millimetres

Changelog:

v0.1
 * First release

*/ 

// Diameter of cup holder
holder_diameter = 76; 
// Height of cup holder
holder_height = 60;
// Set to 0 for square edges. Don't set to more than half of the smaller of holder_diameter or holder_height or you'll get a sphere
holder_roundness = 10;

// Phone width
phone_x = 68.1;
// Phone Depth
phone_y = 8;

// Angle at which the phone should lean back
dock_angle = 20;
// Depth at which phone should be inset into the holder
dock_z = 10;
// Phone back rest height
dock_rest_z = 25;
// Phone back rest width
dock_rest_x = 46;
// Phone back rest depth
dock_rest_y = 10;
// Set to 0 for square edges. Don't set to half or more of the smallest dock_rest dimension or you'll get a sphere.
dock_rest_roundness = 2;

// Width of charging plug
plug_x = 12.2;
// Depth of charging plug
plug_y = 4.7;
// Length of charging plug, minus the contacts
plug_z = 17.2; 

// Width of cable channel on the back
cable_x = 3;
// Depth of cable channel on the back
cable_y = 3;

// Smoothness of all rounded edges. Use a low number for faster rendering, increase when performing final render
round_smoothness= 72;

holder_radius = holder_diameter/2;
dock_drop = dock_z + (sin(dock_angle) * phone_y) - (cos(dock_angle) * dock_z);
gouge_height = holder_height - ((cos(dock_angle) * plug_z) + (cos(dock_angle) * dock_z)- (sin(dock_angle) * (phone_y - ((phone_y - plug_y) / 2))));
rest_setback = (sin(dock_angle) * dock_z) + (cos(dock_angle) * phone_y) - phone_y / 2;



difference() {
    union () {
        translate([0 ,0 ,holder_roundness])
            minkowski() {
                cylinder(h=(holder_height-(holder_roundness*2)), r=(holder_radius-holder_roundness), $fn=round_smoothness); // Cylinder
                sphere(holder_roundness, $fn=round_smoothness);
            }
            translate([0 - (dock_rest_x / 2), rest_setback, holder_height])
                rotate(a = (0 - dock_angle), v = [1, 0, 0])
                    translate([dock_rest_roundness, dock_rest_roundness, 0 - (dock_rest_roundness/2)])
                        minkowski() {
                            cube([dock_rest_x-(dock_rest_roundness*2), dock_rest_y-(dock_rest_roundness*2), dock_rest_z-dock_rest_roundness/2]); // Dock rest
                            sphere(dock_rest_roundness, $fn=round_smoothness);
                        }
    }
    translate([(0 - phone_x) / 2,(0 - phone_y) / 2, holder_height + dock_drop - dock_z])
        rotate(a = (0 - dock_angle), v = [1, 0, 0])
            union() {
                cube([phone_x, phone_y, dock_z]);
                translate([phone_x / 2 - plug_x / 2, phone_y / 2 - plug_y / 2, 0 - plug_z - 1])
                    cube([plug_x, plug_y, plug_z + 2]); // Plug hole
            }
    translate([0 - (cable_x / 2), holder_radius - cable_y, 0])
        cube([cable_x, cable_y, holder_height]); // Cable holder
    translate([0 - (plug_x + 5) / 2, 0 - holder_radius, 0])
        cube([plug_x + 5, holder_diameter, gouge_height]); // Bottom gouge
    translate([0 - holder_radius, 0 - (plug_x + 5) / 2, 0])
        cube([holder_diameter, plug_x + 5, gouge_height]); // Bottom gouge
}