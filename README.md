# canoe-hull-design
octave/matlab software to create and model the hull of a canoe

Octave/matlab code to allow one to tweek the shape of a canoe hull, and calculate useful quantities such as prismatic coefficient, draft, primary and secondary stability, wetted area.   The crosssection forms, called molds, are specified with polynomials, and drawn on a 1 inch grid to aid in creating molds for a cedar-strip canoe.   The DXF of the molds is also generated for those with CNC capability.

Details like Center of Gravity, length, beam, hull shape  and load may be modified to calculate the effect on stability.

Usage; place all .m files in one directory.   Edit the hull.m file to suit your canoe requirements.  In linux, execute octave and issue the command run 'hull.m'.
Design info will be output in octave, as well as data graphs and .jpg files with the resulting analysis data.

Warning:  All calculations are numerical, and are only approximate.   This code has only been tested on Ubuntu using octave.
