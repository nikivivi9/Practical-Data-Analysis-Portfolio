# Project 2: Influence of Baseline Characteristics on Smoking Cessation in MDD: A Study of Behavioral and Pharmacological Treatment Effects 

### Project Description

This study investigates the impact of baseline characteristics on smoking cessation outcomes in adults with Major Depressive Disorder (MDD), focusing on the effects of both behavioral and pharmacological treatments. Conducted in collaboration with Dr. George Papandonatos, this study employs a 2 × 2 factorial, randomized, placebo-controlled design to assess Behavioral Activation for Smoking Cessation (BASC) versus standard treatment (ST) and varenicline versus placebo. The goal is to identify baseline predictors of abstinence and explore how certain characteristics may moderate the effects of treatment, contributing to more effective smoking cessation interventions for individuals with MDD.

### Methods

Our sample population consists of 300 adult smokers with or previously with MDD. Patients were randomly assigned to either behavioral activation for smoking cessation (BASC) or standard behavioral treatment (ST) and either varenicline or placebo groups. That is, participants were assigned to four distinct intervention groups, including ST + placebo, ST + varenicline, BASC + placebo, and BASC + varenicline. Randomization was stratified by clinical site, sex, and level of depressive symptoms to ensure balanced representation across these factors. Follow-up data was collected at week 27 to assess smoking cessation outcomes, along with relevant baseline characteristics. Key variables include smoking abstinence status, demographic characteristics (sex, age,
income, and education), smoking behaviors (number of cigarettes per day, time to first cigarette after getting up, and nicotine dependence score), and psychiatric measures (MDD status, anhedonia score, other diagnoses, and antidepressant usage).

To analyze the impact of behavioral treatment on end-of-treatment abstinence and examine the moderating role of baseline characteristics, we selected Lasso regression as our primary model. Lasso was chosen for its ability to perform both variable selection and regularization, making it particularly suited for our study, which involves numerous baseline predictors and interaction terms. By applying an L1 penalty, Lasso shrinks less relevant coefficients to zero, effectively selecting a subset of the most influential predictors and interactions. A bootstrap with 200 iterations are performed to provide a more robust analysis.
 
### Results 

 Control for treatment and other factors, as predictors, higher nicotine dependence (higher FTCD score),
 higher and current MDD status both associate with lower likelihood of abstinence. Conversely, having faster
 nicotine metabolism (higher NMR in log scale) and identifying as Non-Hispanic White were associated with
 higher odds of abstinence, adjusting for treatment and other factors.
 Additionally, FTCD score emerged as both a predictor and moderator, with participants with higher nicotine
 dependence score showing lower odds of abstinence and experiencing an additional reduce from BASC. Menthol
 cigarette use and income level also moderated the effects of BASC, with menthol users experiencing lower
 abstinence odds and individuals with incomes more than $70,000 benefiting more from BASC. Furthermore,
 significant interaction terms with varenicline suggest that the efficacy of pharmacotherapy varies by factors
 like cigarette reward value, education, race, and age. The model evaluation using ROC and calibration plots
 reveals our model’s strong discriminative power and exhibits well-calibrated results.

### Files
- `MDD Smoking Cessation Regression Analysis.Rmd`: The Rmarkdown file of this Regression Analysis report, containing codes and analysis text.
- `MDD Smoking Cessation Regression Analysis.pdf`: The pdf file of this Exploratory Data Analysis report, including the analysis text, code results, and appendix.
- `Bootstrap.Rmd: The Rmarkdown file of the bootstrapped lasso regression, containing codes and analysis text.
- Folder `Bootstrap_Results`: Summary Table and validation plot result from bootstrapped lasso regression.
- `references.bib`: Reference list file.
- `apa-numeric-superscript.csl`: Reference Style csl.

 
### Dependencies
The following R version and packages are used in this analysis. Ensure that they are installed and loaded to successfully run the code:
- **R version**: 4.3.1 (2023-06-16)
    - **Platform**: x86_64-w64-mingw32/x64 (64-bit)
- **R Packages**:
     - tidyverse - 2.0.0
     - mice - 3.16.0
     - gt - 0.10.1
     - gtsummary - 1.7.2
     - kableExtra - 1.4.0
     - RColorBrewer - 1.1-3
     - scico - 1.5.0
     - caret - 6.0-94
     - glmnet - 4.1-8
     - pROC - 1.18.5
     - predtools - 0.0.3
     - gridExtra - 2.3
     - ggpubr - 0.6.0
     - patchwork - 1.2.0
     - e1071 - 1.7-14
     - corrplot - 0.92
     - L0Learn - 2.1.0
     - MASS - 7.3-60.0.1
     - magick - 2.8.5
     - gridExtra - 2.3
 
