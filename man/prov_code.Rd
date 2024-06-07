\name{prov_code}
\alias{prov_code}

\docType{data}
\title{
Kode Referensi Provinsi
}
\description{
Kode referensi 34 provinsi di Indonesia.
}
\usage{
data(prov_code)
}
\format{
  Data frames atau tibble dengan variabel sebagai berikut:
  \describe{
    \item{\code{kode_bps}}{Kode provinsi berdasarkan Badan Pusat Statistik (BPS).}
    \item{\code{prov_bps}}{Nama provinsi berdasarkan BPS.}
    \item{\code{iso_code}}{Kode ISO provinsi.}
  }
}

\source{
 \url{https://id.wikipedia.org/wiki/ISO_3166-2:ID}
 }

\examples{
data(prov_code)
head(prov_code)
}
\keyword{datasets}
