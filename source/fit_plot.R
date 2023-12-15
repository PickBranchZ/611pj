library(tidyverse)
library(corrplot)
library(caTools)
library(ResourceSelection)
library(caret)
library(rpart)
library(rpart.plot)



mydata = read.csv("derived_data/liquor_items.csv")
mydata = na.omit(mydata)

data_index = mydata[mydata$Bottles.Sold>=730, ]
data_index$Category = as.factor(data_index$Category)
data_index$Vendor= as.factor(data_index$Vendor)


data_p = data_index[,-c(10,12,13)]
data_c = data_index[,-c(11,12)]


# Data Correlation
M <- cor(mydata[,c(4:10)])
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))


png("figures/fig3_correlation.png", width = 800, height = 800)
corrplot(M, method="color", col=col(200),  
         type="upper",  
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE
)
dev.off()



#classprep
data_used = data_p
set.seed(111111)
split = sample.split(data_used$Popularity, SplitRatio = 0.60)

training_set = subset(data_used, split == TRUE)
test_set = subset(data_used, split == FALSE)


data_used = data_c
set.seed(111111)
split = sample.split(data_used$Popularity, SplitRatio = 0.60)

training_setc = subset(data_used, split == TRUE)
test_setc = subset(data_used, split == FALSE)



#glm1
full = glm(Popularity~.-Item.Number, data = training_set, family=binomial)
nullmodel = glm(Popularity~1, data = training_set, family=binomial)
n=nrow(training_set)
fit_step = step(nullmodel, scope=list(lower= nullmodel,
                                     upper=full),direction="both",k=log(n))

glm1 = summary(fit_step)$coefficients
#hoslem.test(fit_step$y, fit_step$fitted.values,g=10)


etahat_fit = predict(fit_step, type = "link")
pb_fit = predict(fit_step, type = "response")

p4 <- ggplot(training_set,aes(x= etahat_fit,y= pb_fit))+
  geom_point(aes(color=factor(Popularity)),position=position_jitter(height=0.03,width=0),size=0.5)+
  geom_line(aes(x= etahat_fit,y=pb_fit))+
  labs(x="eta_hat",y="probability")+
  scale_color_manual(values=c("red","blue"),name="Popularity",labels=c("Popular","Unpopular"))+
  geom_hline(yintercept=0.49,linetype="dashed")+
  geom_vline(xintercept=-0.15,linetype="dashed")+
  scale_y_continuous(breaks=seq(0,1,by=0.1))+theme_bw() +
  ggtitle("GLM Prediction for General Popularity")
ggsave(p4, filename = "figures/fig4_glmprediction.png", height = 6, width = 10)



pihat_test = predict(fit_step,
                     newdata=test_set,
                     type="response")
threshold = 0.49
predicted_category =
  factor(ifelse(pihat_test>threshold, 1,0) )
cm11 = confusionMatrix(data= predicted_category,
                       reference= as.factor(as.numeric(test_set$Popularity)))


full = glm(PopularityC~.-Item.Number, data = training_setc, family=binomial)
nullmodel = glm(PopularityC~1, data = training_setc, family=binomial)
n=nrow(training_setc)
fit_step = step(nullmodel,scope=list(lower= nullmodel,
                                     upper=full),direction="both",k=log(n))

glm2 = summary(fit_step)$coefficients










#decision tree for general popularity
fit <- rpart(Popularity~.-Item.Number, data = training_set, method = 'class')
#rpart.plot(fit,cex = 0.5)

predict_unseen <-predict(fit, test_set, type = 'class')
table_mat <- table(test_set$Popularity, predict_unseen)
cm12 = confusionMatrix(table_mat)

# Importance of variables
importance = data.frame(imp = fit$variable.importance)
df2 <- importance %>% 
  tibble::rownames_to_column() %>% 
  dplyr::rename("variable" = rowname) %>% 
  dplyr::arrange(imp) %>%
  dplyr::mutate(variable = forcats::fct_inorder(variable))

p5 <- ggplot2::ggplot(df2) +
  geom_col(aes(x = variable, y = imp),
           col = "black", show.legend = F) +
  coord_flip() +
  scale_fill_grey() +
  theme_bw() + ggtitle("Importance of Variable for Decision Tree (General Popularity)")
ggsave(p5, filename = "figures/fig5_tree1.png", height = 6, width = 10)



#decision tree for popularity during covid
fit <- rpart(PopularityC~.-Item.Number, data = training_setc, method = 'class')
#rpart.plot(fit,cex = 0.5)

predict_unseen <-predict(fit, test_setc, type = 'class')
table_mat <- table(test_setc$PopularityC, predict_unseen)
cm22 = confusionMatrix(table_mat)

# Importance of variables
importance = data.frame(imp = fit$variable.importance)
df2 <- importance %>% 
  tibble::rownames_to_column() %>% 
  dplyr::rename("variable" = rowname) %>% 
  dplyr::arrange(imp) %>%
  dplyr::mutate(variable = forcats::fct_inorder(variable))

p6 <- ggplot2::ggplot(df2) +
  geom_col(aes(x = variable, y = imp),
           col = "black", show.legend = F) +
  coord_flip() +
  scale_fill_grey() +
  theme_bw() + ggtitle("Importance of Variable for Decision Tree (Covid Popularity)")
ggsave(p6, filename = "figures/fig6_tree2.png", height = 6, width = 10)









