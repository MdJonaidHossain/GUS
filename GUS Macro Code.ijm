// Hi & Welcome MJH
#@ String(label="Hii & Welcome, Please Choose the Input Directories") MJH

// Input Directories
#@ File(label="Raw Image Directory", style="directory") rawimgdir
#@ File(label="Renamed Image Directory", style="directory") reimgdir
#@ File(label="Area Image Directory", style="directory") areaimgdir
#@ File(label="GUS Image Directory", style="directory") gusimgdir
#@ File(label="Output directory", style="directory") outputdir
#@ File(label="Plot Profile directory", style="directory") plotoutputdir

// Set The Pixel Per Inch (PPI) of the Image
#@ String (label = "What is the Pixel Per Inch (PPI) of the Image ?", value = "300") PPI

// OK to proceed
#@ String(visibility=MESSAGE, value="Click OK to ProPlotceed -->") OK

// Get a list of all the raw image files
images = getFileList(rawimgdir);
Separator = File.separator;

// Loop through each image in the directory
for (i = 0; i < images.length; i++) {
    open(rawimgdir + Separator + images[i]);

    Dialog.create("Genotype Info");
    Dialog.addString("Genotype:", "Value");
    Dialog.show();
    genotype = Dialog.getString();
    
    rename(genotype);
    run("Duplicate...", "title=D_" + genotype);
    saveAs("Tiff", reimgdir + Separator + genotype + ".tiff");
    
    run("Segment Image With Labkit", "input=Value segmenter_file=/Applications/Fiji.app/macros/Area.classifier use_gpu=false");
    run("Auto Threshold", "method=Default");
    
    run("Set Scale...", "distance=" + PPI + " known=1 unit=inch");
    
    run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display invert scientific add nan redirect=" + genotype + " decimal=10");
    
    run("Analyze Particles...", "size=1000-Infinity pixel show=Overlay display exclude clear include summarize overlay add composite");
    
    saveAs("text", outputdir + Separator + "Total_Area_Results_" + genotype + ".txt"); close();
    
    selectImage(genotype);
    roiManager("select", 0);
    run("Clear Outside");
    roiManager("deselect");
    saveAs("Tiff", areaimgdir + Separator + genotype + ".tiff");
    
    run("Calculate Probability Map With Labkit", "input=Value segmenter_file=/Applications/Fiji.app/macros/GUS.classifier use_gpu=false");
    run("Delete Slice", "delete=channel");
    run("Convert to Mask");
    
    run("Analyze Particles...", "pixel show=Overlay display exclude clear include summarize overlay add composite slice");
    
    saveAs("text", outputdir + Separator + "Total_GUS_Results_" + genotype + ".txt");
    
    saveAs("Tiff", gusimgdir + Separator + genotype + "_GUS.tiff");
    
    makeRectangle(0, 0, getWidth(), getHeight());
    run("Plot Profile");
    Plot.showValues();
    
	saveAs("Results", plotoutputdir + File.separator + genotype + "_plot_profile_data.txt");
       
    close("ROI Manager"); run("Close");
    close("Results"); run("Close");
    run("Close All");
    close("Total*.txt");
    close("*");
}

// Close all windows
run("Close All");

// Print message when processing is done
print("Image Analysis is Finished! Now Chillllllllll");
