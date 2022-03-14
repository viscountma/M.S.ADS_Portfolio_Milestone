#IST 707 Final Project
library(arules)
library(arulesViz)
library(ggplot2)
pokemon<-read.csv("~/R/707/project/All_Pokemon.csv")
pokemon$Generation<-as.character(pokemon$Generation)
boxplot(BST~Generation, data=pokemon)

ggplot(pokemon, aes(x=Generation, y=BST, fill=..x..)) +
  geom_boxplot(alpha = 0.5) +
  labs(title="Base Stats Distribution for Different Generation", x ="Generation", y = "Base Stats") + theme_classic()+
  scale_fill_gradientn(colours = c("red","blue","yellow"),
                       breaks=c(0,25,50,75,Inf),
                       guide = "colorbar")

pokemonData<-subset(pokemon,select= c(Type.1, Type.2, BST, Catch.Rate, Generation, Legendary, Height, Weight))



bins <- 3
width<-(max_BST - min_BST)/bins;
min_BST+width
pokemonData$BST <- cut(pokemonData$BST, breaks=c(174.9, 376.6667, 578.3333, 780)
                 ,labels=c("low","mediocre","high"))
max_Catch.Rate<-max(pokemonData$Catch.Rate)
min_Catch.Rate<-min(pokemonData$Catch.Rate)
width<-(max_Catch.Rate - min_Catch.Rate)/bins;
min_Catch.Rate+width+width
pokemonData$Catch.Rate <- cut(pokemonData$Catch.Rate, breaks=c(2.9, 87, 171, 255)
                       ,labels=c("low","average","high"))
max_Height<-max(pokemonData$Height)
min_Height<-min(pokemonData$Height)
width<-(max_Height - min_Height)/bins;
min_Height+width
pokemonData$Height <- cut(pokemonData$Height, breaks=c(0.09, 6.733333, 13.36667, 20)
                              ,labels=c("short","average","tall"))
max_Weight<-max(pokemonData$Weight)
min_Weight<-min(pokemonData$Weight)
width<-(max_Weight - min_Weight)/bins;
min_Weight+width+width
pokemonData$Weight <- cut(pokemonData$Weight, breaks=c(0.09, 333.3667, 666.6333, 999.9)
                          ,labels=c("light","average","heavy"))

pokemonData$Type.1<-as.factor(pokemonData$Type.1)
pokemonData$Type.2<-as.factor(pokemonData$Type.2)
pokemonData$BST<-as.factor(pokemonData$BST)
pokemonData$Catch.Rate<-as.factor(pokemonData$Catch.Rate)
pokemonData$Generation<-as.factor(pokemonData$Generation)
pokemonData$Legendary<-as.factor(pokemonData$Legendary)
pokemonData$Height<-as.factor(pokemonData$Height)
pokemonData$Weight<-as.factor(pokemonData$Weight)

rules <- apriori(pokemonData, parameter=list(support=0.5, confidence=0.8, minlen=3))
inspect(rules)
rulesLeg <- apriori(pokemonData, parameter=list(support=0.05, confidence=0.6, minlen=3),
                    appearance=list(default="lhs",rhs=("Legendary=1")))
inspect(rulesLeg)
plot(rulesLeg,method = "graph")
rulesLeg2 <- apriori(pokemonData, parameter=list(support=0.01, confidence=0.9, minlen=3),
                    appearance=list(default="lhs",rhs=("Legendary=1")))
inspect(rulesLeg2)
plot(rulesLeg2,method = "graph")
rulesLeg3 <- apriori(pokemonData, parameter=list(support=0.01, confidence=0.3, minlen=3),
                     appearance=list(default="lhs",rhs=("Type.1=Psychic")))
inspect(rulesLeg3)
plot(rulesLeg3,method = "graph")
