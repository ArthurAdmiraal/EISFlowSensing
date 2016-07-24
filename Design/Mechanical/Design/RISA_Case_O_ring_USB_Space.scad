// quality settings
$fs = 0.05;
$fa = 2;

// CAM parameters
split = 10;

// parameters
margin          = 1.2;              // 1.2mm
topBevel        = 0.1*25.4;         // 0.1"
sideBevel       = 0.35*25.4+margin; // 0.35"
holeDist        = 0.85*25.4;        // 0.85"
height          = 100;              // 100mm
interconnect    = 12.8;             // 12.4mm, change this value
electrodeSize   = 2.2*25.4+margin;  // 2.2"
sigGenSize      = 2.0*25.4+margin*2;// 2.0"
pcbThickness    = 1.6;              // 1.6mm
holeSize        = 3.2 + margin;     // M3 clearance hole
componentSize   = 2.0;              // 2mm component clearance
componentRadius = 0.35*25.4;        // 0.35"
headerWidth     = 1.7*25.4;         // 1.7"
headerHeight    = 0.15*25.4+margin; // 0.15"
hubSize         = 1.061*25.4;       // 1.061"
hubOffset       = 0.22*25.4;        // 0.22"
hubHole         = 1.85+margin/2;    // #6-32 clearance radius, 1.85mm
hubWidth        = 2.05*25.4+margin; // 2.05"
hubHeight       = 1.25*25.4;        // 1.25"
hubRadius       = 0.75*25.4;        // 0.75"
angle           = 45;               // 45 degrees

extension      =  7+2*margin;
extensionBegin = 9;
extensionAngle = 45; // there is probably an error in calculations involving this angle, so best keep it on this
angleMargin    = 0.001;

extensionOffset = 2*sideBevel*(1-cos(extensionAngle));
slopedExtension = (extension - extensionOffset)/cos(extensionAngle);
extensionHeight = 2*sideBevel*sin(extensionAngle) + sin(extensionAngle)*slopedExtension;

// helper modules
// basic shapes
module torus(rminor, rmajor) {
    rotate_extrude() {
        translate([rmajor,0,0])
            circle(r=rminor);
    }
}

// building the object
// change intersection to difference for the bottom part
intersection() { difference() {
translate([0,0,-topBevel]) union() {
////////////////////////////////////////////////////////////
// top /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
union() {
// top corner bevels
for(o=[[1,1,0],[1,-1,0],[-1,1,0],[-1,-1,0]]) {
    translate(holeDist*o) {
        torus(topBevel, sideBevel-topBevel);
        cylinder(r=sideBevel-topBevel, h=2*topBevel, center=true);
    }
}

// top side bevels
for(o=[[1,0,0],[-1,0,0],[0,1,0],[0,-1,0]]) {
    translate((holeDist+sideBevel-topBevel)*o)
    rotate(90*o)
    cylinder(r=topBevel, h=2*holeDist, center=true);
}

// top filler
cube(2*[holeDist+sideBevel-topBevel,holeDist,topBevel], center=true);
cube(2*[holeDist,holeDist+sideBevel-topBevel,topBevel], center=true);
}

////////////////////////////////////////////////////////////
// main body ///////////////////////////////////////////////
////////////////////////////////////////////////////////////
// more comment comming for this part
translate([0,0,topBevel-height]) rotate([0,180,0]) union() {
// side bevels
translate([0,0,topBevel-height]) {
    for(o=[[1,-1,0],[-1,-1,0]]) {
        translate(holeDist*o)
        cylinder(r=sideBevel, h=height-topBevel);
    }
    
    for(o=[[1,1,0],[-1,1,0]]) {
        translate(holeDist*o)
        union() {
            cylinder(r=sideBevel, h=extensionBegin+angleMargin);
            
            translate([0,sideBevel,extensionBegin]) difference() {
                rotate([0,90,0])
                torus(sideBevel, sideBevel+angleMargin);
                translate([-sideBevel*1.05, 0, -sideBevel*2.1])
                cube([sideBevel*2.1, sideBevel*2.1, sideBevel*4.2]);
                translate([-sideBevel*1.05,-sideBevel*2.1,-sideBevel*2.1])
                cube([sideBevel*2.1, sideBevel*4.2, sideBevel*2.1]);
                translate([-sideBevel*1.05,0,0])
                rotate([extensionAngle-angleMargin,0,0])
                cube([sideBevel*2.1, sideBevel*2.1, sideBevel*2.1]);
            }
            
          translate([0,-sideBevel+extension,extensionBegin+extensionHeight]) {
                rotate([180,0,0]) difference(){
                rotate([0,90,0])
                torus(sideBevel, sideBevel+angleMargin);
                translate([-sideBevel*1.05, 0, -sideBevel*2.1])
                cube([sideBevel*2.1, sideBevel*2.1, sideBevel*4.2]);
                translate([-sideBevel*1.05,-sideBevel*2.1,-sideBevel*2.1])
                cube([sideBevel*2.1, sideBevel*4.2, sideBevel*2.1]);
                translate([-sideBevel*1.05,0,0])
                rotate([extensionAngle-angleMargin,0,0])
                cube([sideBevel*2.1, sideBevel*2.1, sideBevel*2.1]);
                }
            }
            translate([0,extension,extensionBegin+extensionHeight])
            cylinder(r=sideBevel, h=height-topBevel-extensionBegin-extensionHeight);
            
            translate([0,sideBevel,extensionBegin])
            rotate([-extensionAngle,0,0]) union() {
                translate([0,-sideBevel,0])
                cylinder(r=sideBevel, h=slopedExtension+angleMargin);
                translate([-sideBevel,-2*sideBevel,0])
                cube([2*sideBevel,sideBevel,slopedExtension+angleMargin]);
            }
        }
    }
}

translate([0,holeDist+extension-sideBevel,-height+topBevel+extensionBegin+extensionHeight])
rotate([0,90,0]) {
cylinder(r=sideBevel, h=2*(holeDist+sideBevel), center=true);
cylinder(r=2*sideBevel, h=2*(holeDist), center=true);
}

translate([-holeDist-sideBevel,holeDist+sideBevel,topBevel+extensionBegin-height]) {
    rotate([90-extensionAngle,0,0])
    translate([sideBevel,0,0])
    cube([2*holeDist, slopedExtension, sideBevel]);
difference() {
    translate([0,-sideBevel,0])
    cube([2*(holeDist+sideBevel),sideBevel,sideBevel]);
    translate([-0.05*(holeDist+sideBevel),0,0]) {
    rotate([0,90,0]) cylinder(r=sideBevel, h=2.1*(holeDist+sideBevel));
    rotate([extensionAngle,0,0])
    cube([2.1*(holeDist+sideBevel),2*sideBevel,2*sideBevel]);
    }
}
}

translate([0,0.5*extension,-0.5*(height-topBevel-extensionBegin-extensionHeight)]) {
cube([2*(holeDist+sideBevel),2*holeDist+extension,height-topBevel-extensionBegin-extensionHeight],center=true);
cube([2*holeDist,2*(holeDist+sideBevel)+extension,height-topBevel-extensionBegin-extensionHeight],center=true);
}

// main filler
translate(0.5*[0,0,topBevel-height]) {
cube([2*(holeDist+sideBevel),2*holeDist,height-topBevel],center=true);
cube([2*holeDist,2*(holeDist+sideBevel),height-topBevel],center=true);
}
}
}
////////////////////////////////////////////////////////////
// cutouts /////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// main cutout
translate([0,0,-height-1]) {
    for(o=[[1,1,0],[-1,1,0],[1,-1,0],[-1,-1,0]]) {
        translate(holeDist*o)
        cylinder(r=0.5*sigGenSize-holeDist, h=height-pcbThickness-interconnect+1);
    }
    
    translate(0.5*[0,0,height-pcbThickness-interconnect+1]) {
        cube([sigGenSize,2*holeDist,height-pcbThickness-interconnect+1], center=true);
        cube([2*holeDist,sigGenSize,height-pcbThickness-interconnect+1], center=true);
    }
}

// USB cable cutout
translate([0,extension,-extensionBegin-height-1]) {
    for(o=[[1,1,0],[-1,1,0]]) {
        translate(holeDist*o)
        cylinder(r=0.5*sigGenSize-holeDist, h=height-pcbThickness-interconnect+1);
    }
    
    translate(0.5*[0,0,height-pcbThickness-interconnect+1]) {
        cube([sigGenSize,2*holeDist,height-pcbThickness-interconnect+1], center=true);
        cube([2*holeDist,sigGenSize,height-pcbThickness-interconnect+1], center=true);
    }
}

// electrode cutout
translate([0,0,-pcbThickness]) {
    for(o=[[1,1,0],[-1,1,0],[1,-1,0],[-1,-1,0]]) {
        translate(holeDist*o)
        cylinder(r=0.5*electrodeSize-holeDist, h=pcbThickness+1);
    }
    
    translate(0.5*[0,0,pcbThickness+1]) {
        cube([electrodeSize,2*holeDist,pcbThickness+1], center=true);
        cube([2*holeDist,electrodeSize,pcbThickness+1], center=true);
    }
}

// screw hole cutout
translate([0,0,-height]) {
    for(o=[[1,1,0],[-1,1,0],[1,-1,0],[-1,-1,0]]) {
        translate(holeDist*o)
        cylinder(d=holeSize, h=height);
    }
}

// top component clearance cutout
translate(-[0,0,pcbThickness+componentSize]) {
    for(o=[[1,1,0],[-1,1,0],[1,-1,0],[-1,-1,0]]) {
        translate((holeDist-componentRadius)*o)
        cylinder(r=componentRadius, h=componentSize+1);
    }
    
    translate(0.5*[0,0,componentSize+1]) {
        cube([2*(holeDist-componentRadius),2*holeDist,componentSize+1], center=true);
        cube([2*holeDist,2*(holeDist-componentRadius),componentSize+1], center=true);
    }
}

oRingDia = 2.0; // 2mm
ch       = 0.9; // height in the gland
ca       = 0.85; // fill quotient
oRingH   = ch*oRingDia;
oRingB   = PI*oRingDia/(4*ch*ca);

// top o-ring cutout
translate([0,0,-pcbThickness-oRingH]) difference() {
    union() {
    for(o=[[1,1,0],[-1,1,0],[1,-1,0],[-1,-1,0]]) {
        translate(holeDist*o)
        cylinder(r=0.5*electrodeSize-holeDist, h=pcbThickness+oRingH+1);
    }
    translate([-holeDist, 0.5*electrodeSize-oRingB, 0])
    cube([2*holeDist, oRingB, oRingH+pcbThickness+1]);
    translate([-holeDist, -0.5*electrodeSize, 0])
    cube([2*holeDist, oRingB, oRingH+pcbThickness+1]);
    translate([-0.5*electrodeSize, -holeDist, 0])
    cube([oRingB, 2*holeDist, oRingH+pcbThickness+1]);
    translate([0.5*electrodeSize-oRingB, -holeDist, 0])
    cube([oRingB, 2*holeDist, oRingH+pcbThickness+1]);
    }
    
    for(o=[[1,1,0],[-1,1,0],[1,-1,0],[-1,-1,0]]) {
        translate(holeDist*o)
        translate([0,0,-0.5])
        cylinder(r=0.5*electrodeSize-holeDist-oRingB, h=pcbThickness+oRingH+2);
    }
    translate([-0.5*electrodeSize+oRingB,-holeDist,-0.5])
    cube([electrodeSize-2*oRingB, holeDist*2, pcbThickness+oRingH+2]);
    translate([-holeDist,-0.5*electrodeSize+oRingB,-0.5])
    cube([holeDist*2, electrodeSize-2*oRingB, pcbThickness+oRingH+2]);
}

// bottom component clearance cutout
translate(-[0,0,pcbThickness+interconnect+1]) {
    for(o=[[1,1,0],[-1,1,0],[1,-1,0],[-1,-1,0]]) {
        translate((holeDist-componentRadius)*o)
        cylinder(r=componentRadius, h=componentSize+1);
    }
    
    translate(0.5*[0,0,componentSize+1]) {
        cube([2*(holeDist-componentRadius),2*holeDist,componentSize+1], center=true);
        cube([2*holeDist,2*(holeDist-componentRadius),componentSize+1], center=true);
    }
}

// header slot
// slot for header
rotate([0,0,90]) translate(-[0,0,pcbThickness+componentSize+1.1*interconnect]) {
translate([-(headerWidth-headerHeight)/2, -headerHeight/2,0])
cube([headerWidth-headerHeight,headerHeight,1.2*interconnect]);
translate([(headerWidth-headerHeight)/2,0,0])
cylinder(r=headerHeight/2, h=1.2*interconnect);
translate([-(headerWidth-headerHeight)/2,0,0])
cylinder(r=headerHeight/2, h=1.2*interconnect);
}

// hub attachment
translate([0,0,hubOffset-height]) {
    for(o=[[0,1,0],[0,-1,0]]) {
        translate(0.5*hubSize*o) {
            rotate(90*o) {
                cylinder(r=hubHole, h=2.2*(holeDist+sideBevel), center=true); 
                rotate([0,0,90+angle]) translate(hubSize*o)
                cylinder(r=hubHole, h=2.2*(holeDist+sideBevel), center=true);
            }
        }
    }
}
// hub cutout
translate(-[0,0,height+hubRadius-hubHeight]) rotate([0,90,0])
cylinder(r=hubRadius, h=hubWidth, center=true);
translate(-[0,0,height-0.5*(hubHeight-hubRadius)])
cube([hubWidth, 2*hubRadius, hubHeight-hubRadius+1], center=true);
}
// domain
translate([-1.1*(electrodeSize+margin+2*topBevel)/2,
            -1.1*(electrodeSize+margin+2*topBevel)/2,
            -(height+split)])
cube([1.1*(electrodeSize+margin+2*topBevel),
      1.1*(electrodeSize+margin+2*topBevel+extension),
      height]);
}






