# estPUSek: Aplikasi berbasis shiny untuk estimasi jumlah penduduk umur sekolah dan umur 1 tahunan.
`estPUSek` adalah sebuah paket R (R package) yang berisikan aplikasi berbasis shiny untuk estimasi jumlah penduduk umur sekolah dan umur 1 tahunan dari jumlah penduduk umur 5 tahunan dengan menggunakan pendekatan koefisien sprague.


`estPUSek` juga menyediakan hasil estimasi penduduk umur sekolah dan 1 tahunan dari hasil proyeksi penduduk Indonesia 2020-2045 berdasarkan hasil Sensus Penduduk (SP) 2020.


## Menjalankan est PUSek
`estPUSek` dapat dijalankan melalui perangkat lunak R dengan melakukan instalasi paket terlebih dahulu sebagai berikut:

```r
# install paket remotes
install.packages('remotes')
# install estPUSek
remotes::install_github('aripurwantosp/estPUSek')
```

Aplikasi dapat dijalankan dengan perintah seperti berikut:
```r
library(estPUSek)
run.estPUSek()
```
Aplikasi terdiri dari 3 halaman utama, yakni: Hasil Proyeksi, Custom, dan Bantuan. 

### A. Hasil Proyeksi
Halaman hasil proyeksi menyajikan eksplorasi hasil estimasi penduduk umur sekolah dan 1 tahunan berdasarkan hasil Proyeksi Penduduk Indonesia 2020-2050 (berdasarkan hasil SP 2020).

<img src="https://github.com/aripurwantosp/estPUSek/blob/main/estPUSek_1.PNG" align="left"/>
<br></br>

Pada sisi kiri halaman (sidebar) terdapat pilihan indikator. Beberapa indikator juga dapat dipilih berdasarkan kelompok umur pada pilihan Umur. Menu tahun untuk memfilter tahun yang dikehendaki.

Terdapat 4 menu utama untuk menyajikan eksplorasi, yakni:

<strong>(1) Heat map</strong>
<p>Menyajikan visualisasi indikator antar provinsi dan antar tahun
</p>
<strong>(2) Map</strong>
<p>Menyajikan visualisasi indikator antar wilayah untuk tahun tertentu dengan menggunakan peta. Menu ini dapat digunakan jika Anda terhubung dengan internet.
</p>
<strong>(3) Tabel</strong>
<p>Menyajikan nilai-nilai indikator antar wilayah untuk tahun tertentu dengan menggunakan tabel. Anda dapat menyortir tabel secara interaktif dengan menekan tanda di samping nama kolom. Anda juga dapat mengunduh data dalam tabel dengan menekan link 'download'.
</p>
<strong>(4) Trends & Struktur</strong>
<p>Menyajikan visualisasi trend indikator antar tahun untuk suatu provinsi dan jumlah penduduk umur 1 tahunan di tahun tertentu.
</p>

### B. Custom
Anda dapat melakukan estimasi jumlah penduduk umur sekolah dan umur 1 tahunan terhadap data jumlah penduduk 5 tahunan yang Anda miliki pada tab atau halaman custom.

<img src="https://github.com/aripurwantosp/estPUSek/blob/main/estPUSek_2.PNG" align="left"/>
<br></br>

<p>Tahapan yang Anda lakukan adalah sebagai berikut: </p>
<strong>(1) Memilih metode input data</strong>
<p>Terdapat dua pilihan metode input data, yakni secara manual atau input file. Jenis file yang didukung untuk pilihan input file adalah: .csv (semicolon ; delimiter), .xls, dan .xlsx (excel). Format input data terdiri dari dua kolom, yakni Umur dan Jumlah. Kolom umur berisikan label kelompok umur 5 tahunan dan Kolom Jumlah. Format desimal untuk jenis file .csv menggunakan titik.
<strong>(2) Memilih kelompok umur terbuka</strong>
<p>Kelompok umur terbuka merupakan batas atas kelompok umur pada dataset yang digunakan, misalnya kelompok umur 80 tahun ke atas (80+). Jika menggunakan metode input data dengan input file, pastikan kelompok umur terbuka sesuai dengan file yang digunakan. Jika Anda menggunakan metode input data manual, pilih sesuai dengan yang akan Anda input.</p>
<strong>(3) Inisialisasi data</strong>
<p>Inisialisasi data dilakukan dengan menekan tombol Init data. Jika Anda menggunakan metode input data dengan input file, aplikasi akan membaca dan menampilkan data pada kolom Input umur 5 tahunan. Kolom kosong akan muncul jika Anda menggunakan metode input data secara manual.</p>
<strong>(4) Estimasi</strong>
<p>Estimasi kelompok umur sekolah dan umur 1 tahunan akan diproses dengan menekan tombol Estimasi. Output yang dihasilkan adalah tabel jumlah dan persentase penduduk usia sekolah terhadap jumlah total penduduk, serta struktur umur 1 tahunan.
</p>
<p>Hasil estimasi dapat didownload dalam bentuk file .csv dengan menekan link 'Eskpor umur sekolah' atau 'Ekspor umur 1 tahunan'.</p>

### C. Bantuan
Halaman bantuan

<img src="https://github.com/aripurwantosp/estPUSek/blob/main/estPUSek_2.PNG" align="left"/>
<br></br>

## Sitasi
Untuk mensitasi paket `estPUSek` dalam publikasi dapat digunakan format berikut:

Prasojo APS (2024). estPUSek: Aplikasi Berbasis Shiny untuk Estimasi
  Jumlah Penduduk Umur Sekolah dan Umur 1 Tahunan. URL: https://github.com/aripurwantosp/estPUSek.

## R session info untuk versi paket-paket terkait

```r
> sessionInfo()
R version 4.2.3 (2023-03-15 ucrt)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 19045)

Matrix products: default

locale:
[1] LC_COLLATE=English_Indonesia.utf8  LC_CTYPE=English_Indonesia.utf8   
[3] LC_MONETARY=English_Indonesia.utf8 LC_NUMERIC=C                      
[5] LC_TIME=English_Indonesia.utf8    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] estPUSek_1.0         googleVis_0.7.1      ggplot2_3.5.0       
[4] magrittr_2.0.3       shinyjs_2.1.0        shinydashboard_0.7.2
[7] shinythemes_1.2.0    shiny_1.8.0         

loaded via a namespace (and not attached):
 [1] Rcpp_1.0.12       rprojroot_2.0.4   digest_0.6.35     utf8_1.2.4       
 [5] mime_0.12         cellranger_1.1.0  R6_2.5.1          pillar_1.9.0     
 [9] rlang_1.1.3       readxl_1.4.3      rstudioapi_0.15.0 fontawesome_0.5.2
[13] miniUI_0.1.1.1    urlchecker_1.0.1  jquerylib_0.1.4   DT_0.32          
[17] labeling_0.4.3    textshaping_0.3.7 desc_1.4.3        devtools_2.4.5   
[21] stringr_1.5.1     htmlwidgets_1.6.4 munsell_0.5.0     compiler_4.2.3   
[25] httpuv_1.6.14     systemfonts_1.0.6 pkgconfig_2.0.3   pkgbuild_1.4.3   
[29] htmltools_0.5.7   tidyselect_1.2.1  tibble_3.2.1      codetools_0.2-19 
[33] fansi_1.0.6       crayon_1.5.2      dplyr_1.1.4       withr_3.0.0      
[37] later_1.3.2       brio_1.1.4        grid_4.2.3        jsonlite_1.8.8   
[41] xtable_1.8-4      gtable_0.3.4      lifecycle_1.0.4   scales_1.3.0     
[45] cli_3.6.2         stringi_1.8.3     cachem_1.0.8      farver_2.1.1     
[49] fs_1.6.3          promises_1.2.1    remotes_2.5.0     testthat_3.2.1   
[53] bslib_0.6.1       ellipsis_0.3.2    ragg_1.3.0        generics_0.1.3   
[57] vctrs_0.6.5       tools_4.2.3       glue_1.7.0        purrr_1.0.2      
[61] crosstalk_1.2.1   pkgload_1.3.4     fastmap_1.1.1     yaml_2.3.8       
[65] colorspace_2.1-0  sessioninfo_1.2.2 memoise_2.0.1     profvis_0.3.8    
[69] sass_0.4.8        usethis_2.2.3
```
