
## A Simulation Study of Optimal Design Strategies for Cluster Randomized Trials with Budgetary Limitations

### Project Description

This study, conducted in collaboration with Dr.Zhijin Wu, aims to explore optimal experimental design under certain budget constraint to maximize the precision of the treatment effect estimation, specifically focusing on how varying parameters such as sampling costs, between- and within-cluster variability, and underlying outcome distributions impact the precision of treatment effect estimates. By employing a comprehensive simulation framework, we will investigate the trade-offs between the number of clusters and the number of observations per cluster. We consider scenarios with normally distributed outcomes and extend the analysis to Poisson-distributed outcomes, reflecting a range of potential real-world application and providing more applicable insights for designing efficient and cost-effective CRTs.

### Methods

Using the ADEMP framework, we design a comprehensive simulation study to evaluate variouscombinations of G, R, and cost ratio (c1/c2) under a fixed budget of $10,000. Performance metrics, including variance, bias, mean squared error (MSE), and coverage of the treatment effect estimate (β), were assessed for 100 iterations per scenario. We also examined the impact of underlying data generation parameters on model precision.

 
### Results 

For both outcome types, increasing the number of clusters improved precision by reducing the variance of treatment effect estimates, particularly for smaller G. Optimal designs included G = 30, R = 79, and c1/c2 = 5 for normally distributed outcomes, and G = 30, R = 314, and c1/c2 = 20 for Poisson outcomes. Higher between-cluster variance γ2 were associated with increased variance and reduced coverage for both cases, indicating lower precision in treatment effect estimates. Moreover, for Poisson-distributed outcomes, a higher baseline mean also increased variance and lowered coverage.

### Folders
- `Data_normal:` Simulated normally distributed outcome data
- `Data_poisson:` Simulated Poisson-distributed outcome data
- `Results_normal:` Model results and performance metrics for normally distributed outcome data
- `Results_poisson:` Model results and performance metrics for Poisson-distributed outcome data
- `R:` R script for data simulation and model experiment functions
- `Report:` The Rmarkdown and pdf version of this simulation study's report
- `Table Results:` Combined full table results from the model

### Dependencies
The following R version and packages are used in this analysis. Ensure that they are installed and loaded to successfully run the code:
- **R version**: 4.3.1 (2023-06-16)
    - **Platform**: x86_64-w64-mingw32/x64 (64-bit)
- **R Packages**:
     - tidyverse - 2.0.0
     - kableExtra - 1.4.0
     - ggpubr - 0.6.0
     - lmerTest - 3.1-3
     - ggplot2 - 3.5.1
     - lme4 - 1.1-35.1

