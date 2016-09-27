# Shiny asynchronous jobs

Experiemental work on forked computation in a shiny app using the package "parallel".

Does not work on windows.


### Example

```{sh}
Rscript run.R
```

![demo dofork](https://raw.githubusercontent.com/fxi/doFork/master/www/dofork_demo.gif "DoFork demo")

### Usage

```{R}
library(shiny)
library(parallel)
source("helper.R")


# sample shiny app
app <- shinyApp(ui=
  # simple ui
  tagList(
    textOutput("txt"),
    actionButton("btn_1","Plot worker"),
    actionButton("btn_2","Plot main"),
    plotOutput("plot_1"),
    plotOutput("plot_2")
    ),
  # server function
  server=function(input,output,session){
    # observe button 1 click
    observeEvent(input$btn_1,{
      ## begin doFork 
      pid <- doFork( 
        # define expression to evaluate in the worker
        expr = {
          for(i in 1:10){
            # send message back during computation
            doForkMessage(
              list(value=10-i)
              )
            Sys.sleep(1) 
          }
          return(rnorm(1:100))
        }, 
        # do something with the message
        onMessage = function( m ){
          output$txt <- renderText(m$value)
          print(m$value)
        },
        # do something with the result
        onFeedback = function( res ){
          output$plot_1 <- renderPlot(barplot( res$data ) )
        }
        )
    })
    # observe button 2
    observeEvent(input$btn_2,{
      output$plot_2 <- renderPlot(barplot(rnorm(1:100)))
    })
  })

runApp(app,port=2329,launch.browser=FALSE)
```




