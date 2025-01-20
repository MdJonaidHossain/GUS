// Hi & Welcome MJH

// Input Directories
#@ File(label="Raw Image Directory", style="directory") rawimgdir
#@ File(label="Renamed Image Directory", style="directory") reimgdir
#@ File(label="Area Image Directory", style="directory") areaimgdir
#@ File(label="GUS Image Directory", style="directory") gusimgdir
#@ File(label="Area Output Directory", style="directory") areaoutputdir
#@ File(label="GUS Output directory", style="directory") gusoutputdir
#@ File(label="Area Classifier Path", style="file") areaclassifier
#@ File(label="GUS Classifier Path", style="file") gusclassifier

// OK to proceed
#@ String(visibility=MESSAGE, value="Click OK to Proceed -->") OK

// Get a list of all the raw image files
images = getFileList(rawimgdir);
Separator = File.separator; // Use consistent case for variables

// Loop through each image in the directory
// Loop through each image in the directory
for (i = 0; i < images.length; i++) {
    open(rawimgdir + Separator + images[i]);
    
    // Prompt user for genotype information
    Dialog.create("Genotype Info");
    Dialog.addString("Genotype:", "Value");
    Dialog.show();
    genotype = Dialog.getString();
    
    // Rename the image based on the genotype
    rename(genotype);
    
    // Subtract background to enhance the image
    run("Subtract Background...", "rolling=50 light separate sliding");
    
    // Duplicate the processed image for saving and analysis
    run("Duplicate...", "title=D_" + genotype);
    saveAs("Tiff", reimgdir + Separator + genotype + ".tiff");

    // Segment the image using the Labkit classifier for leaf area
    run("Segment Image With Labkit", "input=Value segmenter_file=" + areaclassifier + " use_gpu=false");
    
    // Apply automatic thresholding for segmentation
    run("Auto Threshold", "method=Default white");
    
    // Set scale for measurements (in pixels)
    run("Set Scale...", "distance=1 known=0 unit=pixel");
    
    // Measure the leaf area
    run("Set Measurements...", "area decimal=5");
    run("Analyze Particles...", "size=20000-Infinity pixel show=Overlay display exclude clear include summarize overlay add composite");
    
    // Get the leaf area from the results table
    saveAs("text", areaoutputdir + Separator + "Total_Area_Results_" + genotype + ".txt");
    close("Total_Area_Results_" + genotype + ".txt");
    
    // Close the Results and Summary tables
    close("Results");
    close("Summary");
    
    // Select the original image and process it for saving
    selectImage(genotype);
    roiManager("select", 0);
    run("Clear Outside");
    roiManager("Delete");
    saveAs("Tiff", areaimgdir + Separator + genotype + ".tiff");
    
    // Segment the image using the Labkit classifier for GUS-stained regions
    run("Segment Image With Labkit", "input=Value segmenter_file=" + gusclassifier + " use_gpu=false");
    
    // Apply automatic thresholding for GUS segmentation
    run("Auto Threshold", "method=Default");
    
    // Set scale for measurements (in pixels) again
    run("Set Scale...", "distance=1 known=0 unit=pixel");
    
    // Invert the image for correct measurement of GUS area
    run("Invert");
    
    // Measure the GUS area
    run("Analyze Particles...", "pixel show=Overlay display clear summarize overlay add composite");
    
    // Save the GUS measurement results
    saveAs("text", gusoutputdir + Separator + "Total_GUS_Results_" + genotype + ".txt");
    close("Total_GUS_Results_" + genotype + ".txt");
    
    // Save the image
    saveAs("Tiff", gusimgdir + Separator + genotype + "_GUS.tiff");

    // Close all open images
    close("*");
    run("Close All");
}

// Close any remaining open windows
run("Close All");

// Notify the user that the analysis is complete
print("Image Analysis is Finished!");
