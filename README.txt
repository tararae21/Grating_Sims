READ ME

Initial Commit:

INTRO:

This is me learning how to use Github and repositories, so bear with me. Initial version of code posted 3/11/22. Be careful running entire GratingSimulations.m at once, especially with high N values, because it will take Forever. If you have any questions/sugguestions let me know, and I will do my best to answer or incorporate them.

N values:

N is calculated by dividing the period of the grating by two, and multiplying that by the number of lines you want. The Carpientier et. al. paper that we have been referencing fabricated gratings with a length and width of 0.5 cm and a period of 120 um (line width of 60 um for 80 fringes total (dark and light)). N for this would be 4800 (approximately the length of the grating). I've only run radial mode simulations for N=1800, and am living in fear for when I need to run for the higher value. Currently, I'm going to be testing scaling, to see if we can save some computation time. I just don't want to lose resolution when we blow it back up.

CODE INCLUDED:

GratingSimulations: Giant catch all program which generates fork holograms using two different methods, diffraction simulations via FFT of the fork holograms produced, generation of spiral phase plate/vortex retarder phase profiles. If you'd prefer me to include individual programs for each section of code just let me know.

LG_Visualization: Displays what the spatial, intensity, and phase profile of LG beams should look like.

laser_cmap: custom colormap mimicking red laser light. Just included to be fancy shmancy,

Update 5/11/22: 

Fork_Hologram_Generator.m: Matlab file used to generate Masks used for printing! *USE THIS INSTEAD
OF GRATINGSIMULATIONS.M* Make sure you edit filenames and display options for files you want to save!

DFX Files: all DFX files created for the project, even though only the inverse ones were used for 3D modeling. 
	   The files all have a border as they were meant for 3D printing.

Hologram Masks with Borders: All holograms (inverse and not) made for the project