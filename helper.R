
#' Exacute expression in a forked process (unix only)
#' @param expr {expression} Expression to evaluate
#' @param feedback {function} Function with one argument, 'res', to handle worker feedback. 'res'  is a list with two member : data and message. 
#' @param onMessage {function} Function with one argument, 'res', to handle worker messages. 'res' is a list with two member : time and message. This is produced by doForkMessage.
#' @param refreshRateSeconds {numeric} Number of second between read refresh
#' @param maxTimeSeconds {numeric} Maximum time for the process before ending. 
#' @return process pid
#' @export
doFork <- function(expr, onFeedback=NULL, onMessage=NULL, refreshRateSeconds= 1, maxTimeSeconds = Inf ){
  library(parallel)

  id <- doForkMakeId()
  filePath <- file.path(tempdir(),sprintf("doFork_%s",id))   
  file.create(filePath)

  jobFun <- shiny:::exprToFunction({
    session <- getDefaultReactiveDomain()
    input <- session$input
    file <- filePath 
    expr
  })

  job <- mcparallel({
    jobFun()
  })

  # Get current time
  start <- Sys.time()
  # List in output
  res <- list(
    data = NULL,
    error = NULL,
    message = NULL
    )

  # Internal nested observer. 
  observe({
    tryCatch({
      # init message list
      msg <- list(
        id = sprintf("doFork_%s",job$pid)
        )
      # get diff time
      elapsed <- as.numeric(
        Sys.time() - start,
        units="secs"
        )

      # test for timeout and ollect result
      if( isTRUE( elapsed > maxTimeSeconds ) ){
        res$error <- sprintf(
          "Timeout. Process took more than %s [s]"
          , maxTimeSeconds
          )
      }else{
        res$data <- mccollect(
          jobs = job, 
          wait = F
          )[[1]]
      }

      # Read message if any
      tryCatch({

        m <- readLines(filePath)

        if(length(m)>0 && !is.null(m) && !is.na(m)){
          m <- jsonlite::fromJSON(m)
          msg <- c( msg , m )
          onMessage( msg )
        }
      },error=function(c){
        warning(c$message)
      })
      # evaluate result

      if(all(sapply(res,is.null))){
        invalidateLater( millis = refreshRateSeconds*1000 )
      }else{
        if(class(res$data)=="try-error") res$error <- as.character(res$data)
        if( !is.null( res$error )) stop( res$error )
        tools::pskill( job$pid )
        onFeedback( res )
      }
    },error = function(c){
      tools::pskill(job$pid)
      #close(con)
      stop(c$message)
    })
  })
  return(job$pid)
}


doForkMakeId <- function(n=5){
  paste0(letters[ceiling(runif(n)*26)],collapse="")
}


doForkMessage <- function(message=NULL){

  if( is.null(message) || !is.list(message)) return()

  e <- parent.frame()

  m <- jsonlite:::toJSON(message)

  write(m,e$file)

}


