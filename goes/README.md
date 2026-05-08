Jun 3, 2016, 3:44 PM

Two filenames:

2011_12_02_2145_ch4subset_Karen.nc
goes12_4_2012_026_1845_subset_1d.nc

But the contents are similar. 36 latitudes and 41 longitudes and not time. Because the files don't have a time-stamp inside them, it is not possible to open in Grads, or CDO, etc...
The only information about the time is in the file name. Hence, it seem you have 1 file per event. 

Is this just time zero?
I thought you wanted to make a figure of the time evolution, during an event...


Jun 3, 2016, 4:24 PM

I opened all files in Matlab and I can easily calculate their average... But while doing that, I notice that 4 files have values which seem to be multiplied by 100. This are:

2011_09_01_1845_ch4subset_Karen.nc
2011_09_06_2015_ch4subset_Karen.nc
2011_09_18_2115_ch4subset_Karen.nc
2011_09_23_1945_ch4subset_Karen.nc

The maximum and minimum values in each of these 4 files are about 30000 and 19800, while for the other files the values are around 300 and 198. 

I correct this files by dividing them by 100. I generated a figure for each one which go attached. 

I also noticed that for the "goes12" images, there is a vertical line in the images, at about 60.7W... besides, these images don't reach the same span in latitude as the other ones (they are filled with NaN).

Let me know what I should do...
