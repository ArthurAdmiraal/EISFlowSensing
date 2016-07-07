PCB_Height = 2.0;
Spacer = 12.5;
Insert = 3;
Clip = 2;
Structure = 2;
Width = 25;

cube([Spacer+2*(PCB_Height+Clip), Width, Structure]);

for(o=[0, Clip+PCB_Height, PCB_Height+Spacer, Clip+2*PCB_Height+Spacer]) {
    translate([o,0,0]) cube([Clip, Width, Structure+Insert]);
}