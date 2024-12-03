library(lmerTest)

#' Modeling of normal distributed outcome
#'
#' @param data_path Data path
#' @param niter Number of iterations
#' @param results_folder Folder path to save the results data frame
#' @param filename Filename format to save the results data frame
#' @return Model results dataframe
#' 
normal_model <- function(data_path, niter, results_folder, filename) {
  data <- read.csv(data_path)
  results_list <- vector("list", niter)
  
  for (i in 1:niter) {
    iter_data <- data[data$niter == i, ]
    model <- lmer(Y ~ treatment + (1 | cluster), data = iter_data)
    
    beta_estimate <- fixef(model)["treatment"]
    summary_model <- summary(model)
    beta_se <- summary_model$coefficients["treatment", "Std. Error"]
    beta_lower <- beta_estimate - 1.96 * beta_se
    beta_upper <- beta_estimate + 1.96 * beta_se
    random_effect_variance <- as.numeric(VarCorr(model)$cluster[1])
    
    results_list[[i]] <- data.frame(iter = i,
                                    beta_estimate = beta_estimate,
                                    beta_se = beta_se,
                                    beta_lower = beta_lower,
                                    beta_upper = beta_upper,
                                    random_effect_variance = random_effect_variance)
  }
  
  results <- bind_rows(results_list)
  write.csv(results, file = paste0(results_folder, filename, "_results.csv"), row.names = FALSE)
  
  return(results)
}

#' Modeling of poisson distributed outcome
#'
#' @param data_path Data path
#' @param niter Number of iterations
#' @param results_folder Folder path to save the results data frame
#' @param filename Filename format to save the results data frame
#' @return Model results dataframe
#' 
poisson_model <- function(data_path, niter, results_folder, filename) {
  data <- read.csv(data_path)
  results_list <- vector("list", niter)
  
  for (i in 1:niter) {
    iter_data <- data[data$niter == i, ]
    model <- glmer(Y ~ treatment + (1 | cluster), data = iter_data, family = poisson(link = "log"))
    
    beta_estimate <- fixef(model)["treatment"]
    summary_model <- summary(model)
    beta_se <- summary_model$coefficients["treatment", "Std. Error"]
    beta_lower <- beta_estimate - 1.96 * beta_se
    beta_upper <- beta_estimate + 1.96 * beta_se
    random_effect_variance <- as.numeric(VarCorr(model)$cluster[1])
    exp_beta_estimate <- exp(beta_estimate)
    exp_beta_lower <- exp(beta_lower)
    exp_beta_upper <- exp(beta_upper)
    
    results_list[[i]] <- data.frame(iter = i,
                                    beta_estimate = beta_estimate,
                                    beta_se = beta_se,
                                    beta_lower = beta_lower,
                                    beta_upper = beta_upper,
                                    random_effect_variance = random_effect_variance,
                                    exp_beta_estimate = exp_beta_estimate,
                                    exp_beta_lower = exp_beta_lower,
                                    exp_beta_upper = exp_beta_upper)
  }
  
  results <- bind_rows(results_list)
  write.csv(results, file = paste0(results_folder, filename, "_results.csv"), row.names = FALSE)
  
  return(results)
}

alpha = 0
beta = 5
gamma_sq = 1
sigma_sq = 1
B = 4650
niter = 10
c1 = 20
c2 = 10
G_list = c(5, 10, 15)
R_list = c(10, 20, 30)

data_folder_normal <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Data_normal/"
results_folder_normal <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Results_normal/"

for (G in G_list) {
  for (R in R_list) {
    data_path <- paste0(data_folder_normal, "Normal_", G, "_", R, "_data.csv")
    normal_model(data_path, niter, results_folder = results_folder_normal, filename = paste0("Results_normal", "_", G, "_", R))
  }
}

data_folder_poisson <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Data_poisson/"
results_folder_poisson <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Results_poisson/"

for (G in G_list) {
  for (R in R_list) {
    data_path <- paste0(data_folder_poisson, "Poisson_", G, "_", R, "_data.csv")
    poisson_model(data_path, niter, results_folder = results_folder_poisson, filename = paste0("Results_poisson", "_", G, "_", R))
  }
}