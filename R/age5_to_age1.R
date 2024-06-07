#' Konversi jumlah penduduk umur 5 tahunan ke 1 tahunan
#'
#' @description Fungsi untuk memecah jumlah penduduk umur 5 tahunan menjadi 1 tahunan.
#' @details Pemecahan jumlah penduduk umur 5 tahunan menjadi 1 tahunan dengan menggunakan koefisien sprague.
#' @param oag suatu numerik/angka untuk kelompok umur terbuka, misal 80 adalah untuk 80+
#' @param value vektor numerik untuk jumlah penduduk 5 tahunan
#' @references
#' Siegel Jacob S, Swanson David A (eds.) (2004). The Methods and Materials of Demography, 2 edition. Elsevier Academic Press, California, USA, San Diego, USA
#' Sprague, T. B. (1880). Explanation ov a New Formula for Interpolation. Journal of the Institute of Actuaries and Assurance Magazine, 22(4), 270–285.
#' Riffe T, Aburto J, Kashnitsky I, Alexander M, Pascariu M, Hertog S, Fennell S (2023). _DemoTools: Standardize, Evaluate, and Adjust Demographic Data_. R package version 01.13.80.
#' @examples
#' # library(dplyr)
#' # library(magrittr)
#' # library(estPUSek)
#' #
#' # data(pop_age1_Tot)
#' #
#' # menghitung/agregasi jumlah penduduk umur5 5 tahunan
#' # df <- pop_age1_Tot %>%
#' #   filter(kode_provinsi == 0, tahun == 2020) #ambil untuk Indonesia, tahun 2020
#' # pop_age5 <- df %>%
#' #   mutate(umur5 = cut(umur,c(seq(0,100, by=5)), include.lowest = TRUE,
#' #                     right = FALSE, labels = FALSE),
#' #          umur5 = ifelse(umur5 > 17, 17, umur5),
#' #          umur5 = factor(umur5, labels=seq(0,80,5))
#' #   ) %>%
#' #   group_by(umur5) %>%
#' #   summarise(Jumlah = sum(values)) %>%
#' #   ungroup()
#' #
#' # estimasi jumlah penduduk umur 1 tahunan
#' # pop_age1_est <- age5_to_age1(oag=80,pop_age5$Jumlah)
#' #
#' # sandingan
#' # cbind(df$values, pop_age1_est)
#'
#' @export
age5_to_age1 <- function(oag, value){

  # Adapted from graduate_sprague function from DemoTools package

  # Age5 <- age_lower
  Age5 <- seq(0,oag,5)
  Age1 <- min(Age5):max(Age5)

  # sprague coef matrix ----
  # m: kolom, n: baris untuk mambentuk matriks multiplier
  m <- length(value) #sebanyak umur
  #n <- m * 5 - ifelse(OAG, 4, 0) #banyak umur 1 tahunan, OAG - 4: terbuka
  n <- m*5 - 4

  # MP <- m - ifelse(OAG, 5, 4) #last panel 2 (10), MP*5 + 10 -> batas last middle
  MP <- m - 5

  g1g2 <- matrix(c(0.3616, -0.2768, 0.1488, -0.0336, 0, 0.264,
                   -0.096, 0.04, -0.008, 0, 0.184, 0.04, -0.032, 0.008,
                   0, 0.12, 0.136, -0.072, 0.016, 0, 0.0704, 0.1968, -0.0848,
                   0.0176, 0, 0.0336, 0.2272, -0.0752, 0.0144, 0, 0.008,
                   0.232, -0.048, 0.008, 0, -0.008, 0.216, -0.008, 0, 0,
                   -0.016, 0.184, 0.04, -0.008, 0, -0.0176, 0.1408, 0.0912,
                   -0.0144, 0), nrow = 10, ncol = 5, byrow = TRUE)
  g3 <- matrix(c(-0.0128, 0.0848, 0.1504, -0.024, 0.0016,
                 -0.0016, 0.0144, 0.2224, -0.0416, 0.0064, 0.0064, -0.0336,
                 0.2544, -0.0336, 0.0064, 0.0064, -0.0416, 0.2224, 0.0144,
                 -0.0016, 0.0016, -0.024, 0.1504, 0.0848, -0.0128), 5,
               5, byrow = TRUE)
  g4g5 <- matrix(c(0, -0.0144, 0.0912, 0.1408, -0.0176, 0,
                   -0.008, 0.04, 0.184, -0.016, 0, 0, -0.008, 0.216, -0.008,
                   0, 0.008, -0.048, 0.232, 0.008, 0, 0.0144, -0.0752,
                   0.2272, 0.0336, 0, 0.0176, -0.0848, 0.1968, 0.0704,
                   0, 0.016, -0.072, 0.136, 0.12, 0, 0.008, -0.032, 0.04,
                   0.184, 0, -0.008, 0.04, -0.096, 0.264, 0, -0.0336, 0.1488,
                   -0.2768, 0.3616), nrow = 10, ncol = 5, byrow = TRUE)
  coef_mat <- matrix(0, nrow = n, ncol = m)

  # first panel
  coef_mat[1:10, 1:5] <- g1g2
  rowpos <- matrix(11:((MP * 5) + 10), ncol = 5, byrow = TRUE)
  colpos <- row(rowpos) + col(rowpos) - 1

  # middle panel
  for (i in (1:MP)) {
    coef_mat[rowpos[i, ], colpos[i, ]] <- g3
  }

  # last panel
  # fr <- nrow(coef_mat) - ifelse(OAG, 10, 9)
  fr <- nrow(coef_mat) - 10
  lr <- fr + 9
  # fc <- ncol(coef_mat) - ifelse(OAG, 5, 4)
  fc <- ncol(coef_mat) - 5
  lc <- fc + 4
  coef_mat[fr:lr, fc:lc] <- g4g5
  coef_mat[nrow(coef_mat), ncol(coef_mat)] <- 1 #OAG set as 1


  # interp ----
  pop5 <- value
  pop1 <- coef_mat %*% pop5
  dim(pop1) <- NULL
  names(pop1) <- paste0(Age1)
  l <- length(pop1)
  names(pop1)[l] <- paste0(max(Age5),'+')
  return(pop1)
}
