library(tidyverse)

#' Simulate data of normal distributed outcome
#'
#' @param G Number of clusters
#' @param R Number of individuals in each cluster
#' @param alpha Baseline mean value
#' @param beta Treatment effect coefficient
#' @param gamma_sq Variance between clusters
#' @param sigma_sq Variance within clusters
#' @param c1 Cost for the first sample in each cluster
#' @param c2 Cost for any other samples in each cluster
#' @param B Total budget
#' @param niter Number of iterations
#' @param folder Folder path to save the results data frame
#' @param filename Filename format to save the results data frame
#' @return Simulated dataframe

simulate_data_normal <- function(G, R, alpha, beta, gamma_sq, sigma_sq, 
                                 c1, c2, B, niter, folder, filename) {
  
  cost <- G * c1 + G * (R - 1) * c2
  if (cost > B) {
    return(NULL)
  }
  
  results_list <- vector("list", niter)
  set.seed(2550)
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
                             sd = sqrt(sigma_sq))
                     })),
                     G = G,
                     R = R,
                     alpha = alpha,
                     beta = beta,
                     gamma_sq = gamma_sq,
                     sigma_sq = sigma_sq,
                     c1 = c1,
                     c2 = c2,
                     B = B,
                     niter = i,
                     total_cost = cost)
    
    results_list[[i]] <- df
  }
  
  long_df <- bind_rows(results_list)
  write.csv(long_df, paste0(folder, filename, "_data.csv"), row.names = FALSE)
  
  return(long_df)
}



#' Simulate data of poisson distributed outcome
#'
#' @param G Number of clusters
#' @param R Number of individuals in each cluster
#' @param alpha Baseline mean value
#' @param beta Treatment effect coefficient
#' @param gamma_sq Variance between clusters
#' @param c1 Cost for the first sample in each cluster
#' @param c2 Cost for any other samples in each cluster
#' @param B Total budget
#' @param niter Number of iterations
#' @param folder Folder path to save the results data frame
#' @param filename Filename format to save the results data frame
#' @return Simulated dataframe

simulate_data_poisson <- function(G, R, alpha, beta, gamma_sq,
                                  c1, c2, B, niter, folder, filename) {
  
  cost <- G * c1 + G * (R - 1) * c2
  if (cost > B) {
    return(NULL)
  }
  
  results_list <- vector("list", niter)
  set.seed(2550)
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
                     sigma_sq = sigma_sq,
                     c1 = c1,
                     c2 = c2,
                     B = B,
                     niter = i,
                     total_cost = cost)
    
    results_list[[i]] <- df
  }
  
  long_df <- bind_rows(results_list)
  write.csv(long_df, paste0(folder, filename, "_data.csv"), row.names = FALSE)
  
  return(long_df)
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

for (G in G_list) {
  for (R in R_list) {
    result_df <- simulate_data_normal(G, R, alpha, beta, gamma_sq, sigma_sq, c1, c2, B, niter = 10,
                                       folder = "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Data_normal/",
                                       filename = paste0("Normal", "_", G, "_", R))
    
  }
}

for (G in G_list) {
  for (R in R_list) {
    result_df <- simulate_data_poisson(G, R, alpha, beta, gamma_sq, c1, c2, B, niter = 10,
                                      folder = "C:/Users/yingx/OneDrive/Desktop/Fall 2024/PHP 2550/Practical-Data-Analysis-Portfolio/Project3/Data_poisson/",
                                      filename = paste0("Poisson", "_", G, "_", R))
                                      
  }
}


