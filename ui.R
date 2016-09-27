
#' Shiny UI
ui <- bootstrapPage(
  tags$head(
    tags$script('
      Shiny.addCustomMessageHandler("setProgress", 
        function(e) {
          progressScreen(e)
          }) 
      '),
      tags$script(src="progress.js"),
      tags$link(href="progress.css",rel="stylesheet",type="text/css")
      ),
      column(12,
        tagList(
          tags$h1("Shiny Asynchronous Job"),
          tags$p("Asynchronous processes in shiny app with feedback function."),
          fluidRow(
            tags$div(class="col-xs-4",
              tags$h2("Expensive job"),
              tags$p("Launch a function asynchronously: other processes will not be blocked"),
              sliderInput(
                inputId="num_a",
                label="Enter a number",
                value=10,
                min=0,
                max=100
                ),
              tags$div(id="job_a",
                plotOutput("plot_a")
              )
              ),
            tags$div(class="col-xs-4",
              tags$h2("Other expensive job"),
              tags$p("Launch a function asynchronously: other processes will not be blocked"),
              sliderInput(
                inputId="num_b",
                label="Enter a number",
                value=10,
                min=0,
                max=100
                ),
              tags$div(id="job_b",
                plotOutput("plot_b")
              )
              ),
            tags$div(class="col-xs-4",id="job_c",
              tags$h2("Simple job"),
              tags$p("Launch a function on the main thread : other processes will be blocked"),
              sliderInput(
                inputId="num_c",
                label="Enter a number",
                value=10,
                min=0,
                max=100
                ),
              tags$div(id="job_c",
                plotOutput("plot_c")
                )
              )
            )
          )
        )
      ) 


