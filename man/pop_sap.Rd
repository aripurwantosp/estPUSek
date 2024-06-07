\name{pop_sap}
\alias{pop_sap_Tot}
\alias{pop_sap_L}
\alias{pop_sap_P}
\alias{pop_sap}

\docType{data}
\title{
Estimasi Jumlah Penduduk Umur Sekolah
}
\description{
Jumlah penduduk umur sekolah berdasarkan Hasil Proyeksi Penduduk Indonesia 2020-2050 berdasarkan hasil Sensus Penduduk (SP) 2020. Total (\code{pop_sap_Tot}), Laki-laki (\code{pop_sap_L}), Perempuan (\code{pop_sap_P}).
}
\usage{
data(pop_sap_Tot)
data(pop_sap_L)
data(pop_sap_P)
}
\format{
  Data frames atau tibble dengan variabel sebagai berikut:
  \describe{
    \item{\code{kode_provinsi}}{Kode provinsi.}
    \item{\code{tahun}}{Tahun.}
    \item{\code{umur}}{Umur sekolah, factor: 7-12, 13-15, 16-18, 19-23.}
    \item{\code{values}}{Jumlah (dalam ribuan).}
  }
}

\source{
 Hasil estimasi dengan menggunakan kofisien sprague dari jumlah penduduk umur 5 tahunan berdasarkan Hasil Proyeksi Penduduk Indonesia 2020-2050.
 }

 \references{
 Kementerian PPN/Bappenas, Badan Pusat Statistik, BKKBN, Kementerian Kesehatan, & UNFPA. (2023). Proyeksi Penduduk Indonesia 2020-2050: Hasil Sensus Penduduk 2020. BPS. \url{https://www.bps.go.id/id/publication/2023/05/16/fad83131cd3bb9be3bb2a657/proyeksi-penduduk-indonesia-2020-2050-hasil-sensus-penduduk-2020.html}
}


\examples{
data(pop_sap_Tot)
head(pop_sap_Tot)
}
\keyword{datasets}
