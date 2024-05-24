### Hjelpefunksjoner
# Hjelpefunksjoner til NI_vannf
# ved Hanno Sandvik
# april 2024
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



# Dekadisk logaritme skal forkortes som "lg"!
lg <- function(x) log10(x)



# Pen utmating av tekst
skriv <- function(..., pre = "", linjer.over = 0, linjer.under = 0,
                  Bredde, ut = FALSE) {
  if (missing(Bredde)) {
    if (exists("breddeUtmating")) {
      Bredde <- breddeUtmating
    } else {
      Bredde <- NULL
    }
  }
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



# Erstatte desimalpunkt med desimalkomma
komma <- function(x) erstatt(x, ".", ",")



# Sjekker om og sørger for at systemets tegnsett er norsk
UTF8 <- function() {
  ctype <<- Sys.getlocale("LC_CTYPE")
  if (!(tolower(ctype) %inneholder% "utf8" | tolower(ctype) %inneholder% "utf-8")) {
    LC_CTYPE.backup <<- ctype
    Sys.setlocale("LC_CTYPE", "nb_NO.utf8")
    skriv("Det ble oppdaga at systeminnstillingene ikke er forenlige med norske ",
          "tegnsett. Dette har nå blitt gjort om på. Den opprinnelige ",
          "innstillinga har blitt tatt vare på som \"LC_TYPE.backup\" ",
          "[og kan gjenskapes slik: Sys.setlocale(\"LC_CTYPE\", LC_TYPE.backup)].",
          pre = "OBS: ")
  }
  invisible()
}
UTF8()



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



# Regner om en dato til dagen i året
somDag <- function(d, m, y) as.POSIXlt(y %+% "-" %+% m %+% "-" %+% d)$yday



# Hjelpefunksjon til funksjonen "mEQR"
iNv <- function(mx) optimise(function(i) (i / atan(i) - mx)^2, c(0, 1000))$minimum



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



# Kombinerer to utmatinger av "fraVFtilNI"
# (Må kun brukes for ulike vannkategorier innenfor samme parameter!)
kombiner <- function(ut1, ut2) {
  ok <- TRUE
  UT <- ut1
  if (names(ut1) %=% names(ut2) &
      !is.null(attr(ut1, "parameter")) &
      attr(ut1, "parameter") %=% attr(ut2, "parameter") &
      !is.null(attr(ut1, "vannkategori")) &
      !is.null(attr(ut2, "vannkategori"))) {
    for (i in names(ut1)) {
      if (dimnames(ut1[[i]])[1:2] %=% dimnames(ut2[[i]])[1:2]) {
        ny <- array(0, dim = dim(ut1[[i]]) + c(0, 0, dim(ut2[[i]])[3] - 1))
        dimnames(ny) <- list(dimnames(ut1[[i]])[[1]],
                             dimnames(ut1[[i]])[[2]],
                             c("pred", 2:(dim(ny)[3]) - 1))
        ny[, , 2:dim(ut1[[i]])[3]] <- ut1[[i]][, , 2:dim(ut1[[i]])[3]]
        ny[, , dim(ut1[[i]])[3] - 1 +
             2:dim(ut2[[i]])[3]] <- ut2[[i]][, , 2:dim(ut2[[i]])[3]]
        for (j in 1:dim(ny)[1]) {
          for (k in 1:dim(ny)[2]) {
            ny[j, k, 1] <- median(ny[j, k, -1])
          }
        }
        UT[[i]] <- ny
      } else {
        ok <- FALSE
      }
    }
    if (ok) {
      attr(UT, "parameter")     <- attr(ut1, "parameter")
      attr(UT, "vannkategori")  <- attr(ut1, "vannkategori") %+% "," %+%
        attr(ut2, "vannkategori")
      attr(UT, "tidspunkt")     <- Sys.time()
      attr(UT, "innstillinger") <- NULL
      attr(UT, "beskjeder")     <- NULL
    }
  } else {
    ok <- FALSE
  }
  if (ok) {
    return(UT)
  } else {
    skriv("De to utmatingene var ikke kompatible og kunne ikke kombineres!",
          pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    return(NULL)
  }
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


