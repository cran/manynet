#' Measures of structural holes
#' 
#' @description
#'   These function provide different measures of the degree to which nodes
#'   fill structural holes, as outlined in Burt (1992):
#'   
#'   - `node_bridges()` measures the sum of bridges to which each node
#'   is adjacent.
#'   - `node_redundancy()` measures the redundancy of each nodes' contacts.
#'   - `node_effsize()` measures nodes' effective size.
#'   - `node_efficiency()` measures nodes' efficiency.
#'   - `node_constraint()` measures nodes' constraint scores for one-mode networks
#'   according to Burt (1992) and for two-mode networks according to Hollway et al (2020). 
#'   - `node_hierarchy()` measures nodes' exposure to hierarchy,
#'   where only one or two contacts are the source of closure.
#'   - `node_neighbours_degree()` measures nodes' average nearest neighbors degree,
#'   or \eqn{knn}, a measure of the type of local environment a node finds itself in
#'   - `tie_cohesion()` measures the ratio between common neighbors to ties'
#'   adjacent nodes and the total number of adjacent nodes,
#'   where high values indicate ties' embeddedness in dense local environments
#'   
#'   Burt's theory holds that while those nodes embedded in dense clusters
#'   of close connections are likely exposed to the same or similar ideas and information,
#'   those who fill structural holes between two otherwise disconnected groups
#'   can gain some comparative advantage from that position.
#' @details
#'   A number of different ways of measuring these structural holes are available.
#'   Note that we use Borgatti's reformulation for unweighted networks in
#'   `node_redundancy()` and `node_effsize()`.
#'   Redundancy is thus \eqn{\frac{2t}{n}}, 
#'   where \eqn{t} is the sum of ties and \eqn{n} the sum of nodes in each node's neighbourhood,
#'   and effective size is calculated as \eqn{n - \frac{2t}{n}}.
#'   Node efficiency is the node's effective size divided by its degree.
#' @name measure_holes
#' @family measures
#' @references 
#' ## On structural holes
#' Burt, Ronald S. 1992. 
#' _Structural Holes: The Social Structure of Competition_. 
#' Cambridge, MA: Harvard University Press.
#' @inheritParams mark_is
NULL

#' @rdname measure_holes 
#' @examples 
#' node_bridges(ison_adolescents)
#' node_bridges(ison_southern_women)
#' @export
node_bridges <- function(.data){
  if(missing(.data)) {expect_nodes(); .data <- .G()}
  g <- manynet::as_igraph(.data)
  .inc <- NULL
  out <- vapply(igraph::V(g), function(ego){
    length(igraph::E(g)[.inc(ego) & manynet::tie_is_bridge(g)==1])
  }, FUN.VALUE = numeric(1))
  make_node_measure(out, .data)
}

#' @rdname measure_holes 
#' @references 
#' Borgatti, Steven. 1997. 
#' “\href{http://www.analytictech.com/connections/v20(1)/holes.htm}{Structural Holes: Unpacking Burt’s Redundancy Measures}” 
#' _Connections_ 20(1):35-38.
#' 
#' Burchard, Jake, and Benjamin Cornwell. 2018. 
#' “Structural Holes and Bridging in Two-Mode Networks.” 
#' _Social Networks_ 55:11–20. 
#' \doi{10.1016/j.socnet.2018.04.001}
#' @examples 
#' node_redundancy(ison_adolescents)
#' node_redundancy(ison_southern_women)
#' @export
node_redundancy <- function(.data){
  if(missing(.data)) {expect_nodes(); .data <- .G()}
  if(manynet::is_twomode(.data)){
    mat <- manynet::as_matrix(.data)
    out <- c(.redund2(mat), .redund2(t(mat)))
  } else {
    out <- .redund(manynet::as_matrix(.data))
  }
  make_node_measure(out, .data)
}

.redund <- function(.mat){
  n <- nrow(.mat)
  qs <- .twopath_matrix(.mat > 0)
  piq <- .mat/rowSums(.mat)
  mjq <- .mat/matrix(do.call("pmax",data.frame(.mat)),n,n)
  out <- rowSums(qs * piq * mjq)
  out
}

.redund2 <- function(.mat){
  sigi <- .mat %*% t(.mat)
  diag(sigi) <- 0
  vapply(seq.int(nrow(sigi)), 
         function(x){
           xvec <- sigi[x,] #> 0
           if(manynet::is_weighted(.mat)){
             wt <- colMeans((.mat[x,] > 0 * t(.mat[xvec > 0,])) * t(.mat[xvec > 0,]) + .mat[x,]) * 2  
           } else wt <- 1
           sum(colSums(xvec > 0 & t(sigi[xvec > 0,])) * xvec[xvec > 0] / 
                 (sum(xvec) * wt))
         }, FUN.VALUE = numeric(1))
}

#' @rdname measure_holes 
#' @examples 
#' node_effsize(ison_adolescents)
#' node_effsize(ison_southern_women)
#' @export
node_effsize <- function(.data){
  if(missing(.data)) {expect_nodes(); .data <- .G()}
  if(manynet::is_twomode(.data)){
    mat <- manynet::as_matrix(.data)
    out <- c(rowSums(manynet::as_matrix(manynet::to_mode1(.data))>0), 
             rowSums(manynet::as_matrix(manynet::to_mode2(.data))>0)) - node_redundancy(.data)
  } else {
    mat <- manynet::as_matrix(.data)
    out <- rowSums(mat>0) - .redund(mat)
  }
  make_node_measure(out, .data)
}

.twopath_matrix <- function(.data){
  .data <- manynet::as_matrix(.data)
  qs <- .data %*% t(.data)
  diag(qs) <- 0
  qs
}


#' @rdname measure_holes 
#' @examples 
#' node_efficiency(ison_adolescents)
#' node_efficiency(ison_southern_women)
#' @export
node_efficiency <- function(.data){
  if(missing(.data)) {expect_nodes(); .data <- .G()}
  out <- node_effsize(.data) / node_degree(.data, normalized = FALSE)
  make_node_measure(as.numeric(out), .data)
}

#' @rdname measure_holes 
#' @references
#' Hollway, James, Jean-Frédéric Morin, and Joost Pauwelyn. 2020.
#' "Structural conditions for novelty: The introduction of new environmental clauses to the trade regime complex."
#' _International Environmental Agreements: Politics, Law and Economics_ 20 (1): 61–83.
#' \doi{10.1007/s10784-019-09464-5}
#' @examples
#' node_constraint(ison_southern_women)
#' @export 
node_constraint <- function(.data) {
  if(missing(.data)) {expect_nodes(); .data <- .G()}
  if (manynet::is_twomode(.data)) {
    get_constraint_scores <- function(mat) {
      inst <- colnames(mat)
      rowp <- mat * matrix(1 / rowSums(mat), nrow(mat), ncol(mat))
      colp <- mat * matrix(1 / colSums(mat), nrow(mat), ncol(mat), byrow = T)
      res <- vector()
      for (i in inst) {
        ci <- 0
        membs <- names(which(mat[, i] > 0))
        for (a in membs) {
          pia <- colp[a, i]
          oth <- membs[membs != a]
          pbj <- 0
          if (length(oth) == 1) {
            for (j in inst[mat[oth, ] > 0 & inst != i]) {
              pbj <- sum(pbj, sum(colp[oth, i] * rowp[oth, j] * colp[a, j]))
            }
          } else {
            for (j in inst[colSums(mat[oth, ]) > 0 & inst != i]) {
              pbj <- sum(pbj, sum(colp[oth, i] * rowp[oth, j] * colp[a, j]))
            }
          }
          cia <- (pia + pbj)^2
          ci <- sum(ci, cia)
        }
        res <- c(res, ci)
      }
      names(res) <- inst
      res
    }
    inst.res <- get_constraint_scores(manynet::as_matrix(.data))
    actr.res <- get_constraint_scores(t(manynet::as_matrix(.data)))
    res <- c(actr.res, inst.res)
  } else {
    res <- igraph::constraint(manynet::as_igraph(.data), 
                              nodes = igraph::V(.data), 
                              weights = NULL)
  }
  res <- make_node_measure(res, .data)
  res
}

#' @rdname measure_holes 
#' @examples 
#' node_hierarchy(ison_adolescents)
#' node_hierarchy(ison_southern_women)
#' @export
node_hierarchy <- function(.data){
  if(missing(.data)) {expect_nodes(); .data <- .G()}
  cs <- node_constraint(.data)
  g <- manynet::as_igraph(.data)
  out <- vapply(igraph::V(g), function(ego){
    n = igraph::neighbors(g, ego)
    N <- length(n)
    css <- cs[n]
    CN <- mean(css)
    rj <- css/CN
    sum(rj*log(rj)) / (N * log(N))
  }, FUN.VALUE = numeric(1))
  out[is.nan(out)] <- 0
  make_node_measure(out, .data)
}

#' @rdname measure_holes 
#' @importFrom igraph knn
#' @references
#' ## On neighbours average degree
#' Barrat, Alain, Marc Barthelemy, Romualdo Pastor-Satorras, and Alessandro Vespignani. 2004.
#' "The architecture of complex weighted networks",
#' _Proc. Natl. Acad. Sci._ 101: 3747.
#' @export
node_neighbours_degree <- function(.data){
  if(missing(.data)) {expect_nodes(); .data <- .G()}
  out <- igraph::knn(manynet::as_igraph(.data),
                              mode = "out")$knn
  make_node_measure(out, .data)
}

#' @rdname measure_holes 
#' @export
tie_cohesion <- function(.data){
  if(missing(.data)) {expect_nodes(); .data <- .G()}
  ties <- igraph::E(.data)
  coins <- data.frame(heads = igraph::head_of(.data, ties),
                      tails = igraph::tail_of(.data, ties))
  out <- apply(coins, 1, 
        function(x){
          neigh1 <- igraph::neighbors(.data, x[1])
          neigh2 <- igraph::neighbors(.data, x[2])
          shared_nodes <- sum(c(neigh1 %in% neigh2, 
                                neigh2 %in% neigh1))/2
          neigh_nodes <- length(unique(c(neigh1, neigh2)))-2
          shared_nodes / neigh_nodes
        } )
  make_node_measure(out, .data)
}
