##Plot tree if needed
if(!require('ape'))install.packages('ape'); library('ape')
if(!require('phangorn'))install.packages('phangorn'); library('phangorn')
if(!require('ggtree'))install.packages('ggtree');library('ggtree')
library("ggplot2")


library(ggtree)

data <-ape::read.nexus.data("Stomiatiformes.nex.xz")
my_dat <- phyDat(data)

tree <- ape::read.tree("Stomiatiformes_phylogram.tre")
ape::plot.phylo(tree, type = "phylogram", adj =0)

plot(tree, no.margin = TRUE)
str(tree)

keep <- c( "Pachystomias_microdon", "Malacosteus_niger","Bathophilus_vaillanti","Bathophilus_pawneei", "Echiostoma_barbatum",
           "Idiacanthus_fasciola","Idiacanthus_antrostomus", "Melanostomias_margaritifer","Leptostomias_gladiator",
           "Leptostomias_longibarba","Thysanactis_dentex","Flagellostomias_boureei", "Astronesthes_similus",  "Astronesthes_gemmifer", 
           "Neonesthes_capensis", "Stomias_gracilis", "Stomias_boa_boa", "Stomias_affinis", "Astronesthes_macropogon","Chauliodus_sloani","Chauliodus_danae",
           "Chauliodus_macouni")
keep2 <-c ("Pachystomias_microdon", "Bathophilus_vaillanti","Echiostoma_barbatum",
           "Idiacanthus_fasciola","Melanostomias_margaritifer","Leptostomias_gladiator",
           "Thysanactis_dentex","Flagellostomias_boureei", "Astronesthes_gemmifer", 
           "Neonesthes_capensis", "Stomias_boa_boa", "Chauliodus_sloani","Chirostomias_pliopterus", "Malacosteus_niger", "Eustomias_acinosus")
plot(keep.tip(tree, keep2))
newtree <-keep.tip(tree,keep2)

plot(newtree, no.margin = TRUE)
nodelabels()
nodelabels(text = 1:newtree$Nnode, node = 1:newtree$Nnode+Ntip(newtree))

tree2 <-rotate(newtree, 25)

plot(tree2)
   
   
