#' Open and extract code from tutorials
#' 
#' @description 
#'   These functions make it easy to use the tutorials
#'   in the `{manynet}` and `{migraph}` packages.
#' @param tute String, name of the tutorial (e.g. "tutorial2").
#' @importFrom dplyr %>% as_tibble select
#' @name tutorials
NULL

#' @describeIn tutorials Runs a `{learnr}` tutorial from 
#'   either the `{manynet}` or `{migraph}` packages,
#'   wraps `learnr::run_tutorial()` with some convenience
#' @examples
#' #run_tute("tutorial2")
#' @export
run_tute <- function(tute) {
  thisRequires("learnr")
  if (missing(tute)) {
    t1 <- dplyr::as_tibble(learnr::available_tutorials(package = "manynet"),
                           silent = TRUE) %>% dplyr::select(1:3)
    t2 <- dplyr::as_tibble(learnr::available_tutorials(package = "migraph"),
                           silent = TRUE) %>% dplyr::select(1:3)
    rbind(t1, t2)
  } else {
    try(learnr::run_tutorial(tute, "manynet"), silent = TRUE)
    try(learnr::run_tutorial(tute, "migraph"), silent = TRUE)
    cat("Didn't find a direct match, so looking for close matches...")
    t1 <- dplyr::as_tibble(learnr::available_tutorials(package = "manynet"),
                           silent = TRUE) %>% dplyr::select(1:3)
    t2 <- dplyr::as_tibble(learnr::available_tutorials(package = "migraph"),
                           silent = TRUE) %>% dplyr::select(1:3)
    avails <- rbind(t1, t2)
    inftit <- grepl(tute, avails$title, ignore.case = TRUE)
    if(!any(inftit) | sum(inftit)>1)
      inftit <- which.min(utils::adist(tute, avails$title, ignore.case = TRUE))
    if(any(inftit) & sum(inftit)==1){
      cat(" and found one!")
      try(learnr::run_tutorial(avails$name[inftit], avails$package[inftit]), silent = TRUE)
    } else{
      cat(" and couldn't find which one you meant. Please specify one of these titles:\n")
      print(avails)
    }
  }
}

#' @describeIn tutorials Extracts and opens just the solution code
#'   from a `{manynet}` or `{migraph}` tutorial,
#'   saving the .R script to the current working directory
#' @examples
#' #extract_tute("tutorial2")
#' @export
extract_tute <- function(tute) {
  if (missing(tute)) {
    thisRequires("learnr")
    t1 <- dplyr::as_tibble(learnr::available_tutorials(package = "manynet"),
                           silent = TRUE) %>% dplyr::select(1:3)
    t2 <- dplyr::as_tibble(learnr::available_tutorials(package = "migraph"),
                           silent = TRUE) %>% dplyr::select(1:3)
    rbind(t1, t2)
  } else {
    thisRequires("knitr")
    pth <- file.path(path.package("manynet"), "tutorials", tute)
    if(!dir.exists(pth)) {
      thisRequires("migraph")
      pth <- gsub("manynet", "migraph", pth)
    }
    knitr::purl(file.path(pth, list.files(pth, pattern = "*.Rmd")),
                documentation = 1)
    utils::file.edit(gsub(".Rmd", ".R", list.files(pth, pattern = "*.Rmd")))
  }
}

