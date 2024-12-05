
#' Modeling of normal distributed outcome
#'
#' @param data_path Data path
#' @param niter Number of iterations
#' @param results_folder Folder path to save the results data frame
#' @param filename Filename format to save the results data frame
#' @return Model results dataframe
#' 
normal_model <- function(data_path, beta, niter, results_folder, filename) {
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
  
  coverage <- mean(results$beta_lower <= beta & results$beta_upper >= beta, na.rm = TRUE)
  summary_metrics <- data.frame(G = mean(data$G), R = mean(data$R), c1 = mean(data$c1), 
                                c2 = mean(data$c2), c1c2_ratio = mean(data$c1c2_ratio),
                                alpha = mean(data$alpha), beta = beta, 
                                gamma_sq = mean(data$gamma_sq), sigma_sq = mean(data$sigma_sq),
                                total_cost = mean(data$total_cost),
                                beta_estimate = mean(results$beta_estimate, na.rm = TRUE),
                                beta_variance = var(results$beta_estimate, na.rm = TRUE),
                                beta_bias = abs(mean(results$beta_estimate, na.rm = TRUE) - beta),
                                mse = mean((results$beta_estimate - beta)^2, na.rm = TRUE),
                                coverage = coverage * 100)
  
  write.csv(results, file = paste0(results_folder, filename), row.names = FALSE)
  write.csv(summary_metrics, file = paste0(results_folder, "Summary_", filename), row.names = FALSE)
  
  return(summary_metrics)
}

#' Modeling of poisson distributed outcome
#'
#' @param data_path Data path
#' @param niter Number of iterations
#' @param results_folder Folder path to save the results data frame
#' @param filename Filename format to save the results data frame
#' @return Model results dataframe
#' 
poisson_model <- function(data_path, beta, niter, results_folder, filename) {
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
    
    results_list[[i]] <- data.frame(iter = i,
                                    beta_estimate = beta_estimate,
                                    beta_se = beta_se,
                                    beta_lower = beta_lower,
                                    beta_upper = beta_upper,
                                    random_effect_variance = random_effect_variance)
  }
  
  results <- bind_rows(results_list)
  
  coverage <- mean(results$beta_lower <= beta & results$beta_upper >= beta, na.rm = TRUE)
  summary_metrics <- data.frame(G = mean(data$G), R = mean(data$R), c1 = mean(data$c1), 
                                c2 = mean(data$c2), c1c2_ratio = mean(data$c1c2_ratio),
                                alpha = mean(data$alpha), beta = beta, 
                                gamma_sq = mean(data$gamma_sq), total_cost = mean(data$total_cost),
                                beta_estimate = mean(results$beta_estimate, na.rm = TRUE),
                                beta_variance = var(results$beta_estimate, na.rm = TRUE),
                                beta_bias = abs(mean(results$beta_estimate, na.rm = TRUE) - beta),
                                mse = mean((results$beta_estimate - beta)^2, na.rm = TRUE),
                                coverage = coverage * 100)
  
  write.csv(results, file = paste0(results_folder, filename), row.names = FALSE)
  write.csv(summary_metrics, file = paste0(results_folder, "Summary_", filename, ".csv"), row.names = FALSE)
  
  return(summary_metrics)
}

# Vary G, R, c1/c2
set.seed(2550)
alpha <- 0
beta <- 1.5
gamma_sq <- 1
sigma_sq <- 1
B <- 10000
niter <- 100
c1 <- 20
c1c2_ratio_list <- c(2, 5, 10, 20)
G_list = c(5, 10, 15, 20, 25, 30)
data_folder_normal <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Data_normal/"
results_folder_normal <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Results_normal/"
table_result_path <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Table Results/"

 summary_metrics_df <- data.frame()
 for (G in G_list) {
   for (ratio in c1c2_ratio_list) {
     c2 <- c1 / ratio
     cost_per_cluster <- B/G
     n_c2 <- floor((cost_per_cluster - c1)/c2)
     R <- n_c2 + 1
     data_path <- paste0(data_folder_normal, "Normal", "_", G, "_", ratio, "_",
                         alpha, "_", beta, "_", gamma_sq, "_", sigma_sq, "_data.csv")
     summary_metrics <- normal_model(data_path, beta, niter, results_folder = results_folder_normal,
                                     filename = paste0("Results_normal", "_", G, "_", ratio, "_",
                                                       alpha, "_", beta, "_", gamma_sq, "_", sigma_sq, ".csv"))
     summary_metrics_df <- rbind(summary_metrics_df, summary_metrics)
  }
}
write.csv(summary_metrics_df, file = paste0(table_result_path, "summary_metrics_df", ".csv"), row.names = FALSE)

## Vary gamma_sq
alpha <- 0
beta <- 1.5
sigma_sq <- 1
B <- 10000
G <- 30
R <- 79
niter <- 100
c1 <- 20
c1c2_ratio <- 5

gamma_sq_list <- seq(0.5, 3, by = 0.5)
summary_metrics_df_gamma <- data.frame()
for (gamma_sq in gamma_sq_list) {
  c2 <- c1 / c1c2_ratio
  cost_per_cluster <- B/G
  n_c2 <- floor((cost_per_cluster - c1)/c2)
  R <- n_c2 + 1
  data_path <- paste0(data_folder_normal, "Normal", "_", G, "_", c1c2_ratio, "_", 
                      alpha, "_", beta, "_", gamma_sq, "_", sigma_sq, "_data.csv")
  summary_metrics <- normal_model(data_path, beta, niter, results_folder = results_folder_normal,
                                  filename = paste0("Results_normal", "_", G, "_", c1c2_ratio, "_",
                                                    alpha, "_", beta, "_", gamma_sq, "_", sigma_sq, ".csv"))
  summary_metrics_df_gamma <- rbind(summary_metrics_df_gamma, summary_metrics)
}

write.csv(summary_metrics_df_gamma, file = paste0(table_result_path, "summary_metrics_df_gamma", ".csv"), 
          row.names = FALSE)

## Vary sigma_sq

alpha <- 0
beta <- 1.5
gamma_sq <- 1
B <- 10000
G <- 30
R <- 79
niter <- 100
c1 <- 20
c1c2_ratio <- 5


sigma_sq_list <- seq(0.5, 3, by = 0.5)
summary_metrics_df_sigma <- data.frame()
for (sigma_sq in sigma_sq_list) {

  c2 <- c1 / c1c2_ratio
  cost_per_cluster <- B/G
  n_c2 <- floor((cost_per_cluster - c1)/c2)
  R <- n_c2 + 1
  data_path <- paste0(data_folder_normal, "Normal", "_", G, "_", c1c2_ratio, "_", 
                      alpha, "_", beta, "_", gamma_sq, "_", sigma_sq, "_data.csv")
  summary_metrics <- normal_model(data_path, beta, niter, results_folder = results_folder_normal,
                                  filename = paste0("Results_normal", "_", G, "_", c1c2_ratio, "_",
                                                    alpha, "_", beta, "_", gamma_sq, "_", sigma_sq, ".csv"))
  summary_metrics_df_sigma <- rbind(summary_metrics_df_sigma, summary_metrics)
}

write.csv(summary_metrics_df_sigma, file = paste0(table_result_path, "summary_metrics_df_sigma", ".csv"), 
          row.names = FALSE)

# Poisson Distributed Y

## Vary G, R, and c1/c2

alpha <- 0
beta <- 1.5
gamma_sq <- 1
sigma_sq <- 1
B <- 10000
niter <- 100
c1 <- 20
c1c2_ratio_list <- c(2, 5, 10, 20)
G_list = c(5, 10, 15, 20, 25, 30)
data_folder_poisson <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Data_poisson/"
results_folder_poisson <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Results_poisson/"

summary_metrics_df_poisson <- data.frame()
for (G in G_list) {
  for (ratio in c1c2_ratio_list) {
    
    c2 <- c1 / ratio
    cost_per_cluster <- B/G
    n_c2 <- floor((cost_per_cluster - c1)/c2)
    R <- n_c2 + 1
    data_path <- paste0(data_folder_poisson, "Poisson", "_", G, "_", ratio, "_", 
                        alpha, "_", beta, "_", gamma_sq, "_data.csv")
    summary_metrics <- poisson_model(data_path, beta, niter, results_folder = results_folder_poisson,
                                     filename = paste0("Results_poisson", "_", G, "_", ratio, "_",
                                                       alpha, "_", beta, "_", gamma_sq, ".csv"))
    summary_metrics_df_poisson <- rbind(summary_metrics_df_poisson, summary_metrics)
  }
}

write.csv(summary_metrics_df_poisson, file = paste0(table_result_path, "summary_metrics_df_poisson", ".csv"), 
          row.names = FALSE)

## Vary gamma_sq

alpha <- 0
beta <- 1.5
B <- 10000
gamma_sq_list <- seq(0.5, 3, by = 0.5)
G <- 30
R <- 79
niter <- 100
c1 <- 20
c1c2_ratio <- 5

summary_metrics_df_poisson_gamma <- data.frame()
for (gamma_sq in gamma_sq_list) {
  
  c2 <- c1 / c1c2_ratio
  cost_per_cluster <- B/G
  n_c2 <- floor((cost_per_cluster - c1)/c2)
  R <- n_c2 + 1
  data_path <- paste0(data_folder_poisson, "Poisson", "_", G, "_", c1c2_ratio, "_", 
                      alpha, "_", beta, "_", gamma_sq, "_data.csv")
  summary_metrics <- poisson_model(data_path, beta, niter, results_folder = results_folder_poisson,
                                   filename = paste0("Results_poisson", "_", G, "_", c1c2_ratio, "_",
                                                     alpha, "_", beta, "_", gamma_sq, ".csv"))
  summary_metrics_df_poisson_gamma <- rbind(summary_metrics_df_poisson_gamma, summary_metrics)
}

write.csv(summary_metrics_df_poisson_gamma, 
          file = paste0(table_result_path, "summary_metrics_df_poisson_gamma", ".csv"), 
          row.names = FALSE)

## Vary alpha

alpha_list <- seq(-3, 3, 1)
beta <- 1.5
B <- 10000
gamma_sq <- 1
G <- 30
R <- 79
niter <- 100
c1 <- 20
c1c2_ratio <- 5

summary_metrics_df_poisson_alpha <- data.frame()
for (alpha in alpha_list) {
  
  c2 <- c1 / c1c2_ratio
  cost_per_cluster <- B/G
  n_c2 <- floor((cost_per_cluster - c1)/c2)
  R <- n_c2 + 1
  data_path <- paste0(data_folder_poisson, "Poisson", "_", G, "_", c1c2_ratio, "_", 
                      alpha, "_", beta, "_", gamma_sq, "_data.csv")
  summary_metrics <- poisson_model(data_path, beta, niter, results_folder = results_folder_poisson,
                                   filename = paste0("Results_poisson", "_", G, "_", c1c2_ratio, "_",
                                                     alpha, "_", beta, "_", gamma_sq, ".csv"))
  summary_metrics_df_poisson_alpha <- rbind(summary_metrics_df_poisson_alpha, summary_metrics)
}

write.csv(summary_metrics_df_poisson_alpha, 
          file = paste0(table_result_path, "summary_metrics_df_poisson_alpha", ".csv"), 
          row.names = FALSE)

## vary beta

alpha <- 0
beta_list <- c(-3, -2, -1, 1, 2, 3)
B <- 10000
gamma_sq <- 1
G <- 30
R <- 79
niter <- 100
c1 <- 20
c1c2_ratio <- 5

summary_metrics_df_poisson_beta <- data.frame()
for (beta in beta_list) {
  
  c2 <- c1 / c1c2_ratio
  cost_per_cluster <- B/G
  n_c2 <- floor((cost_per_cluster - c1)/c2)
  R <- n_c2 + 1
  data_path <- paste0(data_folder_poisson, "Poisson", "_", G, "_", c1c2_ratio, "_", 
                      alpha, "_", beta, "_", gamma_sq, "_data.csv")
  summary_metrics <- poisson_model(data_path, beta, niter, results_folder = results_folder_poisson,
                                   filename = paste0("Results_poisson", "_", G, "_", c1c2_ratio, "_",
                                                     alpha, "_", beta, "_", gamma_sq, ".csv"))
  summary_metrics_df_poisson_beta <- rbind(summary_metrics_df_poisson_beta, summary_metrics)
}

write.csv(summary_metrics_df_poisson_beta, 
          file = paste0(table_result_path, "summary_metrics_df_poisson_beta", ".csv"), 
          row.names = FALSE)

