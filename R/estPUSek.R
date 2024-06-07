utils::globalVariables("estPUSek:::estPUSek.data.env")

#' Menjalankan aplikasi estPUSek
#'
#' @description Menjalankan estPUSek, aplikasi berbasis shiny untuk estimasi jumlah penduduk usia sekolah dan umur 1 tahunan.
#' @details Deskripsi fitur-fitur tersedia di halaman bantuan aplikasi.
#' @param host argumen untuk \code{\link[shiny:runApp]{runApp}}. Default "0.0.0.0".
#' @param ... argumen tambahan untuk \code{\link[shiny:runApp]{runApp}}.
#' @author Ari Purwanto Sarwo Prasojo, mengadaptasi paket wppExplorer.
#' @examples
#' run.estPUSek()
#'
#' @export
run.estPUSek <- function(host=NULL, ...) {
  if(missing(host)) host <- getOption("shiny.host", "0.0.0.0")
  shiny::runApp(system.file('app', package='estPUSek'),
                host = host, ...)
}

# Hasil proyeksi ----

load.data.by.ind <- function(indicator, age=NULL) {
  indicator <- as.numeric(indicator)
  func <- ind.fun(indicator)
  do.call('data', list(name = func, envir = estPUSek.data.env))
  data <- estPUSek:::estPUSek.data.env[[func]]
  # do.call('data', list(name = func))
  # data <- .GlobalEnv[[func]]

  if(!is.null(age)){
    data <- data[data$umur %in% age,]
    data <- data %>% dplyr::group_by(kode_provinsi,tahun) %>%
      dplyr::summarise(values = sum(values)) %>%
      dplyr::ungroup()
  }

  return(data)
}

data.by.year <- function(data, year){
  data <- data[data$tahun == year,]
  return(data)
}

data.by.prov <- function(data, prov){
  data <- data[data$kode_provinsi == prov,]
  return(data)
}

data.rbind <- function(data, col, values){
  datar <- rbind(data[[values]])
  colnames(datar) <- data[[col]]
  return(datar)
}

ind.settings <- function() attr(estPUSek:::estPUSek.data.env$indicators, 'settings')
ind.fun <- function(indicator) rownames(ind.settings())[indicator]
ind.definition <- function(indicator) attr(estPUSek:::estPUSek.data.env$indicators, 'definition')[indicator]


# Custom ----

init.age5 <- function(oag, val=0){
  age <- seq(0,oag,5)
  l_age <- length(age)
  l_val <- length(val)
  if(l_val == 1){
    data <- data.frame(Jumlah=rep(val,l_age))
  }else{
    if(l_age == l_val){
      data <- data.frame(Jumlah=val)
    }else{
      return(warning('Banyaknya kelompok umur tidak sama dengan banyaknya observasi'))
    }
  }
  rownames(data) <- c(paste0(seq(0,oag-5,5),"-",seq(4,oag-1,5)),paste0(oag,"+"))
  return(data)
}

agg.sap <- function(data){
  tot <- sum(data$Jumlah)
  data <- data %>%
    dplyr::mutate(
      one = 1,
      `7-12` = ifelse(Umur %in% seq(7, 12), 1, 0),
      `13-15` = ifelse(Umur %in% seq(13, 15), 1, 0),
      `16-18` = ifelse(Umur %in% seq(16, 18), 1, 0),
      `19-23` = ifelse(Umur %in% seq(19, 23), 1, 0)
    ) %>%
    dplyr::group_by(one) %>%
    dplyr::summarise(
      `7-12` = sum(`7-12` * Jumlah),
      `13-15` = sum(`13-15` * Jumlah),
      `16-18` = sum(`16-18` * Jumlah),
      `19-23` = sum(`19-23` * Jumlah)
    ) %>%
    dplyr::ungroup() %>%
    tidyr::pivot_longer(-one,names_to='Umur',values_to='Jumlah') %>%
    dplyr::mutate(Persen = Jumlah/tot*100) %>%
    dplyr::select(-one)
  return(data)
}
