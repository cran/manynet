# Tutorials overview ####

#' Open and extract code from tutorials
#' 
#' @description 
#'   These functions make it easy to use the tutorials
#'   in the `{manynet}` and `{migraph}` packages:
#'   
#'   - `run_tute()` runs a `{learnr}` tutorial from 
#'   either the `{manynet}` or `{migraph}` packages,
#'   wraps `learnr::run_tutorial()` with some convenience.
#'   - `extract_tute()` extracts and opens just the solution code
#'   from a `{manynet}` or `{migraph}` tutorial,
#'   saving the .R script to the current working directory.
#'   
#' @param tute String, name of the tutorial (e.g. "tutorial2").
#' @importFrom dplyr %>% as_tibble select tibble
#' @name tutorials
NULL

#' @rdname tutorials 
#' @examples
#' #run_tute("tutorial2")
#' @export
run_tute <- function(tute) {
  thisRequires("learnr")
  if (missing(tute)) {
    name <- NULL
    t1 <- dplyr::as_tibble(learnr::available_tutorials(package = "manynet"),
                           silent = TRUE) %>% dplyr::select(1:3)
    t2 <- dplyr::as_tibble(learnr::available_tutorials(package = "migraph"),
                           silent = TRUE) %>% dplyr::select(1:3)
    rbind(t1, t2) %>% dplyr::arrange(name) 
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

#' @rdname tutorials 
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

# Data overview ####

#' Obtain overview of available network data
#' 
#' @description 
#'   This function makes it easy to get an overview of available data:
#'   
#'   - `table_data()` returns a tibble with details of the
#'   network datasets included in the packages.
#'   
#' @param pkg String, name of the package.
#' @importFrom dplyr %>% as_tibble select tibble
#' @name data_overview
NULL

#' @rdname data_overview 
#' @examples
#' table_data()
#' # to obtain list of all e.g. two-mode networks:
#' table_data() %>% 
#'   dplyr::filter(directed)
#' # to obtain overview of unique datasets:
#' table_data() %>% 
#'   dplyr::distinct(directed, weighted, twomode, signed, 
#'                  .keep_all = TRUE)
#' @export
table_data <- function(pkg = "manynet") {
  nodes <- NULL
  datanames <- utils::data(package = pkg)$results[,"Item"]
  require(package = pkg, character.only = TRUE)
  datasets <- lapply(datanames, function(d) get(d))
  datanames <- datanames[!vapply(datasets, is_list, logical(1))]
  datasets <- datasets[!vapply(datasets, is_list, logical(1))]
  out <- dplyr::tibble(dataset = tibble::char(datanames, min_chars = 18),
                        nodes = vapply(datasets, net_nodes, numeric(1)),
                        ties = vapply(datasets, net_ties, numeric(1)),
                        nattr = vapply(datasets, 
                                            function (x) length(net_node_attributes(x)), 
                                            numeric(1)),
                        tattr = vapply(datasets, 
                                            function (x) length(net_tie_attributes(x)), 
                                            numeric(1)),
                        directed = vapply(datasets, 
                                        is_directed, 
                                        logical(1)),
                        weighted = vapply(datasets, 
                                          is_weighted, 
                                          logical(1)),
                        twomode = vapply(datasets, 
                                            is_twomode, 
                                            logical(1)),
                        labelled = vapply(datasets, 
                                          is_labelled, 
                                          logical(1)),
                        signed = vapply(datasets, 
                                          is_signed, 
                                          logical(1)),
                        multiplex = vapply(datasets, 
                                        is_multiplex, 
                                        logical(1)),
                       acyclic = vapply(datasets, 
                                          is_acyclic, 
                                          logical(1)),
                       attributed = vapply(datasets, 
                                           is_attributed, 
                                           logical(1)))
  out <- dplyr::arrange(out, nodes)
  out
}