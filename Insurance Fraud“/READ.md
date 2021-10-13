# AUTO INSURANCE FRAUD

## 

**Citlalli Blanchet**


# INTRODUCTION

Insurance fraud is a deliberate deception perpetrated against an insurance company for the purpose of a financial gain. Fraud may be committed at different points in the transaction by applicants, policyholders, third-party claimants, or professionals who provide services to claimants.
Fraud accounted for between 15 percent and 17 percent of total claims payments for auto insurance bodily injury in 2012, according to an Insurance Research Council (IRC) study. The ****[study](https://www.insurance-research.org/sites/default/files/downloads/IRC%20Fraud%20News%20Release.pdf)**** estimated that between $5.6 billion and $7.7 billion was fraudulently added to paid claims for auto insurance bodily injury payments in 2012, compared with a range of $4.3 billion to $5.8 billion in 2002.

One of the most effective means of combating fraud is the adoption of data technologies that cut the time needed to recognize fraud.
Traditional approaches, such as using automated red flags and business rules, have been augmented by predictive modeling, and link analysis—which examines the relationships between items like people, places and events. Artificial intelligence can be used, among other tools, to uncover fraud before a payment is made. These newer strategies are employed when claims are first filed. Suspicious claims are flagged for further review, while those with no suspicious elements are processed normally. In search of refinement, insurers are blending tools to improve their fraud detection programs.

In this analysis we will focus on  fraud claims committed by insured  individuals. 
The purpose of this analysis is to find a model that will enable the prediction of whether an auto claim is a fraud or not.


# EXPLORATORY DATA ANALYSIS
This database contains 1000 auto claims in three states, OH, IL, and IN. For these claims,  the database has the following 39 features:

* months_as_customer
* age
* policy_number
* policy_bind_date
* policy_state
* policy_csl
* policy_deductable
* policy_annual_premium
* umbrella_limit
* insured_zip
* insured_sex
* insured_education_level
* insured_occupation
* insured_hobbies
* insured_relationship
* capital-gains
* capital-loss
* incident_date
* incident_type
* collision_type
* incident_severity
* authorities_contacted
* incident_state
* incident_city
* incident_location
* incident_hour_of_the_day
* number_of_vehicles_involved
* property_damage
* bodily_injuries
* witnesses
* police_report_available
* total_claim_amount
* injury_claim
* property_claim
* vehicle_claim
* auto_make
* auto_model
* Lauto_year
* fraud_reported



This database has a character in some features that I will treat as missing value. These values represent a significant proportion of the features, for this reason I will substitute these values for the most common value of each feature.

Feature name | Percentage of missing values
------------ | -------------
percentproperty_damage | 36%
police_report_available  |  34.3% 
collision_type | 17.8%


We can see that the non fraud claims represent 75.3% of the database and the fraud claims represent 24.7% of the database.
This database is considered an imbalanced dataset because the fraud and the non fraud claims are not represented equally. This issue is going to be addressed in the modeling section of this report.

<img width="963" alt="piechart" src="https://user-images.githubusercontent.com/44710328/137051208-0053fb35-066e-4f53-a3b2-370ed6438400.png">

The objective of this exploratory data analysis is to identify features that could be relevant contributors in determining if a given auto claim is a fraud or not.

We start by looking for the correlation between some features. The relevant correlations that I could find were between total claim amount and vehicle claim; these features present a positive correlation. Also property claim amount and Injury claim and age and months as customers have a positive correlation. We can see it represented in the following chart.

![Correlation small](https://user-images.githubusercontent.com/44710328/137054771-8e82ffde-2fe0-43ff-93f5-d1135a432470.png)

While looking at the number of claims by the level of education of the insured in conjunction with the case if they filed a police report of the accident, I found that there is not a clear difference by education level of the fraud or non fraud claims. But it seems that some people will file a police report even if they are filing a fraudulent claim.

<img width="944" alt="Parallel diagram" src="https://user-images.githubusercontent.com/44710328/137055009-2cd0684d-a4d0-4aeb-9530-0173952a816e.png">

As we saw before there are some fraud claims where there are police reports filed. It also seems that even though they are fraud claims, people still contact different authorities like ambulances, the fire department, and even the police. The fact that it seems that fraud claims contact the police less frequently than the non fraud claims may be something interesting to investigate.

<img width="731" alt="AuthoritiesContacted" src="https://user-images.githubusercontent.com/44710328/137055215-c8af2559-0e6d-41d4-8b68-49393dfbad4d.png">

By observing the number of non fraud claims given the hour of the day, there is an increase of claims during rush hour between 8:00am and 9:00am, then we see a decline before lunch time and then  an increase around lunch hour, then they decrease just to pick up again on rush hour between 4:00pm and 6:00pm. We can consider this a regular behavior for working people.

On the other hand we can see that for the claims that were frauds the number of claims decreases during rush hour between 8:00am and 9:00am, they increase before lunch time, then there is a decline during lunch time and they increase after lunch between 1:00pm and 4:00pm. Then they decrease again during rush hour after 4:00pm. It is until  after 10:00pm when both fraud and non fraud claims increase in the same direction.
This behavior may indicate that the people that commit fraud may be unemployed and go out during office hours to file the fraud claims.

<img width="708" alt="AccidentByHour" src="https://user-images.githubusercontent.com/44710328/137055316-455d3c72-9c1f-46e6-9514-feac9edea67b.png">

When we look at the auto claims by incident severity, we can see that for regular claims, the majority of the claims are considered minor damage (42%) and the second higher category will be total loss (32.4%). For the fraudulent claims, we see that the grand majority of the claims are considered major damage (67.6%), followed by minor damage (15.4%), and total loss (14.6%). This may  indicate that people that commit fraud may be inclined to  try to get a significant reward for their acts.

<img width="711" alt="AccidentSeverity" src="https://user-images.githubusercontent.com/44710328/137055430-143511b7-0e54-4a72-9146-d56d3db22945.png">

The auto claims can be classified depending on the incident type. We can see that for claims that involve multi-vehicle collision and single vehicle collision the percentage of fraud claims is higher than when claims happen when the car is parked or it is a case of vehicle theft.
![FraudIncidentType](https://user-images.githubusercontent.com/44710328/137055612-d00644d1-52ea-41dd-ae7c-d2e8b4d67b3f.png)

# MODELING
Usually fraud detection problems have imbalance data sets where there is a disproportion among the number of examples of each class of the problem. In this case the number of fraudulent transactions just represent 24.7% of the claims reported.
To try to fix this issue I oversampled by increasing the amount of these rare claims. I used a technique called SMOTE (Synthetic Minority Oversampling Technique) on the training data only.
Before creating the training and testing sets for the analysis, I normalized the numeric features and one-hot encoded the categorical ones, I grouped the accident months into the season of the year. For the feature auto year and incident hour of the day, I modified them by grouping them into less categories with the idea of adding more interpretability to the model.
We want to find a model that will help the insurance company classify their auto claims into fraud and non fraud claims.  For the purpose of this project, I tested four models and compared them based on the AUC (area under the curve) of the Precision-Recall curve for each of them. For each of the models I also wanted to see the impact of  SMOTE oversampling to determine if it was worth the use of this technique.
The models tested were:
* Random Forest.
* Naive Bayes.
* Logistic Regression.
* Feedforward neural network
Before talking about the findings for each of these models, let me explain the metric used to compare them.
I used the Precision-Recall AUC. Precision is a metric that quantifies the number of correct positive predictions made.
It is calculated as the number of true positives divided by the total number of true positives and false positives.
* ***Precision = TruePositives / (TruePositives + FalsePositives)***

The result is a value between 0.0 for no precision and 1.0 for full or perfect precision.
Recall is a metric that quantifies the number of correct positive predictions made out of all positive predictions that could have been made. It is calculated as the number of true positives divided by the total number of true positives and false negatives (e.g. it is the true positive rate).
* ***Recall = TruePositives / (TruePositives + FalseNegatives)***

The result is a value between 0.0 for no recall and 1.0 for full or perfect recall.
Both the precision and the recall are focused on the positive class (the minority class or fraud class) and are unconcerned with the true negatives (majority class or non fraud class).
A precision-recall curve (or PR Curve) is a plot of the precision (y-axis) and the recall (x-axis).
* ***PR Curve: Plot of Recall (x) vs Precision (y).***

The Precision-Recall AUC is a score that can be used as a point of comparison between different models on a binary classification problem where a score of 1.0 represents a model with perfect skill.
Now that we defined the metric used let me summarize the findings by model.
## RANDOM FOREST
I used a RandonForesClassifier from the sklearn’s library in python with 100 estimators  and entropy criterion. I called the baseline model the model that uses the imbalanced claims data and SMOTE model the one that uses the oversampled data.
We can see that the both models are overfitting and for the test data it seems that the baseline model performs better than the SMOTE model.

![V4_Insurance_Auto_Claims_fraud_detection_Citlalli_Blanchet_cell_154_output_0](https://user-images.githubusercontent.com/44710328/137056022-669247a1-b5ba-435b-a4fe-bc41b11ab174.png)


## NAIVE BAYES 

I used a Gaussian Naive Bayesian classifier from the sklearn python library. We can see that  for testing both models perform basically the same. But still they both have a low value of AUC precision-recall.


![V4_Insurance_Auto_Claims_fraud_detection_Citlalli_Blanchet_cell_172_output_0](https://user-images.githubusercontent.com/44710328/137056206-b8a717f9-3566-4a54-a6b9-0ab435dd3b44.png)

## LOGISTIC REGRESSION
For this model I used the LogisticRegression model of the sklearn python library. I wanted to test different values of the inverse regularization parameter,C , and selected the value of C that maximized the accuracy of the model.
The inverse regularization parameter  is a control variable. It is defined as C = 1/λ where λ is called the regularization parameter. The parameter λ controls the trade-off between two goals: fitting the training data well vs keeping the params small to avoid overfitting. For the different values of C tested I selected C=1 which produced an accuracy value of 0.58. We can see the different values in the following table.

C parameter | Accuracy 
------------ | -------------
0.001 | 0.521 
0.010 | 0.542 
0.10 | 0.5483 
**1.0** | **0.5841** 
10.0 | 0.5851 
100.0 | 0.556 



After selecting the inverse regularization parameter, I tested the model with the baseline dataset and the oversampled SMOTE dataset.

![V4_Insurance_Auto_Claims_fraud_detection_Citlalli_Blanchet_cell_197_output_0](https://user-images.githubusercontent.com/44710328/137058542-fc34a9ff-9e3f-4253-8adc-7a03737f13a1.png)

We can see that the SMOTE model performs better. But still we get a AUC Precision-Recall of 0.356 on the training dataset.
**FEEDFORWARD NEURAL NETWORK**
For this model I used tensorflow to model the feedforward neural network. I modeled a multilayer network with a sigmoidal function and a binary cross entropy loss function.
![V4_Insurance_Auto_Claims_fraud_detection_Citlalli_Blanchet_cell_221_output_0](https://user-images.githubusercontent.com/44710328/137058844-7255ab5b-be09-4b39-a03e-734cca9b6d2a.png)


Given the results obtained when comparing the different models studied, it seems that the model to select is the feedforward neural network. It does not overfit as much as the other models and has aAUC Precision-Recall score of 0.622.

# SUMMARY
In summary, I compared the AUC Precision-Recall scores for the SMOTE datasets and decided to select the feedforward neural network model to be used in the task of predicting if an auto insurance claim is a fraudulent claim or not.
We can see the table that summarizes the  AUC Precision-Recall scores




| **Model** | **TRAIN **
**AUC Precision-Recall scores** | **TEST**
** AUC Precision-Recall scores** | 
| --- | --- | --- |
| Random Forest | 1.0 | 0.4677 | 
| Naive Bayes | 0.7946 | 0.4980 | 
| Logistic Regression | 0.8855 | 0.3555 | 
| Feedforward neural network | 0.75 | 0.622 | 

# FUTURE IMPROVEMENTS
Some improvements to the analysis will be to perform a hyperparameter tuning on the feedforward neural network to see if we can achieve more accurate predictions.
I would also like to work on an application of a backpropagation neural network (BPNN) which I found in the literature to be used on fraud detection problems.

# CREDITS
I would like to thank my two mentors at Springboard, Eduardo Carrasco and David Lara Arango.
