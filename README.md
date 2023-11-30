# GUS
GUS Image Processing in Arabidopsis thaliana

# Fiji Image Analysis Pipeline

This pipeline analyzes images using Fiji/ImageJ macros to measure particle/area properties and export results.

## Setup

1. Install Fiji and ensure the required plugins are installed (Labkit, ROI Manager)

2. Place the classifier files in your Fiji macros folder 

3. Create the required input and output directories

## Usage

1. Open Fiji and run the macro 

2. Select the input and output directories 

3. Click "OK" to start processing

4. The macro will loop through images in the raw image input folder:

   - Rename the image based on user input genotype  

   - Duplicate the image and save to the renamed image folder

   - Run area measurement analysis and save results

   - Run GUS measurement analysis and save results

   - Save area and GUS images to respective output folders

5. When complete, results files and images will be in the output folders

6. Close all windows when finished

## Requirements

- Fiji 
- Labkit plugin
- ROI Manager plugin

## Results

For each input image, the following files will be generated:

- Renamed TIFF image
- Area TIFF image 
- GUS TIFF image
- Total_Area_Results_genotype.txt 
- Total_GUS_Results_genotype.txt

The text results files contain particle analysis measurements for the corresponding image analysis.

Let me know if any part of the usage or setup needs clarification!
