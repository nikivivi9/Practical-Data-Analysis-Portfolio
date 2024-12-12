# Practical Data Analysis Portfolio


## Project 1: An Exploratory Data Analysis on Environmental Condition and Marathon Performance

### Project Description
This project a collaboration with Dr. Brett Romano Ely and Dr. Matthew Ely from the Department of Health Sciences at Providence College, aims to analyze the impact of environmental conditions on marathon performance, focusing on the interaction between age, gender, and weather-related factors. Using a dataset collected from five major U.S. marathons—Boston, Chicago, New York City, Twin Cities, and Grandma’s over a period of 15-20 years, the study investigates how variables such as Wet Bulb Globe Temperature (WBGT), solar radiation, relative humidity, wind speed, and air quality influence marathon runners' performance.

The performance outcome is measured as the percentage deviation from the course record (%CR), and the analysis is stratified by age and gender. The project also incorporates a new classification of age groups to better reflect the distribution of marathon participants. Through exploratory data analysis and statistical modeling, the project explores how environmental conditions impact performance differently across age groups and genders, with a particular focus on understanding the sensitivity of younger and older runners to these conditions.

### Methods
This report is a collaboration with Dr. Brett Romano Ely and Dr. Matthew Ely from the Department of Health Sciences at Providence College, which explores how environmental conditions, age, and sex would influence runner’s performance in this long-distance race. Their prior research found that warmer temperature leads to decline in performance in marathon races, and this decline in endurance performance varies significantly between females and males. Moreover, older adults face more thermoregulatory challenges during exercise, which further exacerbate performance declines under warmer temperature. This study aims to build on previous findings, providing deeper insight on the following aims through exploratory data analysis and statistical modeling:

- Aim 1: Examine effects of increasing age on marathon performance in men and women.l
- Aim 2: Explore the impact of environmental conditions on marathon performance, and whether the impact differs across age and gender.
- Aim 3: Identify the weather parameters (WBGT, Flag conditions, temperature, etc) that have the largest impact on marathon performance.

### Results

Through exploratory data analysis and statistical modeling, we concludes that age plays a significant role in runner's performance. Highest, Upper-mid, and younger, aged runners perform worse, especially for senior in the highest age group. Moreover, male runners show more sensitivity to age change compared to female runners, with a steeper decline in performance as age increases.

Our linear model reinforces our earlier findings about age, showing that both age and its quadratic term have significant effects, indicating a nonlinear relationship where performance generally declines with age. Males, with a negative coefficient estimate, perform better than females. Among weather parameters, WBGT has the most substantial impact on marathon performance, while other weather variables show either marginal significance or no significance. Notably, the influence of WBGT, humidity, wind speed, and solar radiation on performance varies across age, as evidenced by significant interactions between age and these weather variables. The full report can be found [here](Project1/Report/Project-1-Codebook.pdf).

![](image/coef_results.png)

### Files
- Folder `Report`:
     - `Project 1 codebook.rmd`: The Rmarkdown file of this Exploratory Data Analysis report, containing codes and analysis text.
     - `Project 1 codebook.pdf`: The pdf file of this Exploratory Data Analysis report, including the analysis text, code results, and appendix. 
 

### Dependencies

The following R version and packages are used in this analysis. Ensure that they are installed and loaded to successfully run the code:
- **R version**: 4.3.1 (2023-06-16)
    - **Platform**: x86_64-w64-mingw32/x64 (64-bit)

- **R Packages**: 
    - tidyverse - 2.0.0
    - ggplot2 - 3.5.1
    - visdat - 0.6.0
    - gtsummary - 1.7.2
    - kableExtra - 1.4.0
    - ggpubr - 0.6.0
    - gt - 0.10.1
    - car - 3.1-2
    - lme4 - 1.1-35.1
    - lmerTest - 3.1-3
    - corrplot - 0.92
    - broom.mixed_0.2.9.5

