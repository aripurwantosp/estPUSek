utils::globalVariables('estPUSek.data.env')

# Hasil proyeksi ----

indicator.list <- function(){
    ind.names <- c(
      'Jumlah penduduk umur 1 tahunan: total',
      'Jumlah penduduk umur 1 tahunan: laki-laki',
      'Jumlah penduduk umur 1 tahunan: perempuan',
      'Jumlah penduduk umur sekolah: total',
      'Jumlah penduduk umur sekolah: laki-laki',
      'Jumlah penduduk umur sekolah: perempuan',
      'Pertumbuhan tahunan penduduk umur sekolah: total',
      'Pertumbuhan tahunan penduduk umur sekolah: laki-laki',
      'Pertumbuhan tahunan penduduk umur sekolah: perempuan',
      'Pertumbuhan 5 tahunan penduduk umur sekolah: total',
      'Pertumbuhan 5 tahunan penduduk umur sekolah: laki-laki',
      'Pertumbuhan 5 tahunan penduduk umur sekolah: perempuan'
    )

    ind.def <- c(
      'Jumlah penduduk umur 1 tahunan: total (dalam ribuan)',
      'Jumlah penduduk umur 1 tahunan: laki-laki (dalam ribuan)',
      'Jumlah penduduk umur 1 tahunan: perempuan (dalam ribuan)',
      'Jumlah penduduk umur sekolah: total (dalam ribuan)',
      'Jumlah penduduk umur sekolah: laki-laki',
      'Jumlah penduduk umur sekolah: perempuan',
      '(P_t-P_{t-1})/P_{t-1} penduduk umur sekolah: total',
      '(P_t-P_{t-1})/P_{t-1} penduduk umur sekolah: laki-laki',
      '(P_t-P_{t-1})/P_{t-1} penduduk umur sekolah: perempuan',
      '(P_t-P_{t-5})/P_{t-5} penduduk umur sekolah: total',
      '(P_t-P_{t-1})/P_{t-5} penduduk umur sekolah: laki-laki',
      '(P_t-P_{t-1})/P_{t-5} penduduk umur sekolah: perempuan'
    )

    func <- c(
      'pop_age1_Tot',
      'pop_age1_L',
      'pop_age1_P',
      'pop_sap_Tot',
      'pop_sap_L',
      'pop_sap_P',
      'growth_sap_Tot',
      'growth_sap_L',
      'growth_sap_P',
      'growth5_sap_Tot',
      'growth5_sap_L',
      'growth5_sap_P'
    )

    l <- length(ind.names)
    ini <- rep(FALSE, l)
    ind.df <- data.frame(
      has.neg.val = ini,
      has.struct = ini
    )

    rownames(ind.df) <- func
    ind.df[7:12, 'has.neg.val'] <- TRUE
    ind.df[1:3, 'has.struct'] <- TRUE

    structure(
      1:length(ind.names),
      names = ind.names,
      definition = ind.def,
      func = func,
      settings = ind.df
    )
}

assign('estPUSek.data.env', new.env(), envir=parent.env(environment())
       #envir = .GlobalEnv
)
data('prov_code', envir=estPUSek.data.env)
estPUSek.data.env$indicators <- indicator.list()


# Custom ----

estPUSek.data.env$list.input.mode <-
  structure(c(1,2),names=c('Manual','Input file'))

# estPUSek.data.env$list.interp.method <-
#   structure(c(1,2,3),names=c('sprague','beers(ord)','beers(mod)'))

estPUSek.data.env$list.oag <-
  structure(seq(65,100,5),names=paste0(seq(65,100,5),'+'))
