# Shiny asynchronous jobs

Experiemental work on forked computation in a shiny app using the package "parallel".

Does not work on windows.


### Example

```{sh}
Rscript run.R
```

### Usage

```{R}

library(shiny)
library(parallel)
source("helper.R")

# Define an expensive function
expensiveFunction <- function(){
  for(i in 1:3){
    Sys.sleep(0.1) 
  }
  return(1:10)
}

# define a feedback function. res$data is the result, res$message is a process message.
feedbackFunction <- function(res){
  output$plot <- renderPlot(barplot(res$data))
}

# Do it in a forked process. Resulting 'pid' object is the process id. Can be used with tools::pskill to stop process.

shinyApp(ui=
tagList(
actionButton("btn","Plot"),
plotOutput("plot")
)
server=function(input,output,session){
observeEvent(input$btn,{
pid <- doFork( 
  expr = expensiveFunction() , 
  feedback = feedbackFunction()
  )
})

}
```




