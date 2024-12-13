library(tidyverse)

#' Simulate data of normal distributed outcome
#'
#' @param G Number of clusters
#' @param alpha Baseline mean value
#' @param beta Treatment effect coefficient
#' @param gamma_sq Variance between clusters
#' @param sigma_sq Variance within clusters
#' @param c1 Cost for the first sample in each cluster
#' @param c1c2_ratio ratio of first sample cost and any other sample's cost (c1/c2)
#' @param B Total budget
#' @param niter Number of iterations
#' @param folder Folder path to save the results data frame
#' @return Simulated dataframe

simulate_data_normal <- function(G, alpha, beta, gamma_sq, sigma_sq, 
                                 c1, c1c2_ratio, B, niter, folder, filename) {
  c2 <- c1 / c1c2_ratio
  cost_per_cluster <- B/G
  n_c2 <- floor((cost_per_cluster - c1)/c2)
  R <- n_c2 + 1
  
  total_cost <- G * c1 + G * (R - 1) * c2
  if (total_cost > B) {
    return(NULL)
  }
  
  results_list <- vector("list", niter)
  for (i in 1:niter) {
    repeat {
      X <- sample(c(0, 1), G, replace = TRUE)
      if (length(unique(X)) >= 2) break
    }
    
    epsilon <- rnorm(G, 0, sd = sqrt(gamma_sq))
    df <- data.frame(cluster = rep(1:G, each = R),
                     treatment = rep(X, each = R),
                     Y = unlist(lapply(1:G, function(i) {
                       rnorm(R, mean = alpha + beta * X[i] + epsilon[i], 
                             sd = sqrt(sigma_sq))})),
                     G = G,
                     R = R,
                     alpha = alpha,
                     beta = beta,
                     gamma_sq = gamma_sq,
                     sigma_sq = sigma_sq,
                     c1 = c1,
                     c2 = c2,
                     c1c2_ratio = c1c2_ratio,
                     B = B,
                     niter = i,
                     total_cost = total_cost)
    
    results_list[[i]] <- df
  }
  
  long_df <- bind_rows(results_list)
  write.csv(long_df, paste0(folder, filename), row.names = FALSE)
  
  return(long_df)
}



#' Simulate data of poisson distributed outcome
#'
#' @param G Number of clusters
#' @param alpha Baseline mean value
#' @param beta Treatment effect coefficient
#' @param gamma_sq Variance between clusters
#' @param c1 Cost for the first sample in each cluster
#' @param c1c2_ratio ratio of first sample cost and any other sample's cost (c1/c2)
#' @param B Total budget
#' @param niter Number of iterations
#' @param folder Folder path to save the results data frame
#' @param format to store the results
#' @return Simulated dataframe

simulate_data_poisson <- function(G, alpha, beta, gamma_sq,
                                  c1, c1c2_ratio, B, niter, folder, filename) {
  
  c2 <- c1 / c1c2_ratio
  cost_per_cluster <- B/G
  n_c2 <- floor((cost_per_cluster - c1)/c2)
  R <- n_c2 + 1
  
  total_cost <- G * c1 + G * (R - 1) * c2
  if (total_cost > B) {
    return(NULL)
  }
  
  results_list <- vector("list", niter)
  for (i in 1:niter) {
    repeat {
      X <- sample(c(0, 1), G, replace = TRUE)
      if (length(unique(X)) >= 2) break
    }
    epsilon <- rnorm(G, 0, sd = sqrt(gamma_sq))
    df <- data.frame(cluster = rep(1:G, each = R),
                     treatment = rep(X, each = R),
                     Y = unlist(lapply(1:G, function(i) {
                       rpois(R, lambda = exp(alpha + beta * X[i] + epsilon[i]))
                     })),
                     G = G,
                     R = R,
                     alpha = alpha,
                     beta = beta,
                     gamma_sq = gamma_sq,
                     c1 = c1,
                     c2 = c2,
                     c1c2_ratio = c1c2_ratio,
                     B = B,
                     niter = i,
                     total_cost = total_cost)
    
    results_list[[i]] <- df
  }
  
  long_df <- bind_rows(results_list)
  write.csv(long_df, paste0(folder, filename), row.names = FALSE)
  
  return(long_df)
}

# Normal Distributed Y

## Vary G, R, c1/c2
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

# Finding optimal design
set.seed(2550)

for (G in G_list) {
  for (ratio in c1c2_ratio_list) {
    result_df <- simulate_data_normal(G, alpha, beta, gamma_sq, sigma_sq, c1, ratio, B, niter,
                                      folder = data_folder_normal,
                                      filename = paste0("Normal", "_", G, "_", ratio, "_", alpha,
                                                         "_", beta, "_", gamma_sq, "_", sigma_sq,
                                                         "_data.csv"))
  }
}


## Vary gamma_sq

alpha <- 0
beta <- 1.5
sigma_sq <- 1
gamma_sq_list <- c(0.111, 1, 9)
B <- 10000
G <- 30
R <- 79
niter <- 100
c1 <- 20
c1c2_ratio <- 5

for (gamma_sq in gamma_sq_list) {
  result_df <- simulate_data_normal(G, alpha, beta, gamma_sq, sigma_sq, c1, c1c2_ratio, B, niter,
                                    folder = data_folder_normal, 
                                    filename = paste0("Normal", "_", G, "_", c1c2_ratio, "_", alpha, 
                                                      "_", beta, "_", gamma_sq, "_", sigma_sq,
                                                      "_data.csv"))
}


## Vary sigma_sq

alpha <- 0
beta <- 1.5
sigma_sq_list <- c(9, 1, 0.111)
gamma_sq <- 1
B <- 10000
G <- 30
R <- 79
niter <- 100
c1 <- 20
c1c2_ratio <- 5

for (sigma_sq in sigma_sq_list) {
  result_df <- simulate_data_normal(G, alpha, beta, gamma_sq, sigma_sq, c1, c1c2_ratio, B, niter,
                                    folder = data_folder_normal, 
                                    filename = paste0("Normal", "_", G, "_", c1c2_ratio, "_", alpha, 
                                                      "_", beta, "_", gamma_sq, "_", sigma_sq,
                                                      "_data.csv"))
}


# Poisson Distributed Y

## vary G, R, c1/c2
set.seed(2550)
alpha <- 0
beta <- 1.5
gamma_sq <- 1
B <- 10000
niter <- 100
c1 <- 20
c1c2_ratio_list <- c(2, 5, 10, 20)
G_list = c(5, 10, 15, 20, 25, 30)
data_folder_poisson <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Data_poisson/"
results_folder_poisson <- "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Results_poisson/"

for (G in G_list) {
  for (ratio in c1c2_ratio_list) {
    result_df <- simulate_data_poisson(G, alpha, beta, gamma_sq, c1, ratio, B, niter,
                                       folder = data_folder_poisson,
                                       filename = paste0("Poisson", "_", G, "_", ratio, "_", alpha, 
                                                         "_", beta, "_", gamma_sq, "_data.csv"))
  }
}

## Vary gamma_sq

alpha <- 0
beta <- 1.5
B <- 10000
gamma_sq_list <- c(0.111, 1, 10)
G <- 30
R <- 314
niter <- 100
c1 <- 20
c1c2_ratio <- 20

for (gamma_sq in gamma_sq_list) {
  result_df <- simulate_data_poisson(G, alpha, beta, gamma_sq, c1, c1c2_ratio, B, niter,
                                    folder = data_folder_poisson, 
                                    filename = paste0("Poisson", "_", G, "_", c1c2_ratio, "_", alpha, 
                                                      "_", beta, "_", gamma_sq, "_data.csv"))
}

## Vary alpha

alpha_list <- seq(0, 10, 2)
beta <- 1.5
B <- 10000
gamma_sq <- 1
G <- 30
R <- 314
niter <- 100
c1 <- 20
c1c2_ratio <- 20

for (alpha in alpha_list) {
  result_df <- simulate_data_poisson(G, alpha, beta, gamma_sq, c1, c1c2_ratio, B, niter,
                                     folder = data_folder_poisson, 
                                     filename = paste0("Poisson", "_", G, "_", c1c2_ratio, "_", alpha, 
                                                       "_", beta, "_", gamma_sq, "_data.csv"))
}

## vary beta

alpha <- 0
beta_list <- seq(1, 5, 1)
B <- 10000
gamma_sq <- 2
G <- 30
R <- 79
niter <- 100
c1 <- 20
c1c2_ratio <- 5

for (beta in beta_list) {
  result_df <- simulate_data_poisson(G, alpha, beta, gamma_sq, c1, c1c2_ratio, B, niter,
                                     folder = data_folder_poisson, 
                                     filename = paste0("Poisson", "_", G, "_", c1c2_ratio, "_", alpha, 
                                                       "_", beta, "_", gamma_sq, "_data.csv"))
}



