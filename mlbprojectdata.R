# Creating CSV From baseballr package - statcast_search_pitchers()

library(baseballr)

# For loop combining pitch data - issues with loading in one data set
# Have to iterate day by day and bind the frames

start.date <- as.Date("2022-04-08")
end.date <- as.Date("2022-10-02")

sequence <- seq(start.date, end.date, by = "day")

# Selecting needed columns
selected <- c(1,3,4,5,10, 16, 18, 19, 28, 29, 30, 31, 45, 46, 47, 48, 49, 
              50, 51, 52, 56, 57, 58, 59, 69, 90)

finalframe <- statcast_search_pitchers("2022-04-07", "2022-04-07")[,selected]

for (i in 1:length(sequence)) {
  
  # Statcast pitches tracked for each day
  pitches <- statcast_search_pitchers(sequence[i], sequence[i])
  pitches <- pitches[,selected]
  
  # Binding frames
  finalframe <- rbind(finalframe, pitches)
}


# Creating CSV File 
write.csv(finalframe, "C:/Users/tscot/Downloads/swingmissprojdata.csv")

## Different R Session - Had To Reload In Data Rather Than Used Saved Frame

# Loading In Created CSV File
pitches <- read.csv("C:/Users/tscot/Downloads/swingmissprojdata.csv")
pitches <- pitches[,-c(1)]

# Removing duplicates caused by days with no games
pitches <- pitches[!duplicated(pitches),]

# Removing NAs
pitches <- na.omit(pitches)

# Adding Swing/Miss Binary Column
pitches$miss <- ifelse(pitches$description == "swinging_strike", 1, 0)

# Only Keeping Miss, Foul Ball, In Play
swing <- c("foul", "foul_tip", "hit_into_play", 
           "swinging_strike", "swinging_strike_blocked")
pitches <- pitches[pitches$description %in% swing,]

# Saving New CSV File
write.csv(pitches, "C:/Users/tscot/Downloads/pitchesprojdata.csv")
