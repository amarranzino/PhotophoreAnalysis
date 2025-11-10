# PhotophoreAnalysis 

### Author: Ashley Marranzino 
### Last modified: 2025-08-01

## Summary:
This repository contains the data and R code used for the analyses presented in Marranzino, **A.N. and J.F. Webb** (2025). Photophores in Stomiiform Fishes: Morphology, Distribution, and Putative Behavioral Roles. *The Biological Bulletin*. [https://doi.org/10.1086/738399](https://doi.org/10.1086/738399).  <br/>


## Data Description:
R script written for analyzing photophore size and distribution patterns in different species. <br/>

All raw data used for these analyses are based on measurements of photophores derived from images of preserved specimens. Raw images and individual measurments for each specimen are found in the **Photophore Size Data Files**. Measurments were made using ImageJ Software. <br/>

Raw measurment data for all specimnes examined is found in the file **Stomiiform_Photophore_Dat_20250729.csv**. <br/>

The R script used to generate summary statistics and data visualizations is found in the **Photophore_AnalysesandPlots.R** file. <br/>

The R script generates an Excel file containing all summary dataframes, including summaries of values grouped by specimen, species, and region. These data can be found in the **Photo_Data.xls** file. Summary of the fields contained in each dataframe are found below. 

#### **Tab:** Summary_lumped
#### **Summary:** 
A dataframe summarizing data for a single specimen, grouped by region. Export of the dataframe *summary* from the **Photophore_AnalysesandPlots.R** file.
#### **Fields:**
- **species:** species, abbreviated with first letter of Genus and first 3 letters of species epithet. Species are abbreviated as follows: Anig = Astronesthes niger; Bmet = Bathophilus metallicus; Cslo = Chauliodus sloani; Cpli = Chirostomias pliopterus; Ebar = Echiostoma barbatum; Fbou = Flagellostomias boureei; Ifas = Idiacanthus fasciola; Lgla = Leptostomias gladiator; Mbar = Melanostomias bartonbeani; Ncap - Neonsethes capensis; Pmic = Pachystomias microdon; Pgue = Photostomias guernei; Sboa = Stomias boa ferox; Tden = Thysanactis dentex  
- **specimen:** specimen identifier. Formatted as the 4 letter species name (as specified above) followed by the 1 digit specimen number (ex: Anig1)
- **region:** body region in which the data was collected, either "rostral" (just caudal to the anterior insertion of the pectoral fin), "mid" (midway along the rostral-cuadal axis of the trunk rostral to the insterion of the pelvic fin), or "caudal (at the anterior insertion of the anal fin). 
- **id:** the identifying code for the unique region in which data occur. Formatted as the specimen id (as in "specimen" field), underscore, region (where R1 = rostral, R2 = mid, and R3 = caudal). Example: "Anig1_R1"
- **SL:** standard length of specimen, in millimeters
- **n:** number of photophores
- **avg_size:** mean diameter of all photophores in micrometer
- **min_size:** minimum diameter of all photophores in micrometer
- **max_size:** maximum diameter of all photophores in micrometer
- **sd_sizeSL:** standard deviation of the photophore diameter, standardized for fish size (photophore diameter / SL)
- **image_area:** area of analyzed region on specimen, in cm2
- **avg_angle:** mean angle of orientation of all photohores, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **min_angle:** minimum angle of orientation of all photohores, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **max_angle:** maximum angle of orientation of all photohores, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **sd_angle:** standard deviation of angle of orientation of photophores, in detrees
- **photo_area_mm2_mean:** average area of photophore (calculated as pie*(photophore diameter/2)^2), in mm2
- **photo_area_mm2_tot:** sum of all areas of photophores (calculated as pie*(photophore diameter/2)^2), in mm2
- **photo_area_mmSL:** the area of a photophore standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **photo_area_mmSL_tot:** the sum of the areas of all photophores standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **density:** the density of photophores. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2

#### **Tab:** Photo_sum
#### **Summary:** 
A dataframe summarizing data for a single specimen, grouped  by region and type of photohpore. Export of the dataframe *photo_summary* in the **Photophore_AnalysesandPlots.R** file. 
#### **Fields:**
- **species:** species, abbreviated with first letter of Genus and first 3 letters of species epithet. Species are abbreviated as follows: Anig = Astronesthes niger; Bmet = Bathophilus metallicus; Cslo = Chauliodus sloani; Cpli = Chirostomias pliopterus; Ebar = Echiostoma barbatum; Fbou = Flagellostomias boureei; Ifas = Idiacanthus fasciola; Lgla = Leptostomias gladiator; Mbar = Melanostomias bartonbeani; Ncap - Neonsethes capensis; Pmic = Pachystomias microdon; Pgue = Photostomias guernei; Sboa = Stomias boa ferox; Tden = Thysanactis dentex  
- **specimen:** specimen identifier. Formatted as the 4 letter species name (as specified above) followed by the 1 digit specimen number (ex: Anig1)
- **region:** body region in which the data was collected, either "rostral" (just caudal to the anterior insertion of the pectoral fin), "mid" (midway along the rostral-cuadal axis of the trunk rostral to the insterion of the pelvic fin), or "caudal (at the anterior insertion of the anal fin). 
- **id:** the identifying code for the unique region in which data occur. Formatted as the specimen id (as in "specimen" field), underscore, region (where R1 = rostral, R2 = mid, and R3 = caudal). Example: "Anig1_R1"
- **typereg:** denotes the type of photophore ("serial" or "minute") and which region the photophore is located ("rostral", "mid", or "caudal"). Formatted as "region.type" (example: "mid.serial")
- **type:** photophore type, either "serial" or "minute"
- **SL:** standard length of specimen, in millimeters
- **n:** number of photophores
- **avg_size:** mean diameter of all photophores of a given type within a given region, in micrometer
- **min_size:** minimum diameter of all photophores of a given type within a given region, in micrometer
- **max_size:** maximum diameter of all photophores of a given type within a given region, in micrometer
- **sd_size:** standard deviation of diameters of photophores of a given type within a given region
- **avg_sizeSL:** mean diameter of all photophores (in micrometers), standardized for fish size. Calculated by dividing photophore diameter by SL. Reported as micrometers/ mm.
- **sd_sizeSL:** standard deviation of the photophore diameter, standardized for fish size (photophore diameter / SL)
- **image_area:** area of analyzed region on specimen, in cm2
- **avg_angle:** mean angle of orientation of photophores of a given type within a given region, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **min_angle:** minimum angle of orientation of photophores of a given type within a given region, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **max_angle:** maximum angle of orientation of photophores of a given type within a given region, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **sd_angle:** standard deviation of angle of orientation of photophores of a given type within a given region, in degrees
- **photo_area_mm2_mean:** average area of photophores of a given type within a given region (calculated as pie*(photophore diameter/2)^2), in mm2
- **photo_area_mm2_tot:** sum of all areas of photophores of a given type within a given region (calculated as pie*(photophore diameter/2)^2), in mm2
- **photo_area_mmSL:** the mean area of photophores of a given type within a given region, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **photo_area_mmSL_tot:** the sum of the areas of photophores of a given type within a given region standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **density:** the density of photophores of a given type within a given region. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2

#### **Tab:** Spp_summary
#### **Summary:** 
A dataframe summarizing data for each species, grouped  by region. Export of the dataframe *spp_sum* in the **Photophore_AnalysesandPlots.R** file. 
#### **Fields:**
- **species:** species, abbreviated with first letter of Genus and first 3 letters of species epithet. Species are abbreviated as follows: Anig = Astronesthes niger; Bmet = Bathophilus metallicus; Cslo = Chauliodus sloani; Cpli = Chirostomias pliopterus; Ebar = Echiostoma barbatum; Fbou = Flagellostomias boureei; Ifas = Idiacanthus fasciola; Lgla = Leptostomias gladiator; Mbar = Melanostomias bartonbeani; Ncap - Neonsethes capensis; Pmic = Pachystomias microdon; Pgue = Photostomias guernei; Sboa = Stomias boa ferox; Tden = Thysanactis dentex  
- **region:** body region in which the data was collected, either "rostral" (just caudal to the anterior insertion of the pectoral fin), "mid" (midway along the rostral-cuadal axis of the trunk rostral to the insterion of the pelvic fin), or "caudal (at the anterior insertion of the anal fin). 
- **n:** number of specimens analyzed for each species
- **avg_SL:** average size (standard length) of sepecimens for each species, in millimeters
- **min_SL:** minimum size (standard length) of sepecimens for each species, in millimeters
- **max_SL:** maximum size (standard length) of sepecimens for each species, in millimeters
- **sd_SL:** standard deviation of the size (standard length) of specimens for each species 
- **avg_size:** mean diameter of photophores within a given region for a given species, in micrometer
- **min_size:** minimum diameter of photophores within a given region for a given species, in micrometer
- **max_size:** maximum diameter of photophores within a given region for a given species, in micrometer
- **sd_size:** standard deviation of photophores within a given region for a given species
- **avg_angle:** mean angle of orientation of photophores within a given region for a given species, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **min_angle:** minimum angle of orientation of photophores within a given region for a given species, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **max_angle:** maximum angle of orientation of photophores within a given region for a given species, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **sd_angle:** standard deviation of angle of orientation of photophores within a given region for a given species, in degrees
- **avg_density:** the average density of photophores within a given region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **min_density:** the minimum density of photophores within a given region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **max_density:** the maximum density of photophores within a given region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **sd_density:** the standard deviation of density of photophores within a given region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **avg_photo:** the mean number of photophores within a given region for a given species
- **min_photo:** the minimum number of photophores within a given region for a given species
- **max_photo:** the maximum number of photophores within a given region for a given species
- **sd_photo:** the standard deviation of number of photophores within a given region for a given species
- **avg_photo_area_mm2:** the mean area of photophores within a given region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **min_photo_area_mm2:** the minimum area of photophores within a given region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **max_photo_area_mm2:** the maximum area of photophores within a given region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **sd_photo_area_mm2:** the standard deviation of the area of photophores within a given region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **avg_photo_area_mm2_tot:** the mean of total area (sum of the areas of photophores within a given region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **min_photo_area_mm2_tot:** the minimum of total area (sum of the areas of photophores within a given region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **max_photo_area_mm2_tot:** the maximum of total area (sum of the areas of photophores within a given region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **sd_photo_area_mm2_tot:** the standard deviation of total areas (sum of the areas of photophores within a given region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)

#### **Tab:** PhotoSpp_summary
#### **Summary:** 
A dataframe summarizing data for each species, grouped  by region and photophore type. Export of the dataframe *photo_spp_sum* in the **Photophore_AnalysesandPlots.R** file. 
#### **Fields:**
- **species:** species, abbreviated with first letter of Genus and first 3 letters of species epithet. Species are abbreviated as follows: Anig = Astronesthes niger; Bmet = Bathophilus metallicus; Cslo = Chauliodus sloani; Cpli = Chirostomias pliopterus; Ebar = Echiostoma barbatum; Fbou = Flagellostomias boureei; Ifas = Idiacanthus fasciola; Lgla = Leptostomias gladiator; Mbar = Melanostomias bartonbeani; Ncap - Neonsethes capensis; Pmic = Pachystomias microdon; Pgue = Photostomias guernei; Sboa = Stomias boa ferox; Tden = Thysanactis dentex  
- **typereg:** denotes the type of photophore ("serial" or "minute") and which region the photophore is located ("rostral", "mid", or "caudal"). Formatted as "region.type" (example: "mid.serial")
- **region:** body region in which the data was collected, either "rostral" (just caudal to the anterior insertion of the pectoral fin), "mid" (midway along the rostral-cuadal axis of the trunk rostral to the insterion of the pelvic fin), or "caudal (at the anterior insertion of the anal fin). 
- **type:** photophore type, either "serial" or "minute"
- **avg_SL:** average size (standard length) of sepecimens for each species, in millimeters
- **min_SL:** minimum size (standard length) of sepecimens for each species, in millimeters
- **max_SL:** maximum size (standard length) of sepecimens for each species, in millimeters
- **sd_SL:** standard deviation of the size (standard length) of specimens for each species 
- **n:** number of specimens analyzed for each species
- **avg_size:** mean diameter of photophores for a given type, within a given region, for a given species, in micrometer
- **min_size:** minimum diameter of photophores for a given type, within a given region, for a given species, in micrometer
- **max_size:** maximum diameter of photophores for a given type, within a given region, for a given species, in micrometer
- **sd_size:** standard deviation of photophores for a given type, within a given region, for a given species
- **avg_angle:** mean angle of orientation of photophores for a given type, within a given region, for a given species, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **min_angle:** minimum angle of orientation of photophores for a given type, within a given region, for a given species, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **max_angle:** maximum angle of orientation of photophores for a given type, within a given region, for a given species, in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **sd_angle:** standard deviation of angle of orientation of photophores for a given type, within a given region, for a given species, in degrees
- **avg_density:** the average density of photophores for a given type, within a given region, for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **min_density:** the minimum density of photophores for a given type, within a given region, for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **max_density:** the maximum density of photophores for a given type, within a given region, for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **sd_density:** the standard deviation of density of photophores for a given type, within a given region, for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **avg_photo:** the mean number of photophores for a given type, within a given region, for a given species
- **min_photo:** the minimum number of photophores for a given type, within a given region, for a given species
- **max_photo:** the maximum number of photophores within a given region for a given species
- **sd_photo:** the standard deviation of number of photophores for a given type, within a given region, for a given species
- **avg_photo_area_mm2:** the mean area of photophores for a given type, within a given region, for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **min_photo_area_mm2:** the minimum area of photophores within a given region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **max_photo_area_mm2:** the maximum area of photophores for a given type, within a given region, for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **sd_photo_area_mm2:** the standard deviation of the area of photophores for a given type, within a given region, for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **avg_photo_area_mm2_tot:** the mean of total area (sum of the areas of photophores for a given type, within a given region, for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **min_photo_area_mm2_tot:** the minimum of total area (sum of the areas of photophores for a given type, within a given region, for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **max_photo_area_mm2_tot:** the maximum of total area (sum of the areas of photophores for a given type, within a given region, for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **sd_photo_area_mm2_tot:** the standard deviation of total areas (sum of the areas of photophores for a given type, within a given region, for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)

#### **Tab:** rostral_spp_type_summary
#### **Summary:** 
A dataframe summarizing data for the rostral region, grouping data by species and type of photophore. Export of the dataframe *rostral_spp_sum* in the **Photophore_AnalysesandPlots.R** file. 
#### **Fields:**
-  **species:** species, abbreviated with first letter of Genus and first 3 letters of species epithet. Species are abbreviated as follows: Pgue = Photostomias guernei; Sboa = Stomias boa ferox
- **type:** photophore type, either "serial" or "minute"
- **n:** number of specimens analyzed for each species within the rostral region
- **avg_size:** mean diameter of photophores of a given type within the rostral region for a given species. Reported in micrometers
- **sd_size:** standard deviation diameters of photophores of a given type within the rostral region for a given species. Reported in micrometers
- **avg_angle:** mean angle of orientation ofphotophores of a given type within the rostral region for a given species. Reported in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **sd_angle:** standard deviation of angle of orientation of pphotophores of a given type within the rostral region for a given species. Reported in degrees
- **avg_density:** the average density of photophores of a given type within the rostral region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **sd_density:** the standard deviation of density of photophores of a given type within the rostral region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **avg_photo:** the mean number of photophores of a given type within the rostral region for a given species.
- **sd_photo:** the standard deviation of number of photophores of a given type within the rostral region for a given species.
- **avg_photo_area_mm2:** the mean area of photophores of a given type within the rostral region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **sd_photo_area_mm2:** the standard deviation of the area of photophores of a given type within the rostral region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **avg_photo_area_mm2_tot:** the mean of total area (sum of the areas of photophores of a given type within the rostral region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **sd_photo_area_mm2_tot:** the standard deviation of total areas (sum of the areas of photophores of a given type within the rostral region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)

#### **Tab:** mid_spp_type_summary
#### **Summary:** 
A dataframe summarizing data for the mid region, grouping data by species and type of photophore. Export of the dataframe *mid_spp_sum* in the **Photophore_AnalysesandPlots.R** file. 
#### **Fields:**
-  **species:** species, abbreviated with first letter of Genus and first 3 letters of species epithet. Species are abbreviated as follows: Anig = Astronesthes niger; Bmet = Bathophilus metallicus; Cslo = Chauliodus sloani; Cpli = Chirostomias pliopterus; Ebar = Echiostoma barbatum; Fbou = Flagellostomias boureei; Ifas = Idiacanthus fasciola; Lgla = Leptostomias gladiator; Mbar = Melanostomias bartonbeani; Ncap - Neonsethes capensis; Pmic = Pachystomias microdon; Pgue = Photostomias guernei; Sboa = Stomias boa ferox; Tden = Thysanactis dentex  
- **type:** photophore type, either "serial" or "minute"
- **n:** number of specimens analyzed for each species within the mid region
- **avg_size:** mean diameter of photophores of a given type within the mid region for a given species. Reported in micrometers
- **sd_size:** standard deviation diameters of photophores of a given type within the mid region for a given species. Reported in micrometers
- **avg_angle:** mean angle of orientation ofphotophores of a given type within the mid region for a given species. Reported in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **sd_angle:** standard deviation of angle of orientation of pphotophores of a given type within the mid region for a given species. Reported in degrees
- **avg_density:** the average density of photophores of a given type within the mid region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **sd_density:** the standard deviation of density of photophores of a given type within the mid region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **avg_photo:** the mean number of photophores of a given type within the mid region for a given species.
- **sd_photo:** the standard deviation of number of photophores of a given type within the mid region for a given species.
- **avg_photo_area_mm2:** the mean area of photophores of a given type within the mid region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **sd_photo_area_mm2:** the standard deviation of the area of photophores of a given type within the mid region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **avg_photo_area_mm2_tot:** the mean of total area (sum of the areas of photophores of a given type within the mid region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **sd_photo_area_mm2_tot:** the standard deviation of total areas (sum of the areas of photophores of a given type within the mid region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)

#### **Tab:** caudal_spp_type_summary
#### **Summary:** 
A dataframe summarizing data for the caudal region, grouping data by species and type of photophore. Export of the dataframe *caudal_spp_sum* in the **Photophore_AnalysesandPlots.R** file. 
#### **Fields:**
-  **species:** species, abbreviated with first letter of Genus and first 3 letters of species epithet. Species are abbreviated as follows: Fbou = Flagellostomias boureei; Ifas = Idiacanthus fasciola; Mbar = Melanostomias bartonbeani; Pmic = Pachystomias microdon; Pgue = Photostomias guernei

- **type:** photophore type, either "serial" or "minute"
- **n:** number of specimens analyzed for each species within the caudal region
- **avg_size:** mean diameter of photophores of a given type within the caudal region for a given species. Reported in micrometers
- **sd_size:** standard deviation diameters of photophores of a given type within the caudal region for a given species. Reported in micrometers
- **avg_angle:** mean angle of orientation ofphotophores of a given type within the caudal region for a given species. Reported in degrees (0° = caudal, 90° = dorsal, 180° = rostral, and -90° = ventral)
- **sd_angle:** standard deviation of angle of orientation of pphotophores of a given type within the caudal region for a given species. Reported in degrees
- **avg_density:** the average density of photophores of a given type within the caudal region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **sd_density:** the standard deviation of density of photophores of a given type within the caudal region for a given species. Calculated as the number of photophores (n) divided by imaged_area. Reported as number of photophores/cm2
- **avg_photo:** the mean number of photophores of a given type within the caudal region for a given species.
- **sd_photo:** the standard deviation of number of photophores of a given type within the caudal region for a given species.
- **avg_photo_area_mm2:** the mean area of photophores of a given type within the caudal region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **sd_photo_area_mm2:** the standard deviation of the area of photophores of a given type within the caudal region for a given species. Calculated as pie*(photophore diameter/2)^2. Reported in mm2
- **avg_photo_area_mm2_tot:** the mean of total area (sum of the areas of photophores of a given type within the caudal region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
- **sd_photo_area_mm2_tot:** the standard deviation of total areas (sum of the areas of photophores of a given type within the caudal region for a given species) occupied by photophores, standardized for fish size. Calculated by dividing photophore area by the standard length of the specimen. Reported as mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
