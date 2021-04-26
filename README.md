# `Preface - UN votes` ![](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
Since 1946, all member states of the United Nations have come together at the United Nations General Assembly to discuss and vote on resolutions, among other things. Currently 193 states belong to the United Nations. Each of these member states has exactly one vote in the General Assembly’s resolution votes on issues such as disarmament, international security, humanitarian aid and human rights.

# Case description
The record for this task contains the complete voting process at the General Assembly of each country. Is it possible to predict whether Germany will vote “yes” or “no” in a resolution vote?

# Task description

- Display the number of resolutions voted on each year in a line chart. In which year were there the most votes and how many were there? Calculate between Germany and the USA for each year the proportion of equal votes (variable vote) for resolutions, hereinafter referred to as **agreement**. For the year 2006, the agreement between the two states was only about 25% of a total of 87 votes. (*Note: until 1989 “Federal Republic of Germany”; from 1989 “Germany”*)
![](https://github.com/ranjiGT/ensemble-UNvotes/blob/main/trend.png)
![](https://github.com/ranjiGT/ensemble-UNvotes/blob/main/densityplot.png)
- Create a linear regression model that predicts the agreement between the two states based on the year (agreement ~ year). Interpret the trend and the p-value of the regression coefficient for year. Check the statement of the model graphically. Create a distance matrix between all pairs of states based on their voting history. Only consider states that have cast a vote in at least 70% of all votes. Determine the 5 states that are most similar or most dissimilar to Germany with regard to the voting history at UN General Assemblies.
![](https://github.com/ranjiGT/ensemble-UNvotes/blob/main/centipede%20plot.png)
![](https://github.com/ranjiGT/ensemble-UNvotes/blob/main/heatmap.png)
- Divide the data set into a training and test set at a ratio of 75%:25%. Create a kNN classifier with **k = 3 (caret::knn3Train())** to predict the vote of Germany in a vote based on the votes of the countries **'Italy', 'Netherlands', 'United States of America', 'Israel', 'Cuba', 'India'**. Remove votes in which Germany abstained (vote=2 (“Abstain”)) to get a binary target variable for vote=1 (“Yes”) and vote=0 (“No”). Create the Confusion Matrix and calculate the Accuracy for the model. On the same data, create a logistic regression model **(glm(..., family = "binomial"))** and compare the accuracy with that of the kNN classifier.
