


kommunehistorikk <- as.data.frame(read_xlsx("knr.xlsx", col_types = "text"))
fylkeshistorikk  <- as.data.frame(read_xlsx("fnr.xlsx", col_types = "text"))


for (i in 2:ncol(kommunehistorikk)) {
  kommunehistorikk[, i] <- erstatt(kommunehistorikk[, i], "&ae", "æ")
  kommunehistorikk[, i] <- erstatt(kommunehistorikk[, i], "&Ae", "Æ")
  kommunehistorikk[, i] <- erstatt(kommunehistorikk[, i], "&oe", "ø")
  kommunehistorikk[, i] <- erstatt(kommunehistorikk[, i], "&Oe", "Ø")
  kommunehistorikk[, i] <- erstatt(kommunehistorikk[, i], "&ao", "å")
  kommunehistorikk[, i] <- erstatt(kommunehistorikk[, i], "&Ao", "Å")
  kommunehistorikk[, i] <- erstatt(kommunehistorikk[, i], "&aa", "á")
  kommunehistorikk[, i] <- erstatt(kommunehistorikk[, i], "&ng", "ŋ")
  kommunehistorikk[, i] <- erstatt(kommunehistorikk[, i], "&sj", "š")
}

kommunehistorikk$Nummer[which(nchar(kommunehistorikk$Nummer) == 3)] <-
  "0" %+% kommunehistorikk$Nummer[which(nchar(kommunehistorikk$Nummer) == 3)]




