# Shiny asynchronous jobs

Experiemental work on forked computation in a shiny app using the package "parallel".

Does not work on windows.


### Example

```{sh}
Rscript run.R
```

![demo dofork](https://raw.githubusercontent.com/fxi/doFork/master/www/dofork_demo.gif "DoFork demo")


### Simple app


```{R}

#
# ui
#
ui <- bootstrapPage(
  tagList(
    actionButton("btnTest","Click here"),
    textOutput("txtTest")
    )
  )

#
# server
#
server <- function(input,output,session){

  observeEvent(input$btnTest,{

    #
    # Launch doFork
    #
    doFork(
      refreshRateSeconds = 1,
      maxTimeSeconds = 5, 
      expr = {
        #
        # Here goes the code to evaluate in the fork
        #

        # Pass a list to the message function. 
        doForkMessage(
          list(
            text="Please wait"
            )
          )

        # Do something expensive
        Sys.sleep(2)

        # Return something
        return(runif(1))

      },
      onMessage = function( msg ){
        #
        # This function will handle the messages send during computation
        #
        updateActionButton(session,
          inputId="btnTest",
          label=msg$text
          )
      },
      onFeedback = function( res ){
        #
        # This function will handle the results (res$data)
        #
        output$txtTest <- renderText(res$data)
        updateActionButton(session,
          inputId="btnTest",
          label="Click here"
          )
      })
  })

  #
  # On exit, collect the remaining result (if any)
  #
  on.exit(mccollect())
}

shinyApp(ui=ui,server=server)


```


