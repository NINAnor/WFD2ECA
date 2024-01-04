### Hjelpefunksjoner
# Hjelpefunksjoner til NI_vannf
# ved Hanno Sandvik
# desember 2023
# se https://github.com/NINAnor/NI_vannf
###



# Tester om argumentene er like - ikke følsom for avrundingsfeil!
"%=%" <- function(arg1, arg2) { 
  attributes(arg1) <- NULL
  attributes(arg2) <- NULL
  return(identical(all.equal(arg1, arg2), TRUE))
}



# Tester om argumentene er ulike - ikke følsom for avrundingsfeil!
"%!=%" <- function(arg1, arg2) !(arg1 %=% arg2)



# Tester om elementene i argumentene er like - ikke følsom for avrundingsfeil 
"%==%" <- function(arg1, arg2) {
  if(is.numeric(arg1) & is.numeric(arg2)) {
    (abs(arg1 - arg2) < 1e-12)
  } else {
    (arg1 == arg2)
  }
}



# Limer sammen tekstvariabler
"%+%" <- function(string1, string2) paste0(string1, string2)



# Fjerner et element fra en vektor
"%-%" <- function(arg1, arg2) arg1[which(!(arg1 %in% na.omit(arg2)))]



# Beregner snittmengden av to vektorer
"%A%" <- function(set1, set2)
  if (is.null(set1)) logical(0) else as.vector(na.omit(set1[set1 %in% set2]))



# Sjekker om en variabel inneholder en angitt søketekst
"%inneholder%" <- function(vector, search) grepl(search, vector, fixed = TRUE)



# Sjekker om verdier ligger innenfor et intervall
"%mellom%" <- function(a, b) (a > b[1]         | a %==% b[1]) &
  (a < b[length(b)] | a %==% b[length(b)])



# Sjekker om verdier ligger utenfor et intervall
"%utafor%" <- function(a, b) !(a > b[1]         | a %==% b[1]) |
  !(a < b[length(b)] | a %==% b[length(b)])



# Sjekker om begynnelsen av ordet er lik
"%begynner%" <- function(a, b) substr(a, 1, nchar(b)) %=% b



# Naturlig logaritme skal forkortes som "ln"!
ln <- function(x) log(x)



# Pen utmating av tekst
skriv <- function(..., pre = "", linjer.over = 0, linjer.under = 0,
                  Bredde = bredde, ut = FALSE) {
  txt <- paste(c(...), collapse = "")
  cat(rep("\n", linjer.over),
      paste(strwrap(txt,
                    width = if (is.null(Bredde))
                      0.84 * getOption("width") else Bredde,
                    initial = pre,
                    exdent = nchar(pre)),
            collapse = "\n"), 
      rep("\n", linjer.under + 1), 
      sep="")
  if (ut) return(txt)
}



# Erstatte tegn i en tekststreng
erstatt <- function(i, hva, med) gsub(hva, med, i, fixed = TRUE)



# Oversette vannmiljøs parameterID til parameternavn
parameterNavn <- function(id) {
  rownames(Parametere) <- Parametere$id
  navn <- Parametere[toupper(id), "navn"]
  navn[which(is.na(navn))] <- "?"
  return(navn)
}



# Sjekker intervallet for tillatte verdier for vannmiljø-parametere
tillatteVerdier <- function(id) {
  rownames(Parametere) <- Parametere$id
  as.numeric(unlist(Parametere[toupper(id), 3:4]))
}



# Omregning av Raddum-II- til Raddum-I-verdier
Raddum2_1 <- Raddum1_2 <- function(DATA) {
  w1 <- which(DATA$parid == "RADDUM2")
  w2 <- which(DATA$parid == "RADDUM2" & DATA$verdi > 0.5)
  if (length(w2)) {
    DATA$verdi[w2] <- 1
  }
  if (length(w1)) {
    DATA$parid[w1] <- "RADDUM1"
    skriv(length(w1), " Raddum-II-målinger har blitt regna om til Raddum I.",
          linjer.under = 1)
  }
  return(DATA)
}



# Definere en fargepalett tilpassa vannforskriften
farge <- function(eqr, na.farge=0.84) {
  r <- ifelse(is.na(eqr), na.farge,
              ifelse(eqr < 0.1, eqr * 5 + 0.5,
                     ifelse(eqr < 0.5, 1,
                            ifelse(eqr < 0.7, sqrt(3.5 - eqr * 5),
                                   ifelse(eqr < 0.9, 0, eqr * 5 - 4.5)))))
  g <- ifelse(is.na(eqr), na.farge,
              ifelse(eqr < 0.1, 0,
                     ifelse(eqr < 0.5, eqr * 2.5 - 0.25,
                            ifelse(eqr < 0.8, 1,
                                   ifelse(eqr < 0.9, 9 - eqr * 10, 0)))))
  b <- ifelse(is.na(eqr), na.farge,
              ifelse(eqr < 0.7, 0,
                     ifelse(eqr < 0.8, eqr * 10 - 7, 1)))
  rgb(r,g,b)
}



# Variabler/konstanter som trengs


bredde <- NULL


Typologi <- c( # inneholder navnene på typologifaktorene
  kat = "kategori",
  reg = "økoregion",
  son = "klimaregion",
  stø = "størrelse",
  alk = "alkalitet",
  hum = "humusinnhold",
  tur = "turbiditet",
  dyp = "dybde",
  kys = "kysttype",
  sal = "salinitet",
  tid = "tidevann",
  bøl = "bølgeeksponering",
  mix = "miksing",
  opp = "oppholdstid",
  str = "strøm"
)


Vanntyper <- list( # angir mulige verdier for alle typologifaktorer
  kat = c("C", "L", "R"),
  reg = c("B", "E", "F", "G", "H", "M", "N", "S", "W"),
  son = c("L", "M", "H"),
  stø = 1:5,
  alk = 1:8,
  hum = 0:4,
  tur = 1:3,
  dyp = 1:6,
  kys = 1:8,
  sal = 1:7,
  tid = 1:2,
  eks = 1:3,
  mix = 1:3,
  opp = 1:3,
  str = 1:3
)


