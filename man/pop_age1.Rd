\name{pop_age1}
\alias{pop_age1_Tot}
\alias{pop_age1_L}
\alias{pop_age1_P}
\alias{pop_age1}

\docType{data}
\title{
Estimasi Jumlah Penduduk Umur 1 Tahunan
}
\description{
Jumlah penduduk umur 1 tahunan berdasarkan Hasil Proyeksi Penduduk Indonesia 2020-2050 berdasarkan hasil Sensus Penduduk (SP) 2020. Total (\code{pop_age1_Tot}), Laki-laki (\code{pop_age1_L}), Perempuan (\code{pop_age1_P}).
}
\usage{
data(pop_age1_Tot)
data(pop_age1_L)
data(pop_age1_P)
}
\format{
  Data frames atau tibble dengan variabel sebagai berikut:
  \describe{
    \item{\code{kode_provinsi}}{Kode provinsi.}
    \item{\code{tahun}}{Tahun.}
    \item{\code{umur}}{Umur 1 tahunan, untuk 80 merepresentasikan 80+ (80 tahun dan di atasnya). }
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
data(pop_age1_Tot)
head(pop_age1_Tot)
}
\keyword{datasets}
