# Load the necessary libraries
required_libraries <- c("readxl", "dplyr", "ggplot2", "gganimate", "gifski")

# Install and load libraries using a for loop
for (lib in required_libraries) {
  if (!require(lib, character.only = TRUE)) {
    install.packages(lib)
    library(lib, character.only = TRUE)
  }
}

# Load the cleaned dataset
file_path <- "ALGS_Cleaned_Data.xlsx"  # Replace with the correct file path
full_data <- read_excel(file_path)

# Ensure Points column is numeric
full_data$Points <- as.numeric(full_data$Points)

# Step 1: Convert Game column to a factor to enforce proper order
full_data$Game <- factor(full_data$Game, levels = unique(full_data$Game), ordered = TRUE)

# Step 2: Define the desired team order for the y-axis
team_order <- c("Spacestation Gaming", "Gaimin Gladiators", "Alliance", "TSM", "Guild Esports", 
                "Fnatic", "Bleed Esports", "VK Gaming", "NRG", "Not Moist", "Team Liquid", 
                "Complexity Gaming", "DreamFire", "Noctem Esports", "EXO Clan", "Mkers", 
                "Cloud9", "ENTER FORCE.36", "FURIA Esports", "Team Falcons")

# Step 3: Calculate cumulative points for each team as the games progress
cumulative_data <- full_data %>%
  group_by(Team, Game) %>%
  summarise(Game_Points = sum(Points, na.rm = TRUE)) %>%
  arrange(Game) %>%
  group_by(Team) %>%
  mutate(Cumulative_Points = cumsum(Game_Points))  # Accumulate points game by game

# Step 4: Apply the custom team order explicitly
cumulative_data$Team <- factor(cumulative_data$Team, levels = team_order, ordered = TRUE)

# Step 5: Create a cohesive color scheme inspired by the team's branding
bright_colors <- c(
  "Spacestation Gaming" = "#f4b221",  # Golden Yellow
  "Gaimin Gladiators" = "#BABABA",    # Light Gray
  "Alliance" = "#44D62C",             # Bright Green
  "TSM" = "#081414",                  # Dark Teal (Almost Black)
  "Guild Esports" = "#3D2BFB",        # Electric Blue
  "Fnatic" = "#FF5900",               # Bright Orange
  "Bleed Esports" = "#B10000",        # Crimson Red
  "VK Gaming" = "#05EFC1",            # Bright Aqua
  "NRG" = "#46AB7E",                  # Jade Green
  "Not Moist" = "#00A2E6",            # Sky Blue
  "Team Liquid" = "#2B2743",          # Charcoal Purple
  "Complexity Gaming" = "#002B5C",    # Navy Blue
  "DreamFire" = "#DB010F",            # Fire Red
  "Noctem Esports" = "#4D0F41",       # Plum Purple
  "EXO Clan" = "#EC5F34",             # Burnt Orange
  "Mkers" = "#F0E441",                # Bright Yellow
  "Cloud9" = "#00ADF1",               # Sky Blue
  "ENTER FORCE.36" = "#49475E",       # Slate Gray
  "FURIA Esports" = "#000000",        # Black
  "Team Falcons" = "#01BE6E"          # Mint Green
)

# Step 6: Create the race bar chart with bright colors and flip the axis
p <- ggplot(cumulative_data, aes(y = Cumulative_Points, x = Team, fill = Team)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = bright_colors) +  # Apply the bright color palette
  scale_x_discrete(limits = rev(team_order)) +  # Ensure correct team order on x-axis
  labs(title = 'Match Progression in ALGS Split 2 Playoff Finals', 
       subtitle = 'Game: {closest_state}',
       x = 'Team', 
       y = 'Cumulative Points') +
  theme_minimal() +
  theme(legend.position = "none") +
  coord_flip()  # Flip the axis to show teams on y-axis and points on x-axis

# Step 7: Animate the plot using gganimate with longer pauses after each game
anim <- p + 
  transition_states(Game, transition_length = 6, state_length = 10, wrap = FALSE) +  # Longer state length to pause after each game
  enter_fade() + 
  exit_fade()

# Step 8: Save the animation with high quality, slow speed, and longer pauses
animate(anim, renderer = gifski_renderer("algs_race_bar_chart.gif"), 
        fps = 8, width = 1000, height = 800, res = 150)
