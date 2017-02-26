# Copyright 2017 Mario O. Bourgoin

# Data from AccuWeather:
# http://www.accuweather.com/en/us/boston-ma/02108/february-weather/348735

# Image from WeatherSpark:
# https://weatherspark.com/averages/29794/2/Boston-Massachusetts-United-States

library("png")
library("plotrix")

dataPath <- file.path("../Data")
februaryData <- file.path(dataPath, "Historical-February.csv")
februaryImage <- file.path(dataPath, "Historical-February.png")
februaryPlot <- file.path(dataPath, "Historical-February-plot.png")

tempFeb <- read.csv(februaryData, colClasses=c(Date="Date"))

tempFebImage <- readPNG(februaryImage)

dateRange <- c(min(tempFeb$Date), as.Date("2017-03-01"))

tempRange <- c(0, 80)

png(februaryPlot, width=600, height=600)

plot(dateRange, tempRange, type="n",
     xlab = "Date", ylab = expression(paste("Temperature (", degree, "F)")),
     main="Boston Area Daily Temperatures, February 2017")
rasterImage(tempFebImage, as.Date("2017-02-01"), 7.5, as.Date("2017-03-01"), 58)
grid()
with(tempFeb, {
    lines(Date, High, lwd=2, col="red4")
    lines(Date, Low, lwd=2, col="blue4")
    points(as.Date("2017-02-24"),
           High[Date == as.Date("2017-02-24")],
           pch=19, col="red4")
    text(as.Date("2017-02-24"),
         High[Date == as.Date("2017-02-24")]+4,
         labels="Feb 24")
    text(as.Date("2017-02-24"),
         High[Date == as.Date("2017-02-24")]+2,
         labels=substitute(paste(temp, degree, "F"),
                           list(temp = High[Date == as.Date("2017-02-24")])))
    points(as.Date("2017-02-24"),
           Low[Date == as.Date("2017-02-24")],
           pch=19, col="red4")
    text(as.Date("2017-02-24"),
         Low[Date == as.Date("2017-02-24")]+4,
         labels="Feb 24")
    text(as.Date("2017-02-24"),
         Low[Date == as.Date("2017-02-24")]+2,
         labels=substitute(paste(temp, degree, "F"),
                           list(temp = Low[Date == as.Date("2017-02-24")])))
    draw.circle(as.Date("2017-02-24"),
                Low[Date == as.Date("2017-02-24")]+2,
                1.5, border="red", lwd=2)
})
legend("topleft",
       legend=c("Daily High", "Daily Low", "Mean High", "Mean Low"),
       fill=c("red4", "blue4", "red", "blue"))

dev.off()
