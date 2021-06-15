# Load packages
library(shiny)
library(tidyverse)
library(tidytext)
library(glue)
library(plotly)

# read data
nasa_fireball <- read_csv("cneos_fireball_data.csv")

 

#ui-----------------------------------------------------
ui <- fluidRow(
  titlePanel("Nasa Fireballs"),
  selectInput(
    inputId = "Velocity",
    label = "Velocity of Fireballs",
    choices = unique(nasa_fireball$`Velocity (km/s)`)
  ),

  dateRangeInput(
        inputId = "date_range",
        label = "Select Brightness Date Range",
        start = min(nasa_fireball$`Peak Brightness Date/Time (UT)`),
        end = max(nasa_fireball$`Peak Brightness Date/Time (UT)`)
      ),
    
    mainPanel(
      plotlyOutput(outputId = "fireballs_plot")))

# server----------------------------------------
server <- function(input, output) {
  output$fireballs_plot <- renderPlotly({
    p <- nasa_fireball %>%
      ggplot(aes(x = `Peak Brightness Date/Time (UT)`, y = `Velocity (km/s)`)) +
      geom_point(aes(color = `Velocity (km/s)` > 0), size = 2) +
      labs(
        title = "Nasa Fireballs",
        x = "Date", y = "Velocity"
      ) +
      theme_minimal() +
      theme(legend.position = "none")
    
    ggplotly(p, tooltip = c("x", "y"))
  })
}


# Create Shiny App-------------------------------
shinyApp(ui = ui, server = server)

                