
# Hjelpefunksjoner

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
skriv <- function(..., pre = "", linjer.over = 0, linjer.under = 0)
  cat(rep("\n", linjer.over),
      paste(strwrap(paste(c(...), collapse = ""),
                    initial = pre,
                    exdent = nchar(pre)),
            collapse = "\n"), 
      rep("\n", linjer.under + 1), 
      sep="")

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

# Beregne mEQR-verdier ("modifiserte EQR-verdier")
mEQR <- function(x, klassegrenser) {
  K <- klassegrenser
  if ((K[8] < K[1]) %=% TRUE) {
    K <- -K
    x <- -x
  }
  x <- ifelse(x < K[1], NA,
       ifelse(x < K[2], (x - K[1]) / (K[2] - K[1]) - 1,
       ifelse(x < K[3], (x - K[2]) / (K[3] - K[2]) + 0,
       ifelse(x < K[4], (x - K[3]) / (K[4] - K[3]) + 1,
       ifelse(x < K[5], (x - K[4]) / (K[5] - K[4]) + 2,
       ifelse(x < K[6], (x - K[5]) / (K[6] - K[5]) + 3,
       ifelse(x < K[7], (x - K[6]) / (K[7] - K[6]) + 4,
       ifelse(x <=K[8], (x - K[7]) / (K[8] - K[7]) + 5,
                        NA))))))))
  return(x * 0.2)
}


# Variabler/konstanter som trengs

Typologi <- c( # inneholder navnene på typologifaktorene
  "kategori",
  "økoregion",
  "klimaregion",
  "størrelse",
  "alkalitet",
  "humusinnhold",
  "turbiditet",
  "dybde",
  "kysttype",
  "salinitet",
  "tidevann",
  "bølgeeksponering",
  "miksing",
  "oppholdstid",
  "strøm"
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


fylke <- function(i) fylkeshistorikk$navn[which(fylkeshistorikk$nr == i)]


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

