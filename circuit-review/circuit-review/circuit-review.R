# Copyright 2017 Mario O. Bourgoin

# Data from Tables 1 and 2 of Hofer, Roy E., and others. “Supreme Court
# Reversal Rates: Evaluating the Federal Courts of Appeals.” Landslide,
# Jan.-Feb, 2010.

# Read, clean, and organize data.
data_path <- file.path("../Data")
cases_path <- file.path(data_path, "circuit-cases.tsv")
reviewed_path <- file.path(data_path, "circuit-reviewed.tsv")

cases <- read.table(cases_path, header = TRUE, sep = "\t")
all(rowSums(cases[, 2:11]) == cases$Cases)
all(colSums(cases[1:13, 2:12]) == cases[14, 2:12])
cases <- droplevels(cases[ - nrow(cases), - ncol(cases)])

reviewed <- read.table(reviewed_path, header = TRUE, sep = "\t")
all(rowSums(reviewed[, 3:12]) == reviewed$Cases)
all(colSums(reviewed[1:39, 3:13]) == reviewed[40, 3:13])
reviewed <- droplevels(reviewed[ - nrow(reviewed), - ncol(reviewed)])

all(all(levels(cases$Court) %in% levels(reviewed$Court))
    & all(levels(reviewed$Court) %in% levels(cases$Court))
    & all(names(cases)[-1] %in% names(reviewed)[ - (1:2)])
    & all(names(reviewed)[ - (1:2)] %in% names(cases)[-1]))

# Break up reviewed into its dispositions.
for (disposition in levels(reviewed$Disposition)) {
    assign(tolower(disposition), droplevels(subset(reviewed, Disposition == disposition)[, -2]))
}

# Data matrices.
data_matrix_names <- c("Cases", levels(reviewed$Disposition))
data_dimnames <- list(Court = as.character(cases$Court), Year = names(cases)[-1])
for (name in data_matrix_names) {
    data <- as.matrix(get(tolower(name))[, -1])
    dimnames(data) <- data_dimnames
    assign(name, data)
}
Reviewed <- Reversed + Vacated + Affirmed
# Reviewed or Reversed = Reviewed or Vacated = Reviewed or Affirmed = Reviewed, and
# Reviewed and Reversed = Reversed, Reviewed and Vacated = Vacated, Reviewed and Affirmed = Affirmed.

# P(Court).
sort((PCourt = rowSums(Cases) / sum(Cases)), decreasing = TRUE)

# P(Reviewed).
(PReviewed = sum(Reviewed) / sum(Cases))

# P(Reviewed  Court).
sort((PReviewedACourt = rowSums(Reviewed) / sum(Cases)), decreasing = TRUE)

# P(Reviewed | Court)
sort((PReviewedGCourt = rowSums(Reviewed) / rowSums(Cases)), decreasing = TRUE)

# P(Court | Reviewed) = P(Reviewed | Court) * P(Court) / P(Reviewed)
sort((PCourtGReviewed = PReviewedGCourt * PCourt / PReviewed), decreasing = TRUE)

# P(Reversed or Vacated).
(PReversedOVacated = sum(Reversed + Vacated) / sum(Cases))

# P(Reversed or Vacated | Court)
sort((PReversedOVacatedGCourt = rowSums(Reversed + Vacated) / rowSums(Cases)), decreasing = TRUE)

# P(Court | Reversed or Vacated) = P(Reversed or Vacated | Court) * P(Court) / P(Reversed or Vacated)
sort((PCourtGReversedOVacated = PReversedOVacatedGCourt * PCourt / PReversedOVacated), decreasing = TRUE)

# P(Reversed or Vacated | Reviewed).
(PReversedOVacatedGReviewed = sum(Reversed + Vacated) / sum(Reviewed))

# P(Reversed or Vacated | Reviewed and Court)
sort((PReversedOVacatedGReviewedACourt = rowSums(Reversed + Vacated) / rowSums(Reviewed)), decreasing = TRUE)

# P(Reviewed and Court | Reversed or Vacated) = P(Reversed or Vacated | Reviewed and Court) * P(Reviewed and Court) / P(Reversed or Vacated)
sort((PReviewedACourtGReversedOVacated = PReversedOVacatedGReviewedACourt * PReviewedACourt / PReversedOVacated), decreasing = TRUE)

# P(Affirmed).
(PAffirmed = sum(Affirmed) / sum(Cases))

# P(Affirmed | Court)
sort((PAffirmedGCourt = rowSums(Affirmed) / rowSums(Cases)), decreasing = TRUE)

# P(Court | Affirmed) = P(Affirmed | Court) * P(Court) / P(Affirmed)
sort((PCourtGAffirmed = PAffirmedGCourt * PCourt / PAffirmed), decreasing = TRUE)

# P(Affirmed | Reviewed).
(PAffirmedGReviewed = sum(Affirmed) / sum(Reviewed))

# P(Affirmed | Reviewed and Court)
sort((PAffirmedGReviewedACourt = rowSums(Affirmed) / rowSums(Reviewed)), decreasing = TRUE)

# P(Reviewed and Court | Affirmed) = P(Affirmed | Reviewed and Court) * P(Reviewed and Court) / P(Affirmed)
sort((PReviewedACourtGAffirmed = PAffirmedGReviewedACourt * PReviewedACourt / PAffirmed), decreasing = TRUE)
