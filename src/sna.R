library(networkD3)
library(ggplot2)
######### Paper per Country #########
setwd('~/Desktop/class/HCC/project/src/')
paper_per_cty_15 <- read.table('./paper_per_cty_2015.txt', sep = '\t', header = TRUE)
paper_per_cty_16 <- read.table('./paper_per_cty_2016.txt', sep = '\t', header = TRUE)

ggplot(paper_per_cty_15, aes(x=country, y=value)) + 
  coord_flip() + geom_bar(stat = "identity") + 
  xlab('Number of papers') + 
  ggtitle('2015') + 
  theme(plot.title = element_text(hjust = 0.5))

ggplot(paper_per_cty_16, aes(x=country, y=value)) + 
  coord_flip() + geom_bar(stat = "identity") + 
  xlab('Number of papers') + 
  ggtitle('2016') + 
  theme(plot.title = element_text(hjust = 0.5))

######## Country collaboration network ############
# cty-cty collaboration network
cty_2015 <- read.table('./country_graph_2015.txt',  sep = '\t', header = TRUE)
cty_id_2015 <- read.table('./country_graph_2015_id.txt',  sep = '\t', header = TRUE)

cty_2016 <- read.table('./country_graph_2016.txt',  sep = '\t', header = TRUE)
cty_id_2016 <- read.table('./country_graph_2016_id.txt',  sep = '\t', header = TRUE)

library(magrittr)

forceNetwork(Links = cty_2015, Nodes = cty_id_2015,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8) %>%
  saveNetwork(file = 'cty_2015.html')

forceNetwork(Links = cty_2016, Nodes = cty_id_2016,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8) %>%
  saveNetwork(file = 'cty_2016.html')

# cty degree distribution
cty_dg_2015 <- read.table('./cty_deg_2015.txt',  sep = '\t', header = TRUE)
cty_dg_2016 <- read.table('./cty_deg_2016.txt',  sep = '\t', header = TRUE)
cty_all <- rbind(cty_dg_2015, cty_dg_2016)
ggplot(cty_dg_2015, aes(x= reorder(country, degree), y= degree)) + 
  coord_flip() + geom_bar(stat = "identity") + 
  xlab('Number of papers') + 
  ggtitle('2015') + 
  theme(plot.title = element_text(hjust = 0.5))

qplot(cty_dg_2015$degree, geom="histogram") + xlab('Degree') + 
          ggtitle('Degree distribution: 2015') +
  theme(plot.title = element_text(hjust = 0.5))


############## Author collaboration network ##############
author_count <- read.table('./author_count.txt',  sep = '\t', header = TRUE)
author_count <- subset(author_count, count>4)
ggplot(author_count, aes(x= reorder(author, count), y=count)) + 
  coord_flip() + geom_bar(stat = "identity") + 
  xlab('Author name') + 
  ggtitle('Authors contribution 2015 and 2016') + 
  theme(plot.title = element_text(hjust = 0.5))

qplot(author_count$count, geom="histogram") + xlab('Degree') + 
  ggtitle('Degree distribution: 2015') +
  theme(plot.title = element_text(hjust = 0.5))

author_2015 <- read.table('./author_graph_2015.txt', sep = '\t', header = TRUE )
author_2015 <- subset(author_2015, author_2015$value >1)
rownames(author_2015) <- seq(length=nrow(author_2015))

author_id_2015 <- read.table('./author_graph_2015_id.txt', sep = '\t', header = TRUE, quote=NULL)

forceNetwork(Links = author_2015, Nodes = author_id_2015,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8)

qplot(author_2015$value, geom="histogram") + xlab('Collaboration Frequency') + 
  ggtitle('Collaboration Frequency: 2015') +
  theme(plot.title = element_text(hjust = 0.5))

author_2016 <- read.table('./author_graph_2016.txt', sep = '\t', header = TRUE)
author_2016 <- subset(author_2016, author_2016$value >1)
author_id_2016 <- author_id_2016[1:90,]

rownames(author_2015) <- seq(length=nrow(author_2015))

author_id_2016 <- read.table('./author_graph_2016_id.txt', sep = '\t', header = TRUE,quote = NULL)

forceNetwork(Links = author_2016, Nodes = author_id_2016,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8)  %>%
  saveNetwork(file = 'author_2016.html')

simpleNetwork(author_graph_all)
qplot(author_2016$value, geom="histogram") + xlab('Collaboration Frequency') + 
  ggtitle('Collaboration Frequency: 2016') +
  theme(plot.title = element_text(hjust = 0.5))

# Coauthors in 2015 and 2016
author_all <- read.table('./author_all.txt', sep = '\t', header = TRUE) 
author_all <- subset(author_all, author_all$count > 2)
qplot(author_all$count, geom="histogram") + xlab('Collaboration Frequency') + 
  ggtitle('Collaboration Frequency: 2016') +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(author_all, aes(x=reorder(author, count), y=count)) + 
  coord_flip() + geom_bar(stat = "identity") + 
  xlab('Coauthor Pair') + 
  ggtitle('Authors collaboration: 2015 and 2016') + 
  theme(plot.title = element_text(hjust = 0.5))

author_graph_all <- read.table('./author_graph_all_yr.txt', sep = '\t', header = TRUE) 
author_graph_all <- subset(author_graph_all, author_graph_all$value > 2)
author_graph_all$value <- as.integer(as.character(author_graph_all$value))
author_graph_all$source <- as.integer(as.character(author_graph_all$source))
author_graph_all$target <- as.integer(as.character(author_graph_all$target))
rownames(author_graph_all) <- seq(length=nrow(author_graph_all))


author_graph_id <- read.table('./author_graph_all_id_yr.txt', sep = '\t', header = TRUE, quote = NULL) 
forceNetwork(Links = author_graph_all, Nodes = author_graph_id,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8)   %>%
  saveNetwork(file = 'author_all_by_year.html')


######### institute ##########
inst_2015 <- read.table('./inst_graph_2015.txt', sep = '\t', header = TRUE)
inst_2015_id <- read.table('./inst_graph_2015_id.txt', sep = '\t', header = TRUE)
forceNetwork(Links = inst_2015, Nodes = inst_2015_id,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8)  %>%
  saveNetwork(file = 'inst_2015.html')

inst_2016 <- read.table('./inst_graph_2016.txt', sep = '\t', header = TRUE)
inst_2016_id <- read.table('./inst_graph_2016_id.txt', sep = '\t', header = TRUE)
forceNetwork(Links = inst_2016, Nodes = inst_2016_id,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8)  


cty_graph_all <- read.table('./country_graph_all_yr.txt', sep = '\t', header = TRUE) 
cty_graph_all$value <- as.integer(as.character(cty_graph_all$value))
cty_graph_all$source <- as.integer(as.character(cty_graph_all$source))
cty_graph_all$target <- as.integer(as.character(cty_graph_all$target))
rownames(cty_graph_all) <- seq(length=nrow(cty_graph_all))


cty_graph_id <- read.table('./country_graph_all_id_yr.txt', sep = '\t', header = TRUE, quote = NULL) 
forceNetwork(Links = cty_graph_all, Nodes = cty_graph_id,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8)  %>%
  saveNetwork(file = 'cty_all_by_year.html') 


inst_graph_all <- read.table('./inst_graph_all_yr.txt', sep = '\t', header = TRUE) 
inst_graph_all$value <- as.integer(as.character(inst_graph_all$value))
inst_graph_all$source <- as.integer(as.character(inst_graph_all$source))
inst_graph_all$target <- as.integer(as.character(inst_graph_all$target))
# rownames(cty_graph_all) <- seq(length=nrow(inst_graph_all))


inst_graph_id <- read.table('./inst_graph_all_id_yr.txt', sep = '\t', header = TRUE, quote = NULL) 
forceNetwork(Links = inst_graph_all, Nodes = inst_graph_id,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8)  %>%
  saveNetwork(file = 'inst_all_by_year.html') 


inst_count <- read.table('inst_count.txt', sep = '\t', header = TRUE) 
inst_count <- subset(inst_count, inst_count$count > 10)
ggplot(inst_count, aes(x= reorder(institute, count), y=count)) + 
  coord_flip() + geom_bar(stat = "identity") + 
  xlab('Institute') + 
  ggtitle('Institute contribution 2015 and 2016') + 
  theme(plot.title = element_text(hjust = 0.5))
