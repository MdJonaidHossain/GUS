// Hi & Welcome MJH
#@ String(label="Hii & Welcome, Please Choose the Input Directories") MJH

// Input Directories
#@ File(label="Raw Image Directory", style="directory") rawimgdir
#@ File(label="Renamed Image Directory", style="directory") reimgdir
#@ File(label="Area Image Directory", style="directory") areaimgdir
#@ File(label="GUS Image Directory", style="directory") gusimgdir
#@ File(label="Output directory", style="directory") outputdir

// OK to proceed
#@ String(visibility=MESSAGE, value="Click OK to Proceed -->") OK

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
    
    run("Calculate Probability Map With Labkit", "input=Value segmenter_file=/Applications/Fiji.app/macros/Area.classifier use_gpu=false");
    run("Convert to Mask", "calculate only black list create");
    run("Median...", "radius=20 slice");
    
    selectImage("probability map for " + genotype + ".tiff"); run("Close");
    selectImage("MASK_probability map for " + genotype + ".tiff");
    run("Invert", "slice");
    
    run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display invert scientific add nan redirect=" + genotype + " decimal=10");
    
    run("Analyze Particles...", "pixel show=Nothing display exclude clear include summarize overlay add composite slice");
    
    saveAs("text", outputdir + Separator + "Total_Area_Results_" + genotype + ".txt"); close();
    
    selectImage(genotype);
    roiManager("select", 0);
    run("Clear Outside");
    roiManager("deselect");
    saveAs("Tiff", areaimgdir + Separator + genotype + ".tiff");
    
    run("Calculate Probability Map With Labkit", "input=Value segmenter_file=/Applications/Fiji.app/macros/GUS.classifier use_gpu=false");
    run("Convert to Mask", "calculate only black list create");
    selectImage("MASK_probability map for " + genotype + ".tiff");
    run("Invert", "slice");
    
    run("Analyze Particles...", "pixel show=Nothing display exclude clear include summarize overlay add composite slice");
    
    saveAs("text", outputdir + Separator + "Total_GUS_Results_" + genotype + ".txt"); close();
    
    saveAs("Tiff", gusimgdir + Separator + genotype + ".tiff");
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
