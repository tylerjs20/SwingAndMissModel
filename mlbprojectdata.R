# Creating CSV From baseballr package - statcast_search_pitchers()
library(baseballr)

# For loop combining pitch data - issues with loading in one data set
# Have to iterate day by day and bind the frames

start.date <- as.Date("2022-04-08")
end.date <- as.Date("2022-10-02")

sequence <- seq(start.date, end.date, by = "day")

# Selecting needed columns
selected <- c(1,3,4,5, 6, 7, 10, 16, 18, 19, 28, 29, 30, 31, 45, 46, 47, 48, 49, 
              50, 51, 52, 56, 57, 58, 59, 69, 90)

finalframe <- statcast_search_pitchers("2022-04-07", "2022-04-07")[,selected]
colnames(finalframe)[6] <- "pitcher_name"
batter <- statcast_search_batters("2022-04-07", "2022-04-07")[,c(6,7)]

for (i in 1:length(sequence)) {
  
  # Statcast pitches tracked for each day
  pitches <- statcast_search_pitchers(sequence[i], sequence[i])[,selected]
  colnames(pitches)[6] <- "pitcher_name"
  
  # Statcast call for batter names and ID
  bframe <- statcast_search_batters(sequence[i], sequence[i])[,c(6,7)]
  
  # Binding frames
  finalframe <- rbind(finalframe, pitches)
  batter <- rbind(batter, bframe)
}

finalframe <- read.csv("C:/Users/tscot/Downloads/PersonalProjects/swingmissproj/pitchesprojdataFirstLoop.csv")
batter <- read.csv("C:/Users/tscot/Downloads/PersonalProjects/swingmissproj/batterFirstLoop.csv")

pitches <- finalframe

# Removing NAs
pitches <- na.omit(pitches)

pitches <- unique(pitches)

# Adding Batter Name To Frame
batter <- as.data.frame(batter)
batter_name <- c()
for (i in 1:nrow(pitches)) {
  x <- batter[batter$batter == pitches$pitcher_name[i],]
  batter_name <- c(batter_name, x[1,2])
}

pitches$batter_name <- batter_name

# Adding Swing/Miss Binary Column
pitches$miss <- ifelse(pitches$description == "swinging_strike", 1, 0)

# Only Keeping Miss, Foul Ball, In Play
swing <- c("foul", "foul_tip", "hit_into_play", 
           "swinging_strike", "swinging_strike_blocked")
pitches <- pitches[pitches$description %in% swing,]

# Saving New CSV File
write.csv(pitches, "C:/Users/tscot/Downloads/PersonalProjects/swingmissproj/pitchesprojdata.csv")

# Collecting 2023 data for model testing
start.date <- as.Date("2023-03-31")
end.date <- as.Date("2023-06-05")

sequence <- seq(start.date, end.date, by = "day")

selected <- c(1,3,4,5, 6, 7, 10, 16, 18, 19, 28, 29, 30, 31, 45, 46, 47, 48, 49, 
              50, 51, 52, 56, 57, 58, 59, 69, 90)

finalframe <- statcast_search_pitchers("2023-03-30", "2023-03-30")[,selected]
colnames(finalframe)[6] <- "pitcher_name"
batter <- statcast_search_batters("2023-03-30", "2023-03-30")[,c(6,7)]

for (i in 1:length(sequence)) {
  
  # Statcast pitches tracked for each day
  pitches <- statcast_search_pitchers(sequence[i], sequence[i])[,selected]
  colnames(pitches)[6] <- "pitcher_name"
  
  # Statcast call for batter names and ID
  bframe <- statcast_search_batters(sequence[i], sequence[i])[,c(6,7)]
  
  # Binding frames
  finalframe <- rbind(finalframe, pitches)
  batter <- rbind(batter, bframe)
}


pitches <- finalframe

# Removing NAs
pitches <- na.omit(pitches)
pitches <- unique(pitches)

# Adding Batter Name To Frame
batter <- as.data.frame(batter)
batter_name <- c()
for (i in 1:nrow(pitches)) {
  x <- batter[batter$batter == pitches$pitcher_name[i],]
  batter_name <- c(batter_name, x[1,1])
}

pitches$batter_name <- batter_name

# Adding Swing/Miss Binary Column
pitches$miss <- ifelse(pitches$description == "swinging_strike", 1, 0)

# Only Keeping Miss, Foul Ball, In Play
swing <- c("foul", "foul_tip", "hit_into_play", 
           "swinging_strike", "swinging_strike_blocked")
pitches <- pitches[pitches$description %in% swing,]

# Saving New CSV File
write.csv(pitches, "C:/Users/tscot/Downloads/PersonalProjects/swingmissproj/pitches2023.csv")

