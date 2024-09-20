---
title: "ALGS Race Chart Project"
output: github_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Description

This R project creates an animated race bar chart visualization for the Apex Legends Global Series (ALGS) Split 2 Playoff Finals. The script generates a dynamic visualization of team performance throughout the ALGS tournament, showing how teams' cumulative points change after each game.

## Dependencies

This project requires the following R libraries:

```{r libraries, eval=FALSE}
required_libraries <- c("readxl", "dplyr", "ggplot2", "gganimate", "gifski")
for (lib in required_libraries) {
  if (!require(lib, character.only = TRUE)) {
    install.packages(lib)
    library(lib, character.only = TRUE)
  }
}
```

## Data

The project uses data from `ALGS_Cleaned_Data.xlsx`. This file should be placed in the same directory as the R script.

```{r load_data, eval=FALSE}
file_path <- "ALGS_Cleaned_Data.xlsx"
full_data <- readxl::read_excel(file_path)
```

## Usage

To run the script:

1. Ensure you have R and RStudio installed on your system.
2. Open the Rmd file in RStudio.
3. Place the `ALGS_Cleaned_Data.xlsx` file in the same directory as the Rmd file.
4. Click "Knit" in RStudio to run the entire script and generate the output.

## Code Overview

Here's a brief overview of the main steps in the code:

1. Data preparation:

```{r data_prep, eval=FALSE}
full_data$Game <- factor(full_data$Game, levels = unique(full_data$Game), ordered = TRUE)
# ... (rest of data preparation code)
```

2. Creating the plot:

```{r create_plot, eval=FALSE}
p <- ggplot(cumulative_data, aes(y = Cumulative_Points, x = Team, fill = Team)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = bright_colors) +
  # ... (rest of plot creation code)
```

3. Animating the plot:

```{r animate_plot, eval=FALSE}
anim <- p + 
  transition_states(Game, transition_length = 6, state_length = 10, wrap = FALSE) +
  enter_fade() + 
  exit_fade()

animate(anim, renderer = gifski_renderer("algs_race_bar_chart.gif"), 
        fps = 8, width = 1000, height = 800, res = 150)
```

## Output

The script produces an animated GIF file named `algs_race_bar_chart.gif`. This visualization shows:
- Teams on the y-axis
- Cumulative points on the x-axis
- Progress of teams across games in the tournament

## Customization

The script includes a custom color scheme for each team. You can modify these colors in the `bright_colors` variable to match your preferences or official team colors.

## Author

[Your Name]

## License

[Specify the license under which this project is released, e.g., MIT, GPL, etc.]