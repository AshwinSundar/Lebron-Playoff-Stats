require(shiny)
require(googlesheets) # great plugin to access google spreadsheet data. You can adjust settings in google spreadsheets so that they autoupdate, which is particularly useful if you're doing something like importHTML() - you'll get live stats from websites. Anyway, great tutorial for using the googlesheets plugin here - https://htmlpreview.github.io/?https://raw.githubusercontent.com/jennybc/googlesheets/master/vignettes/basic-usage.html#register-a-sheet

# gs_ls() # run this if you've never used googlesheets before. It will authenticate your Google account.
#### #### #### #### ####
### Replace null Rank ##
#### #### #### #### ####
# Replaces all NA values in the "Rank" column of a datatable. Useful when there are ties in the recordbook
source("replaceNullRank.R")
# The next three lines do exactly the same thing - they get the same exact sheeet, just using different methods.
individualPlayoffData <- gs_url("https://docs.google.com/spreadsheets/d/1OzkWKqrwJjGDKbySBDZNfyPW7BKN6gi2fslxFjxSInY/edit#gid=0") # get spreadsheet by URL
# lebronData <- gs_title("Lebron James 4 President") # get spreadsheet by title
# lebronData <- gs_key("1OzkWKqrwJjGDKbySBDZNfyPW7BKN6gi2fslxFjxSInY") # get spreadsheet by unique key

# Define UI
ui <- shinyUI(fluidPage(
   
   # Application title
   # titlePanel(""),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
        navlistPanel(
          tabPanel("Points", dataTableOutput("careerPoints")),
          tabPanel("Points - Plot", metricsgraphicsOutput("rankPointsPlot")),
          tabPanel("Games Played"),
          tabPanel("Minutes Played"),
          tabPanel("Field Goals Made"),
          tabPanel("Field Goal Attempts"),
          tabPanel("3PG Made"),
          tabPanel("3PG Attempts"),
          tabPanel("Free Throws Made"),
          tabPanel("Free Throw Attempts"),
          tabPanel("Offensive Rebounds"),
          tabPanel("Defensive Rebounds"),
          tabPanel("Total Rebounds"),
          tabPanel("Assists"),
          tabPanel("Steals"),
          tabPanel("Blocks"),
          tabPanel("Turnovers"),
          tabPanel("Personal Fouls")
          # tabPanel("Pick Two") # User can pick two variables, plot the players that are common to both charts like this -> http://shiny.rstudio.com/gallery/movie-explorer.html
        ),
        
      mainPanel(
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  
  output$careerPoints <- renderDataTable({
    # ss refers to a registered spreadsheet object, ws refers to which worksheet to use (1 = first, 2 = second, etc), range is the range of cells you want to use (optional)
    careerPoints <- gs_read(ss = individualPlayoffData, ws = 1, range = "A3:C260") # returns a datatable object, which gets picked up and displayed by renderDtaTable
    
  })
  
  output$rankPointsPlot <- renderMetricsgraphics({
    careerPoints <- gs_read(ss = individualPlayoffData, ws = 1, range = "A3:C260") # returns a datatable object
    careerPoints = replaceNullRank(careerPoints) # fixes any NA values that show up in the "Rank" column
    careerPoints %>%
      mjs_plot(x=Rank, y=PTS, width=600, height=500) %>%
      mjs_point(# color_accessor=cyl,
                x_rug=FALSE, y_rug=TRUE) %>% # display a "rug" plot (little tick marks along each axis)
                # size_accessor=carb,
                # size_range=c(5, 10),
                # color_type="category",
                # color_range=brewer.pal(n=11, name="RdBu")[c(1, 5, 11)]) %>%
      mjs_labs(x="Rank", y="Points") # %>%
      # mjs_add_legend(legend="X")

    # A working example
    # mtcars %>%
    #   mjs_plot(x=wt, y=mpg, width=600, height=500) # %>%
    #   mjs_point(color_accessor=cyl,
    #             x_rug=TRUE, y_rug=TRUE,
    #             size_accessor=carb,
    #             size_range=c(5, 10),
    #             color_type="category",
    #             color_range=brewer.pal(n=11, name="RdBu")[c(1, 5, 11)]) %>%
    #   mjs_labs(x="Weight of Car", y="Miles per Gallon") %>%
    #   mjs_add_legend(legend="X")
  })
   
})

# Run the application 
shinyApp(ui = ui, server = server)

