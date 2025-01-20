# ImageJ Macro for Plant Image Analysis

## Overview
This macro is designed to analyze plant images using ImageJ with the Labkit plugin for segmentation. It processes raw images to measure leaf area and GUS-stained regions, providing outputs in various directories.

## Usage

### Prerequisites
- **ImageJ** with **Labkit** plugin installed
- **Two classifiers** for leaf area and GUS staining

### Steps to Run the Macro
1. **Launch ImageJ** and navigate to `File > New > Macro` to open the macro editor.
2. **Paste** the provided macro code into the editor.
3. **Run** the macro by clicking on the "Run" button or press `Ctrl+R` (Cmd+R on Mac).

### Input Parameters
- **Raw Image Directory**: Where your raw images are stored. (`rawimgdir`)
- **Renamed Image Directory**: Directory to save renamed images. (`reimgdir`)
- **Area Image Directory**: Directory for saving images segmented for leaf area. (`areaimgdir`)
- **GUS Image Directory**: Directory for saving GUS-stained region images. (`gusimgdir`)
- **Area Output Directory**: Directory to save leaf area measurement results. (`areaoutputdir`)
- **GUS Output Directory**: Directory to save GUS staining measurements. (`gusoutputdir`)
- **Area Classifier Path**: Path to the classifier file for leaf area segmentation.
- **GUS Classifier Path**: Path to the classifier file for GUS staining segmentation.

### Macro Flow
- **Image Processing**: 
  - Opens each image from the raw directory.
  - Prompts for genotype input to name the image accordingly.
  - Applies background subtraction.
  - Duplicates and saves the processed image.

- **Segmentation and Analysis for Leaf Area**:
  - Uses Labkit for segmentation.
  - Applies auto-thresholding.
  - Measures and records the leaf area.

- **Segmentation and Analysis for GUS Staining**:
  - Again uses Labkit for segmentation but for GUS-stained areas.
  - Measures and records the GUS-stained area.

- **Output**:
  - Saves segmented images and measurement results in designated directories.

### Notes
- Ensure all paths to directories and classifiers are correct before running.
- The macro assumes images are in a format readable by ImageJ (e.g., TIFF, PNG).
- The script closes all windows to clean up after processing each image.

## Troubleshooting
- If segmentation fails, check the integrity of your classifier files.
- Ensure the ImageJ with Labkit is set up correctly with GPU usage if applicable.

## Feedback
If you encounter any issues or have suggestions for improvements, please open an issue or contribute directly via pull requests.

## License
[Specify the license if applicable, e.g., MIT, GPL, etc.]

---

Enjoy analyzing your plant images with this macro!
