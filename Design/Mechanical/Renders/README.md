#Renders
In this folder, you find all the stl files you need for 3D printing the RISA case. You could also download the OpenSCAD source file in the design folder if you want to edit the model or render our the files yourself, but since the rendering takes a long time (about half a hour for me) I have provided the rendered out files here too.

#The files
## Files to 3D-print
If you just want to build this project for yourself, you can simply download these files and hit print.

### RISA_Case_O_ring_USB_Space_top_fixed.stl
This is the top of the case, or the electrode holder part. The mesh was repaired from the source file using [Microsofts 3D printing cloud services](https://tools3d.azurewebsites.net/) to make it suitable for 3D printing.

### RISA_Case_O_ring_USB_Space_body.stl
This is the main body of the case. The mesh isn't watertight, as I wasn't able to repair it automatically. The slicer I use (Slic3r) didn't have any problems with it though.

## Additional files
###RISA_Case_O_ring_USB_Space_full.stl
This is the full case, in case you need it. It isn't really 3D-printable on entry-level 3D printers, but perhaps you want to do something fancier.

###RISA_Case_O_ring_USB_Space_top.stl
This is the top of the case, or the electrode holder part, as it rendered out of OpenSCAD. Unfortunately, the mesh isn't quite watertight, which can lead slicers to have problems with it. I have included it for completeness.