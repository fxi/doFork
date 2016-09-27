#
# Author Fred Moser
# Date 26/09/2016
# Session info
#    R version 3.3.1 (2016-06-21)
#    Platform: x86_64-apple-darwin14.5.0 (64-bit)
#    Running under: OS X 10.10.5 (Yosemite)


library(shiny)
library(parallel)
source("helper.R")


#' Server function
#' @param input {reactivevalues}
#' @param output {shinyoutput}
#' @param session {ShinySession}
server <- function(input, output, session){
  # on click handler
  observeEvent(input$num_a,{ 
    # begin fork process
    doFork(
      refreshRateSeconds = 0.2,
      expr = {
        for(i in 1:100){
          doForkMessage(
            list(
              percent =  round((i/100)*100),
              text = "Please wait",
              anchor = "job_a"
              )
            )
          Sys.sleep(0.1) 
        }
        rnorm(1:input$num_a)
      },
      onMessage = function(m){
        session$sendCustomMessage("setProgress",m)
      },
      onFeedback = function( res ){
        output$plot_a <- renderPlot( barplot(res$data) )
      })
})
  observeEvent(input$num_b,{ 
    # begin fork process
    doFork(
      refreshRateSeconds = 1,
      expr = {
        for(i in 1:10){
          doForkMessage(
            list(
              percent =  round((i/10)*100),
              text = "Please wait",
              anchor = "job_b"
              )
            )
          Sys.sleep(0.5) 
        }
        rnorm(1:input$num_b)
      },
      onMessage = function(m){
        session$sendCustomMessage("setProgress",m)
      },
      onFeedback = function( res ){
        output$plot_b <- renderPlot( barplot(res$data) )
      })
})

  # Second plot
  output$plot_c <-  renderPlot({
    barplot(
      rnorm( 1:abs(input$num_c) 
        )
      )
  })
}



