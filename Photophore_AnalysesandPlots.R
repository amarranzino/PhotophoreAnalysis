### SET UP WORKING DIRECTORY ####
  setwd("C:/Users/Ashley/Documents/URI/Webb Lab/Photophore MS/R")
  #if on work pc
   #setwd("C:/Users/ashley.marranzino/Documents/Photophore_MS_Ashley/R")

### LOAD PACKAGES ####

if(!require('ggplot2'))install.packages('ggplot2'); library('ggplot2')
if(!require('tidyverse'))install.packages('tidyverse'); library('tidyverse') 
if(!require('broom'))install.packages('broom'); library('broom')
if(!require('xlsx'))install.packages('xlsx'); library('xlsx')
if(!require("lemon"))install.packages("lemon"); library("lemon")
if(!require("ggpubr"))install.packages("ggpubr"); library("ggpubr")
if(!require("gridExtra"))install.packages("gridExtra"); library("gridExtra")
if(!require("patchwork"))install.packages("patchwork"); library("patchwork")
if(!require("RColorBrewer"))install.packages("RColorBrewer"); library("RColorBrewer")

### READ IN DATA ####

photo<-read.csv("Stomiiform_Photophore_Dat_20250729.csv", col.names = (c("species", "specimen","id", "region", "catalog", "SL", "image_area", "x","y","direction", "diameter", "angle", "type", "diameter_SL")))%>%
  mutate(species = as.factor(species), 
         specimen = as.factor(specimen), 
         id = as.factor(paste0(specimen,"_", region)), 
         region = as.factor(region), 
         catalog = as.factor(catalog),
         direction = as.factor(direction), 
         type = as.factor(type), 
         diameter = diameter*1000,## change units for diameter from mm(normal in dataframe) to micron by multiplying by 1000 
         diameter_SL = diameter/SL, #diameter of photophores (in micrometer) standardized by dividing by fish standard length (in mm)
         image_area = image_area/100, ## change units for image_area from mm2 to cm2 by dividing by 100,
         photo_area_mm2 = (pi* (diameter/2)^2)/10000, #calculate the area of each photophore, report as mm2 (converted from micrometer2)
         photo_area_mmSL = photo_area_mm2/SL,#calculate standardized photophore area (mm2/mmSL) by dividing photophore area (mm2) by fish standard length (mm)
         species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic")), #rearrange order of the species to show up in proper phylogentic order
         type=fct_relevel(type,c("serial", "minute")), #reorder the factor levels for photophore type
         region = recode (region, R1 = "rostral", R2 = "mid", R3 = "caudal"))%>%  #rename the regions to reflect body placement
    unite("typereg", c(region,type), remove= F, sep = ".")


### MAKE SUMMARY DATAFRAMES ####
  # make a summary dataframe summarizing data for a single specimen, grouped by region (df name = summary)###
summary <- photo%>%
  dplyr::group_by(id)%>% ##ID is unique for each region on a specimen
  summarize(SL = mean(SL), 
            n = n(), #n will report number of photophores
            avg_size = mean(diameter), #in micrometer
            min_size = min(diameter),  #in micrometer
            max_size = max(diameter), #in micrometer
            sd_size = sd(diameter), 
            image_area = mean(image_area), #in cm2
            avg_angle = mean(angle, na.rm=T), #in degrees
            min_angle = min(angle), #in degrees
            max_angle = max(angle), #in degrees
            sd_angle = sd(angle), 
            photo_area_mm2_mean = mean(photo_area_mm2), #average area of photophores, in mm2
            photo_area_mm2_tot = sum(photo_area_mm2), #sum of area of photophores in mm2
            photo_area_mmSL = mean(photo_area_mmSL), # in mm2/mm - average area of photophores (in mm2), standardized by fish SL (in mm)
            photo_area_mmSL_tot = sum(photo_area_mmSL))%>% #in mm2/mm - sum of area of all photophores (mm2) standardized by fish SL (mm)
  mutate(density = n/image_area)%>% #calculate density (# of photophores/cm2)
  as.data.frame()%>%
  mutate(species = as.factor(str_sub(id,0,-5)), 
         specimen = as.factor (str_sub(id, 0, -4)), 
         region = as.factor(str_sub(id,-2)),  #remake the species and region cols that were lost during summarize function    
         region = recode (region, R1 = "rostral", R2 = "mid", R3 = "caudal"), #rename regions to reflect body placement
         species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic")))%>% #reorder species to place them in proper phylogenetic order
  relocate(c(species, specimen, region), .before= id )
 
 ## save to an excel file - starts the .xls file and subsequent data is saved as new tabs
  write.xlsx(summary, file = "Photo_Data.xls", sheetName = "summary_lumped", row.names = F, append = F)    
  
  
### make a summary dataframe summarizing data in the master dataframe (df = photo) for a single specimen, grouped by region and type of photophore (df name = photo_summary) ###
photo_summary <- photo%>%
  dplyr:: group_by(id, type)%>%
  summarize( SL = mean(SL), #in mm
             n = n(), #number of photophores
             avg_size = mean(diameter), #Average size of photophores (diameter) in micrometers
             min_size = min(diameter), #Minimum size of photophores (diameter) in micrometers
             max_size = max(diameter), #Maximum size of photohpores (diameter) in micrometers
             sd_size = sd(diameter), #Standard deviation of photophore diameter
             avg_sizeSL= mean(diameter_SL), #Average size of specimen (standard length, in mm)
             sd_sizeSL= sd(diameter_SL), #Standard deviation of specimen SL 
             image_area = mean(image_area), #area imaged (cm2)
             avg_angle = mean(angle, na.rm = T), #Average angle of orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
             min_angle = min(angle), #minimum angle of orientation(degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
             max_angle = max(angle), #maximum angle of orientation(degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
             sd_angle = sd(angle), #standard deviation of angles of orientation
             photo_area_mm2_mean = mean(photo_area_mm2), #average photophore area (mm2)
             photo_area_mm2_tot = sum(photo_area_mm2), #sum of photophore areas (mm2)
             photo_area_mmSL_mean = mean(photo_area_mmSL), #avearge photophore area standardized for fish SL (mm2/mm)
             photo_area_mmSL_tot = sum(photo_area_mmSL))%>% #sum of average photophore area stantardized for fish SL (mm2/mm)
  mutate(density = n/image_area)%>% #calculate density - number of photophores/cm2
  as.data.frame()%>%
  mutate(species = as.factor(str_sub(id,0,-5)), 
         specimen = as.factor (str_sub(id, 0, -4)), 
         region = as.factor(str_sub(id,-2)),#remake the species and region cols that were lost during summarize function
         region = recode (region, R1 = "rostral", R2 = "mid", R3 = "caudal"), #rename regions to reflect body placement
         species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic")))%>% ##reorder species to place in appropriate phylogenetic arrangement
  unite("typereg", c(region,type), remove= F, sep = ".")%>%
  relocate(c(species, specimen, region), .before= id )
  
  # save to the excel file in a new tab
  write.xlsx(photo_summary, file = "Photo_Data.xls", sheetName = "Photo_sum", row.names = F, append = T)

### make a summary dataframe summarizing data in the master dataframe (df = photo) for each species, grouped by region (df = spp_sum) ###
spp_sum <- photo%>%
  dplyr::group_by(species, region)%>%
  summarize (n = n_distinct(specimen), #n = number of specimens for each species
             avg_SL = mean(SL), #mean standard length of specimen (mm)
             min_SL = min(SL), #minimum standard length of specimen (mm)
             max_SL = max(SL), #maximum standard length of specimen (mm)
             sd_SL = sd(SL), #standard deviation of specimen standard lengths
             avg_size = mean(diameter), #average size of photophores (diameter, micrometer)
             min_size = min(diameter),  #minimum size of photophores (diameter, micrometer)
             max_size = max(diameter),  #maximum  size of photophores (diameter, micrometer)
             sd_size = sd(diameter), #standard deviation of photophore size (diameter)
             avg_angle = mean(angle, na.rm=T), #avearage angle of photophore orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
             min_angle = min(angle,na.rm=T), #minimum angle of photophore orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
             max_angle = max(angle, na.rm = T), #maximum angle of photophore orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
             sd_angle = sd(angle, na.rm=T))%>% #standard deviation of photophore orientations
  as.data.frame()

#calculate summary statistics for density and photophore area from the summary dataframe and then merge those with the spp_sum dataframe
  temp<- summary%>%   
    group_by(species, region)%>%
    summarize (avg_density = mean(density), #average density of photophores (#/cm2)
               min_density = min(density), #minimum density of photophores (#/cm2)
               max_density = max(density), #maximum density of photophores (#/cm2)
               sd_density = sd(density), #standard deviation of photophore density
             avg_photo = mean(n), #average number of photophores
             min_photo = min(n), #minimum number of photophores
             max_photo = max(n), #maximum number of photophores
             sd_photo = sd(n), #standard deviation of number of photophores
             avg_photo_area_mm2_tot = mean(photo_area_mm2_tot), #average total area of photophores (mm2)
             min_photo_area_mm2_tot = min (photo_area_mm2_tot), #minimum total area of photophores (mm2)
             max_photo_area_mm2_tot = max(photo_area_mm2_tot), #maximum total area of photophores (mm2)
             sd_photo_area_mm2 = sd(photo_area_mm2_tot), #standard deviation of the total area of photophores
             avg_photo_area_mmSL_tot = mean(photo_area_mmSL_tot), #average total area of photophores (mm2) standardized by fish body length (SL, mm)
             min_photo_aream_mmSL_tot = min(photo_area_mmSL_tot), #minimum total area of photophores (mm2) standardized by fish body length (SL, mm)
             max_photo_area_mmSL_tot = max (photo_area_mmSL_tot), #maximum total area of photophores (mm2) standardized by fish body length (SL, mm)
             sd_area_mmSL_tot = sd(photo_area_mmSL_tot))%>% #standard deviation of the total area of photophores (mm2) standardized by fish body length (SL, mm)
   rename(sp = species, r = region)%>% 
   as.data.frame()
  
 #combine summary stats with density and photophore area details
  spp_sum<- cbind(spp_sum, temp)%>%                                                
    select(-c(sp, r)) %>%
    ##reorder for phylogenetic arrangement
    mutate(species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic")))

  # save to excel file in a new tab
  write.xlsx(spp_sum, file = 'Photo_Data.xls', sheetName = "Spp_summary", row.names = F, append = T)

### make a summary dataframe summarizing data in the master dataframe (df = photo) for each species, grouped by region and photophore type (df = spp_sum) ### 
  
  ## first make a dataframe to calculate the SL mean, min, max, and standard deviation because each photophore entry has an SL recorded, the SD and means are scewed when using full dataset. So create a dataframe for just the distinct values and find the mean, SL for those

spp_SL<- photo%>% 
  dplyr:: group_by(species, region, type)%>%
  distinct(SL)%>%
  summarize(avg_SL = mean(SL), #average standard length (mm) for specimens within each species
            sd_SL = sd(SL), #standard deviation of standard lengths (mm)
            min_SL = min(SL), #minimum standard length (mm)
            max_SL=max(SL))%>% #maximum standard length (mm)
  as.data.frame() 

  ## make the summary stats for other columns based on the master dataframe (df = photo)
  photo_spp_summary<- photo%>%
    dplyr:: group_by(species, region, type)%>%
    summarize (n = n_distinct(specimen), #number of specimens
               avg_size = mean(diameter), #average photophore size (diameter, micrometer)
               min_size = min(diameter),  #minimum photophore size (diameter, micrometer)
               max_size = max(diameter),  #maximum photophore size (diameter, micrometer)
               sd_size = sd(diameter), #standard deviation of photophore sizes (diameter)
               avg_sizeSL = mean(diameter_SL), #average standardized photophore size (micrometer/mmSL) - photophore diameter (micrometer) divided by specimen standard length (mm)
               sd_sizeSL = sd(diameter_SL),#standard deviation of standardized photophore size
               avg_angle = mean(angle, na.rm=T), #avearage angle of photophore orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
               min_angle = min(angle,na.rm=T), #minimum angle of photophore orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
               max_angle = max(angle, na.rm = T), #maximum angle of photophore orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
               sd_angle = sd(angle, na.rm=T))%>% #standard deviation of photophore orientation
    as.data.frame()%>%
    rename(sp= species, r = region, t = type)           #rename so you can remove duplicitive cols
 
    #bind SL data to summary stats
    photo_spp_summary<- cbind(spp_SL,photo_spp_summary)%>%
    select(-c(sp, r, t)) #remove duplicitive cols
    
  #make summary stats of density and photophore area from the photo_summary dataframe
  temp<- photo_summary%>%
    group_by(species,region,type)%>%
    summarize (avg_density = mean(density), #average photophore density (#/cm2)
               min_density = min(density), #minimum photophore density (#/cm2)
               max_density = max(density), #maximum photophore density (#/cm2)
               sd_density = sd(density), #standard deviation of photophore density
               avg_photo = mean(n), #average number of photophores
               min_photo = min(n), #minimum number of photophores
               max_photo = max(n), #maximum number of photophores
               sd_photo = sd(n),
               avg_photo_area_mm2_tot = mean(photo_area_mm2_tot), #average total area of photophores (mm2)
               min_photo_area_mm2_tot = min (photo_area_mm2_tot), #minimum total area of photophores (mm2)
               max_photo_area_mm2_tot = max(photo_area_mm2_tot), #maximum total area of photophores (mm2)
               sd_photo_area_mm2 = sd(photo_area_mm2_tot), #standard deviation of the total area of photophores
               avg_photo_area_mmSL_tot = mean(photo_area_mmSL_tot), #average total area of photophores (mm2) standardized by fish body length (SL, mm)
               min_photo_aream_mmSL_tot = min(photo_area_mmSL_tot), #minimum total area of photophores (mm2) standardized by fish body length (SL, mm)
               max_photo_area_mmSL_tot = max (photo_area_mmSL_tot), #maximum total area of photophores (mm2) standardized by fish body length (SL, mm)
               sd_area_mmSL_tot = sd(photo_area_mmSL_tot))%>% #standard deviation of the total area of photophores (mm2) standardized by fish body length (SL, mm) 
    rename(sp = species, r = region, t = type)%>%
    as.data.frame()
  
  #add density data to photo_spp_summary dataframe
  photo_spp_summary<- cbind(photo_spp_summary, temp)%>%
    select(-c(sp, r, t))%>%
    mutate(species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic")))%>% #reorder species to approriate phylogenetic order
  unite("typereg", c(region,type), remove= F, sep = ".")

  # write to .xls file as new tab
  write.xlsx(photo_spp_summary, file = 'Photo_Data.xls', sheetName = "PhotoSpp_summary", row.names = F, append = T)

### MAKE SUBSET DATAFRAMES FOR PLOTS #### 

## Make a dataframe with ONLY the data for the rostral regions ##
rostral<-photo%>%
    filter(region=="rostral")%>%
    select(-c(x,y,direction, catalog))%>%
    mutate(species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic")))##reorder for phylogenetic arrangement

 ## Make a summary dataframe for each specimen data in rostral region only 
rostral_summary <- rostral%>%
  dplyr::group_by(id, type)%>%
  summarize( SL = mean(SL), #in mm
             n = n(), #number of photophores
             avg_size = mean(diameter), #Average size of photophores (diameter) in micrometers
             sd_size = sd(diameter), #Standard deviation of photophore diameter
             avg_sizeSL= mean(diameter_SL), #Average size of specimen (standard length, in mm)
             sd_sizeSL= sd(diameter_SL), #Standard deviation of specimen SL 
             image_area = mean(image_area), #area imaged (cm2)
             avg_angle = mean(angle, na.rm = T), #Average angle of orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
             sd_angle = sd(angle), #standard deviation of angles of orientation
             photo_area_mm2_mean = mean(photo_area_mm2), #average photophore area (mm2)
             photo_area_mm2_tot = sum(photo_area_mm2), #sum of photophore areas (mm2)
             photo_area_mmSL_mean = mean(photo_area_mmSL), #average photophore area standardized for fish SL (mm2/mm)
             photo_area_mmSL_tot = sum(photo_area_mmSL))%>% #sum of average photophore area standardized for fish SL (mm2/mm)
  mutate(density = n/image_area)%>% #calculate density - number of photophores/cm2
  as.data.frame()%>%
  mutate(species = as.factor(str_sub(id,0,-5)), 
         specimen = as.factor (str_sub(id, 0, -4)), 
         region = as.factor(str_sub(id,-2)))%>%
  relocate(c(species, specimen, region), .before= id )
  
   
 ### Make summary table for rostral data, collating data for each species and type of photophore
 rostral_spp_sum <- rostral%>%
   dplyr::group_by(species, type)%>%
   summarize (n = n_distinct(specimen), #number of specimens
               avg_size = mean(diameter), #average photophore size (diameter, micrometer)
               sd_size = sd(diameter), #standard deviation of photophore sizes (diameter)
               avg_sizeSL = mean(diameter_SL), #average standardized photophore size (micrometer/mmSL) - photophore diameter (micrometer) divided by specimen standard length (mm)
               sd_sizeSL = sd(diameter_SL),#standard deviation of standardized photophore size
               avg_angle = mean(angle, na.rm=T), #avearage angle of photophore orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
               sd_angle = sd(angle, na.rm=T))%>% #standard deviation of photophore orientation
    as.data.frame()
 
  #make summary stats of density and photophore area from the rostral_summary dataframe
  temp<- rostral_summary%>%
    group_by(species, type)%>%
    summarize (avg_density = mean(density), #average photophore density (#/cm2)
               sd_density = sd(density), #standard deviation of photophore density
               avg_photo = mean(n), #average number of photophores
               sd_photo = sd(n),
               avg_photo_area_mm2_tot = mean(photo_area_mm2_tot), #average total area of photophores (mm2)
               sd_photo_area_mm2 = sd(photo_area_mm2_tot), #standard deviation of the total area of photophores
               avg_photo_area_mmSL_tot = mean(photo_area_mmSL_tot), #average total area of photophores (mm2) standardized by fish body length (SL, mm)
               sd_area_mmSL_tot = sd(photo_area_mmSL_tot))%>% #standard deviation of the total area of photophores (mm2) standardized by fish body length (SL, mm) 
    rename(sp = species, t = type)%>%
    as.data.frame()
  
  #add density data to photo_spp_summary dataframe
  rostral_spp_sum<- cbind(rostral_spp_sum, temp)%>%
    select(-c(sp, t))%>%
    mutate(species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic"))) #reorder species to appropriate phylogenetic order
  
  #save to .xlsx file in a new tab
  write.xlsx(rostral_spp_sum, file = 'Photo_Data.xls', sheetName = "rostral_spp_type_summary", row.names = F, append = T)
 
  ## Make a dataframe with ONLY the data for the mid region ##
  mid<-photo%>%
    filter(region=="mid")%>%
    select(-c(x,y,direction, catalog))%>%
    mutate(species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic")))##reorder for phylogenetic arrangement
  
  ## Make a summary dataframe for each specimen data in mid region only 
  mid_summary <- mid%>%
    dplyr::group_by(id, type)%>%
    summarize( SL = mean(SL), #in mm
               n = n(), #number of photophores
               avg_size = mean(diameter), #Average size of photophores (diameter) in micrometers
               sd_size = sd(diameter), #Standard deviation of photophore diameter
               avg_sizeSL= mean(diameter_SL), #Average size of specimen (standard length, in mm)
               sd_sizeSL= sd(diameter_SL), #Standard deviation of specimen SL 
               image_area = mean(image_area), #area imaged (cm2)
               avg_angle = mean(angle, na.rm = T), #Average angle of orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
               sd_angle = sd(angle), #standard deviation of angles of orientation
               photo_area_mm2_mean = mean(photo_area_mm2), #average photophore area (mm2)
               photo_area_mm2_tot = sum(photo_area_mm2), #sum of photophore areas (mm2)
               photo_area_mmSL_mean = mean(photo_area_mmSL), #average photophore area standardized for fish SL (mm2/mm)
               photo_area_mmSL_tot = sum(photo_area_mmSL))%>% #sum of average photophore area standardized for fish SL (mm2/mm)
    mutate(density = n/image_area)%>% #calculate density - number of photophores/cm2
    as.data.frame()%>%
    mutate(species = as.factor(str_sub(id,0,-5)), 
           specimen = as.factor (str_sub(id, 0, -4)), 
           region = as.factor(str_sub(id,-2)))%>%
    relocate(c(species, specimen, region), .before= id )%>%
    mutate(species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Tden", "Lgla", "Mbar", "Bmet", "Pgue", "Pmic")))##reorder for phylogenetic arrangement

  
  
  ### Make summary table for mid data, collating data for each species and type of photophore
  mid_spp_sum <- mid%>%
    dplyr::group_by(species, type)%>%
    summarize (n = n_distinct(specimen), #number of specimens
               avg_size = mean(diameter), #average photophore size (diameter, micrometer)
               sd_size = sd(diameter), #standard deviation of photophore sizes (diameter)
               avg_sizeSL = mean(diameter_SL), #average standardized photophore size (micrometer/mmSL) - photophore diameter (micrometer) divided by specimen standard length (mm)
               sd_sizeSL = sd(diameter_SL),#standard deviation of standardized photophore size
               avg_angle = mean(angle, na.rm=T), #avearage angle of photophore orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
               sd_angle = sd(angle, na.rm=T))%>% #standard deviation of photophore orientation
    as.data.frame()
  
  #make summary stats of density and photophore area from the mid_summary dataframe
  temp<- mid_summary%>%
    group_by(species, type)%>%
    summarize (avg_density = mean(density), #average photophore density (#/cm2)
               sd_density = sd(density), #standard deviation of photophore density
               avg_photo = mean(n), #average number of photophores
               sd_photo = sd(n),
               avg_photo_area_mm2_tot = mean(photo_area_mm2_tot), #average total area of photophores (mm2)
               sd_photo_area_mm2 = sd(photo_area_mm2_tot), #standard deviation of the total area of photophores
               avg_photo_area_mmSL_tot = mean(photo_area_mmSL_tot), #average total area of photophores (mm2) standardized by fish body length (SL, mm)
               sd_area_mmSL_tot = sd(photo_area_mmSL_tot))%>% #standard deviation of the total area of photophores (mm2) standardized by fish body length (SL, mm) 
    rename(sp = species, t = type)%>%
    as.data.frame()
  
  #add density data to photo_spp_summary dataframe
  mid_spp_sum<- cbind(mid_spp_sum, temp)%>%
    select(-c(sp, t))%>%
    mutate(species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic"))) #reorder species to appropriate phylogenetic order
  
  #save to .xlsx file in a new tab
  write.xlsx(mid_spp_sum, file = 'Photo_Data.xls', sheetName = "mid_spp_type_summary", row.names = F, append = T)
  
  ## Make a dataframe with ONLY the data for the caudal region ##
  caudal<-photo%>%
    filter(region=="caudal")%>%
    select(-c(x,y,direction, catalog))%>%
    mutate(species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic")))##reorder for phylogenetic arrangement
  
  ## Make a summary dataframe for each specimen data in caudal region only 
  caudal_summary <- caudal%>%
    dplyr::group_by(id, type)%>%
    summarize( SL = mean(SL), #in mm
               n = n(), #number of photophores
               avg_size = mean(diameter), #Average size of photophores (diameter) in micrometers
               sd_size = sd(diameter), #Standard deviation of photophore diameter
               avg_sizeSL= mean(diameter_SL), #Average size of specimen (standard length, in mm)
               sd_sizeSL= sd(diameter_SL), #Standard deviation of specimen SL 
               image_area = mean(image_area), #area imaged (cm2)
               avg_angle = mean(angle, na.rm = T), #Average angle of orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
               sd_angle = sd(angle), #standard deviation of angles of orientation
               photo_area_mm2_mean = mean(photo_area_mm2), #average photophore area (mm2)
               photo_area_mm2_tot = sum(photo_area_mm2), #sum of photophore areas (mm2)
               photo_area_mmSL_mean = mean(photo_area_mmSL), #average photophore area standardized for fish SL (mm2/mm)
               photo_area_mmSL_tot = sum(photo_area_mmSL))%>% #sum of average photophore area standardized for fish SL (mm2/mm)
    mutate(density = n/image_area)%>% #calculate density - number of photophores/cm2
    as.data.frame()%>%
    mutate(species = as.factor(str_sub(id,0,-5)), 
           specimen = as.factor (str_sub(id, 0, -4)), 
           region = as.factor(str_sub(id,-2)))%>%
    relocate(c(species, specimen, region), .before= id )
  
  
  ### Make summary table for caudal data, collating data for each species and type of photophore
  caudal_spp_sum <- caudal%>%
    dplyr::group_by(species, type)%>%
    summarize (n = n_distinct(specimen), #number of specimens
               avg_size = mean(diameter), #average photophore size (diameter, micrometer)
               sd_size = sd(diameter), #standard deviation of photophore sizes (diameter)
               avg_sizeSL = mean(diameter_SL), #average standardized photophore size (micrometer/mmSL) - photophore diameter (micrometer) divided by specimen standard length (mm)
               sd_sizeSL = sd(diameter_SL),#standard deviation of standardized photophore size
               avg_angle = mean(angle, na.rm=T), #avearage angle of photophore orientation (degrees, 0 = caudal, -90 = ventral, 180 = rostral, 90 = dorsal)
               sd_angle = sd(angle, na.rm=T))%>% #standard deviation of photophore orientation
    as.data.frame()
  
  #make summary stats of density and photophore area from the caudal_summary dataframe
  temp<- caudal_summary%>%
    group_by(species, type)%>%
    summarize (avg_density = mean(density), #average photophore density (#/cm2)
               sd_density = sd(density), #standard deviation of photophore density
               avg_photo = mean(n), #average number of photophores
               sd_photo = sd(n),
               avg_photo_area_mm2_tot = mean(photo_area_mm2_tot), #average total area of photophores (mm2)
               sd_photo_area_mm2 = sd(photo_area_mm2_tot), #standard deviation of the total area of photophores
               avg_photo_area_mmSL_tot = mean(photo_area_mmSL_tot), #average total area of photophores (mm2) standardized by fish body length (SL, mm)
               sd_area_mmSL_tot = sd(photo_area_mmSL_tot))%>% #standard deviation of the total area of photophores (mm2) standardized by fish body length (SL, mm) 
    rename(sp = species, t = type)%>%
    as.data.frame()
  
  #add density data to photo_spp_summary dataframe
  caudal_spp_sum<- cbind(caudal_spp_sum, temp)%>%
    select(-c(sp, t))%>%
    mutate(species=fct_relevel(species, c("Cslo", "Sboa", "Ncap", "Anig", "Cpli", "Fbou", "Tden", "Lgla", "Ebar", "Ifas", "Mbar", "Bmet", "Pgue", "Pmic"))) #reorder species to appropriate phylogenetic order
  
  #save to .xlsx file in a new tab
  write.xlsx(caudal_spp_sum, file = 'Photo_Data.xls', sheetName = "caudal_spp_type_summary", row.names = F, append = T)
 

### CODE FOR FIGURES ####
  
 ##Make custom themes and color schemes for graphs ##
  
 #custom theme for histogram images (size distribution for each species)
  custom_theme_hist<- function(){
  theme_bw()+
    theme(axis.text.x = element_text(angle=90, size = 8, vjust=0.3),
          axis.text.y = element_text(size = 8),
          axis.title.y = element_text(size = 10),
          axis.title.x = element_text(size = 10),
          strip.text.x = element_text(size= 10),
          legend.title= element_blank(),
          plot.background=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          panel.border=element_blank(),
          axis.line = element_line(),
          legend.position = "right",
          panel.grid.major.x = element_blank())
          }

  #custom theme for box plots (density and diameter all species on one plot)
  custom_theme_box<- function(){
    theme_bw()+
      theme(axis.text.x = element_text(angle=90, size = 8, vjust=0.3),
            axis.text.y = element_text(size = 8),
            axis.title.y = element_text(size = 10),
            axis.title.x = element_text(size = 10),
            strip.text.x = element_text(size= 10),
            legend.title= element_blank(),
            plot.background=element_blank(),
            panel.grid.minor=element_blank(),
            panel.border=element_blank(),
            axis.line = element_line(),
            legend.position = "bottom")
  }

  custom_theme_polar<- function(){
    theme_bw()+
      theme(axis.text.x = element_blank(),
            axis.text.y = element_text(size = 8),
            axis.title.y = element_text(size = 10),
            axis.title.x = element_text(size = 10),
            strip.text.x = element_text(size= 10),
            legend.title= element_blank(),
            axis.line = element_line(),
            legend.position = "bottom")
  }
  
  
 ## Figure 7: Photophore Diameter and Density and (new) total area ####

# Make boxblot to compare the photophore diameter for mid region
  a <- ggplot2::ggplot(mid, aes(fill = type, x = species, y = diameter_SL))+ 
    geom_boxplot(position = "dodge")+ 
    theme(axis.text.x=element_text(angle = 90, color = "black"),axis.text.y=element_text(color = "black"))+ 
    custom_theme_box()+ 
    coord_capped_cart(bottom = brackets_horizontal(length = unit (0.03, "npc")), left = "none") +   #use lemon package to make brackets instead of tick marks on x axis
    ylab("Photophore Diameter (\u00b5m/mm SL)")+ #\u00b5 is unicode text for mu symbol
    xlab(element_blank())+ 
    scale_fill_manual(values= c("#929292","#EBEBEB")) #greyscale
    #scale_fill_manual(values = c("#d95f02", "#1b9e77")) #colorblind friendly
  
  #Make boxplot to compare photophore density for mid region
  b <- ggplot2::ggplot(mid_summary, aes(fill = type, x = species, y = density))+ 
    geom_boxplot(position = "dodge")+ 
    theme(axis.text.x=element_text(angle = 90, color = "black"),axis.text.y=element_text(color = "black"))+ 
    custom_theme_box()+ 
    coord_capped_cart(bottom = brackets_horizontal(length = unit (0.03, "npc")), left = "none") +   #use lemon package to make brackets instead of tick marks on x axis
    ylab("Photophore Density (#/cm\u00b2)")+ #\u00b2 is unicode text for squared symbol
    xlab(element_blank())+ 
    scale_fill_manual(values= c("#929292","#EBEBEB")) #greyscale
    #scale_fill_manual(values = c("#d95f02", "#1b9e77")) #colorblind friendly
  
 c <- ggplot2::ggplot(mid_summary, aes(fill = type, x = species, y = photo_area_mmSL_tot))+ 
    geom_boxplot(position = "dodge")+ 
    theme(axis.text.x=element_text(angle = 90, color = "black"),axis.text.y=element_text(color = "black"))+ 
    custom_theme_box()+ 
    coord_capped_cart(bottom = brackets_horizontal(length = unit (0.03, "npc")), left = "none") +   #use lemon package to make brackets instead of tick marks on x axis
    ylab("Photophore Area (mm²/mmSL)")+ #\u00b5 is unicode text for mu symbol
    xlab("Species")+ 
   scale_fill_manual(values= c("#929292","#EBEBEB")) #greyscale
   #scale_fill_manual(values = c("#d95f02", "#1b9e77")) #colorblind friendly
  
  #combine diameter and density plots into one figure using patchwork package
  
  a/ b/c + plot_layout(guides = "collect", heights = 1) + plot_annotation(tag_levels = "A") #collect combines axes and/or legend (guides)
  
  #Save plot as 2 panel figure  
  ggsave("Figure7.pdf",last_plot(),dpi=300,height = unit(9.5,"in"),width = unit(3.6,"in"))
  
  
 ## Figure 8 - Size frequency distribution of photophores in representative species ####
  
# make a temp dataframe to house mean photophore diameter info for species of interest
  vline_temp<- mid_spp_sum%>%     
    filter(species %in% c("Sboa", "Anig", "Ncap", "Bmet"))
  
#build size frequency graphs
  a<-mid%>%
    filter(species %in% c("Sboa", "Anig", "Ncap", "Bmet"))%>%
    mutate(type = fct_relevel(type, "minute"))%>%
    ggplot()+
    geom_histogram(aes(x=diameter_SL, fill = type, after_stat(count)), color = "black", size = .3, binwidth = 0.2)+
    #geom_density(aes(x= diameter_SL, after_stat(count), fill = type), alpha = 0.6)+
    theme_bw()+
    custom_theme_hist()+
    scale_color_manual(values=c("#EBEBEB","#929292"))+
    scale_fill_manual(values= c("#EBEBEB", "#929292"))+ #greyscale
    #scale_fill_manual(values = c("#d95f02", "#1b9e77")) #colorblind friendly
    xlab("Photophore Diameter (\u00b5m/mm SL)")+
    ylab("Number of Photophores")+
    geom_vline(data = vline_temp, aes (xintercept = avg_sizeSL, linetype = type), size = .8)+
    scale_linetype_manual(values=c("dotted", "solid"))+
    facet_rep_wrap(~species, scales = "free_y", repeat.tick.labels = T, ncol = 1, drop = T, labeller = as_labeller (c(Sboa = "Stomias boa ferox",  Anig = "Astronesthes niger", Ncap = "Neonesthes capensis",Bmet = "Bathophilus metallicus")))+
    theme(strip.background = element_rect(color = "black", fill = "white"), legend.position = "bottom")
  
  ggsave("Figure8.pdf",last_plot(),dpi=300,height = unit(3.3,"in"),width = unit(6.3,"in"))

 ## Figure 9: Photophore orientation in mid region ####
 
  #make a temporary dataframe to hold summary data for vline 
  vline_temp <- photo_spp_summary%>%
    filter(region=="mid")
  
 a<- photo%>%
    filter(region == "mid")%>%
   mutate(type = fct_relevel(type, "serial"))%>%
    ggplot()+
   geom_rect(data = vline_temp, aes(xmin=0, xmax = 7, ymin = min_angle, ymax = max_angle, fill = type, color = type), alpha =0.5, inherit.aes = F, linewidth = 0.1)+ #add shading for min/max angle
    scale_fill_manual(values= c("#3D3D3D","#EBEBEB"))+
   scale_color_manual(values = c("#3d3d3d80", "#ebebeb80"))+
    geom_point(aes(x=diameter_SL,y=angle, fill = type), size=1.8, pch=21, color = "black")+
   geom_segment(data = vline_temp, aes (x = 0, xend = 7, y = avg_angle, yend= avg_angle, linetype = type), size = .8, inherit.aes = F)+
    custom_theme_polar()+
   theme (panel.grid.minor = element_line (linewidth = .2), panel.grid.major = element_line (linewidth = .5))+
    xlab("Photophore Diameter (\u00b5m/mm SL)")+
    ylab(element_blank())+
    scale_y_continuous(breaks = c(-90,0,90,180), limits = c(-180,180))+
    #greyscale
   #scale_fill_manual(values = c("#d95f02", "#1b9e77")) #colorblind friendly
    coord_polar(theta = "y", start = -55, direction = -1)+                      # plots as a radial plot - theta plots y (orientation) along the axis and leaves X as radials, start fiddled with to get proper orientation
    geom_vline(data = vline_temp, aes (xintercept = avg_sizeSL, linetype = type), size = .5, alpha = 0.6)+ #plot a line showing average photophore size of each type
    #geom_hline(data = vline_temp, aes (yintercept = avg_angle, linetype = type), size = .75, alpha = 0.9)+ #plot a line showing average orientation for each photohpore type
    scale_linetype_manual(values=c("dashed", "solid"))+                        
    facet_wrap(~species,ncol=3)+  
    theme(strip.background = element_rect(color = "black", fill = "white"), legend.position = "bottom")
  
  #Save plot   
  ggsave("Figure9.pdf",last_plot(),dpi=300,height = unit(6.7,"in"),width = unit(6.5,"in"))
  
  
 ## Figure 10: Photostomias guernei ####
  
  #Photophore density distribution for each region
  
  vline_temp<- photo_spp_summary%>%  # make a temp dataframe to house mean diameter info for just P.gue 
    filter(species=="Pgue")
  
  a<-photo%>%
    filter(species == "Pgue")%>%
    mutate(type = fct_relevel(type, "minute"))%>%
    ggplot()+
    geom_histogram(aes(x=diameter_SL, fill = type, after_stat(count)), color = "black", size = .3, binwidth = 0.2)+
    #geom_density(aes(x= diameter_SL, after_stat(count), fill = type), alpha = 0.6)+
    theme_bw()+
    custom_theme_hist()+
    theme(axis.text.x = element_text(angle=0, size = 8, vjust=0.3))+
    scale_color_manual(values=c("#EBEBEB","#929292"))+
    scale_fill_manual(values= c("#EBEBEB","#929292"))+ #greyscale
    #scale_fill_manual(values = c("#d95f02", "#1b9e77")) #colorblind friendly
    xlab("Photophore Diameter (\u00b5m/mm SL)")+
    ylab("Number of Photophores")+
    geom_vline(data = vline_temp, aes (xintercept = avg_sizeSL, linetype = type), size = .8)+
    scale_linetype_manual(values=c("dotted", "solid"))+
    facet_rep_wrap(~region, repeat.tick.labels = T, ncol = 3, drop = T)+
    theme(strip.background = element_rect(color = "black", fill = "white"), legend.position = "bottom", strip.text = element_text(size = 8))+
    guides(fill = "none")+ #turns off legend
    theme(legend.position = "none") #turns off legend
  
  ggsave("Figure10b.pdf",last_plot(),dpi=300,height = unit(2.3,"in"),width = unit(3.65,"in"))

  #Build density graphs
    b<-photo_summary%>%
    filter(species == "Pgue")%>%
    ggplot(aes(fill = type, x = type, y = density))+ 
    geom_boxplot(position = "dodge")+ 
    custom_theme_box()+ 
    theme(axis.text.x=element_blank(),axis.text.y=element_text(color = "black"))+ 
    ylab("Photophore Density \n (#/cm\u00b2)")+ #\u00b2 is unicode text for squared symbol
    scale_fill_manual(values= c("#929292","#EBEBEB"))+ #greyscale
    #scale_fill_manual(values = c("#d95f02", "#1b9e77"))+ #colorblind friendly
    xlab(element_blank())+ 
      facet_rep_wrap(~region, repeat.tick.labels = T, ncol = 3, drop = T)+
      theme(strip.background = element_rect(color = "black", fill = "white"), legend.position = "bottom", strip.text = element_text(size = 8))+
      guides(fill = "none")+ #turns off legend
      theme(legend.position = "none") #turns off legend
    
    ggsave("Figure10c.pdf",last_plot(),dpi=300,height = unit(2.117,"in"),width = unit(2.55,"in"))

   #Build area graphs
     c<-photo_summary%>%
       filter(species == "Pgue")%>%
       ggplot(aes(fill = type, x = type, y = photo_area_mmSL_tot))+ 
       geom_boxplot(position = "dodge")+ 
       custom_theme_box()+ 
       theme(axis.text.x=element_blank(),axis.text.y=element_text(color = "black"))+ 
       ylab("Photophore Area (mm²/mmSL)")+ #\u00b2 is unicode text for squared symbol
       scale_fill_manual(values= c("#929292","#EBEBEB"))+ #greyscale
       #scale_fill_manual(values = c("#d95f02", "#1b9e77"))+ #colorblind friendly
       xlab(element_blank())+ 
       facet_rep_wrap(~region, repeat.tick.labels = T, ncol = 3, drop = T)+
       theme(strip.background = element_rect(color = "black", fill = "white"), legend.position = "bottom", strip.text = element_text(size = 8))+
       guides(fill = "none")+ #turns off legend
       theme(legend.position = "none") #turns off legend
     ggsave("Figure10e.pdf",last_plot(),dpi=300,height = unit(2.117,"in"),width = unit(2.67,"in"))
     
     #Build orientation graphs
     d<-photo%>%
       filter(species == "Pgue")%>%
       ggplot()+
       geom_rect(data = vline_temp, aes(xmin=0, xmax = 4, ymin = min_angle, ymax = max_angle, fill = type), alpha =0.5, inherit.aes = F, color = "#929292")+ #add shading for min/max angle
       scale_fill_manual(values= c("#3D3D3D","#EBEBEB"))+
       geom_point(aes(x=diameter_SL,y=angle, fill = type), size=1.8, pch=21, color = "black")+
       geom_segment(data = vline_temp, aes (x = 0, xend = 3.99, y = avg_angle, yend= avg_angle, linetype = type), arrow = arrow(length = unit (0.2, "cm"), type = "open"), size = .8, inherit.aes = F)+
       custom_theme_polar()+
       #xlab("Photophore Diameter \n (\u00b5m/mm SL)")+
       xlab(element_blank())+
       ylab(element_blank())+
       scale_y_continuous(breaks = c(-90,0,90,180), limits = c(-180,180))+
       #greyscale
       #scale_fill_manual(values = c("#d95f02", "#1b9e77")) #colorblind friendly
       coord_polar(theta = "y", start = -55, direction = -1)+                      # plots as a radial plot - theta plots y (orientation) along the axis and leaves X as radials, start fiddled with to get proper orientation
       geom_vline(data = vline_temp, aes (xintercept = avg_sizeSL, linetype = type), size = .5, alpha = 0.6)+ #plot a line showing average photophore size of each type
       #geom_hline(data = vline_temp, aes (yintercept = avg_angle, linetype = type), size = .75, alpha = 0.9)+ #plot a line showing average orientation for each photohpore type
       scale_linetype_manual(values=c("dashed", "solid"))+                        
       facet_wrap(~region,ncol=3)+  
       theme(strip.background = element_rect(color = "black", fill = "white"), legend.position = "bottom", strip.text = element_text(size = 8))+
       guides(fill = "none")+ #turns off legend
       theme(legend.position = "none") #turns off legend
     ggsave("Figure10d.pdf",last_plot(),dpi=300,height = unit(2.3,"in"),width = unit(3.7,"in"))
  
     patch<- (b/c) /d   
#combine all 4 plots
     
      (a + b) / (plot_spacer() + c) + plot_layout(guides = "collect", widths = c(2,1))
    (a+patch)/ (d+plot_spacer())+ plot_layout(guides = "collect", widths = unit(c(3.7, 2.2), c('in', 'in')), heights = c(2,1)) + plot_annotation(tag_levels = "A") #collect combines axes and/or legend (guides)
     
 (a+b)/(d+c)+plot_layout(guides = "collect", widths = c(2,1), heights = c(1,1))
     #Save plot   
     ggsave("Figure10.pdf",last_plot(),dpi=300,height = unit(4.4,"in"),width = unit(6.5,"in"))   
     
 #Figure ___ New supplemental??
   # Make boxblot to compare the total area of photophores within mid region
  a <- ggplot2::ggplot(mid_summary, aes(fill = type, x = species, y = photo_area_mmSL_tot))+ 
    geom_boxplot(position = "dodge")+ 
    theme(axis.text.x=element_text(angle = 90, color = "black"),axis.text.y=element_text(color = "black"))+ 
    custom_theme_box()+ 
    coord_capped_cart(bottom = brackets_horizontal(length = unit (0.03, "npc")), left = "none") +   #use lemon package to make brackets instead of tick marks on x axis
    ylab("Photophore Area (mm²/mmSL)")+ #\u00b5 is unicode text for mu symbol
    xlab(element_blank())+ 
    scale_fill_manual(values= c("#929292","#EBEBEB"))
  
  b <- ggplot2::ggplot(rostral_summary, aes(fill = type, x = species, y = photo_area_mmSL_tot))+ 
    geom_boxplot(position = "dodge")+ 
    theme(axis.text.x=element_text(angle = 90, color = "black"),axis.text.y=element_text(color = "black"))+ 
    custom_theme_box()+ 
    coord_capped_cart(bottom = brackets_horizontal(length = unit (0.03, "npc")), left = "none") +   #use lemon package to make brackets instead of tick marks on x axis
    ylab("Photophore Area (mm²/mmSL)")+ #\u00b5 is unicode text for mu symbol
    xlab(element_blank())+ 
    scale_fill_manual(values= c("#929292","#EBEBEB"))
  
  c <- ggplot2::ggplot(caudal_summary, aes(fill = type, x = species, y = photo_area_mmSL_tot))+ 
    geom_boxplot(position = "dodge")+ 
    theme(axis.text.x=element_text(angle = 90, color = "black"),axis.text.y=element_text(color = "black"))+ 
    custom_theme_box()+ 
    coord_capped_cart(bottom = brackets_horizontal(length = unit (0.03, "npc")), left = "none") +   #use lemon package to make brackets instead of tick marks on x axis
    ylab("Photophore Area (mm²/mmSL)")+ #\u00b5 is unicode text for mu symbol
    xlab(element_blank())+ 
    scale_fill_manual(values= c("#929292","#EBEBEB"))
  
a/ (b+c) + plot_layout(guides = "collect", heights = 1, widths = c(1,2)) + #use patchwork package to arrange parts of plot.
    plot_annotation(tag_levels = "A") #collect combines axes and/or legend (guides)
    
  
  ggsave("PhotoArea.pdf",last_plot(),dpi=300,height = unit(6.7,"in"),width = unit(6.5,"in"))
 
  
