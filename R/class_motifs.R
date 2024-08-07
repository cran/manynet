make_node_motif <- function(out, .data) {
  class(out) <- c("node_motif", class(out))
  attr(out, "mode") <- node_is_mode(.data)
  out
}

make_network_motif <- function(out, .data) {
  class(out) <- c("network_motif", class(out))
  attr(out, "mode") <- net_dims(.data)
  out
}

#' @export
print.node_motif <- function(x, ...,
                         n = 6,
                         digits = 3) {
  if(!is.null(attr(x, "dimnames")[[1]])){
    x <- data.frame(names = attr(x, "dimnames")[[1]], x)
  }
  if (any(attr(x, "mode"))) {
    print(dplyr::tibble(as.data.frame(x)[!attr(x, "mode")]), n = n)
    print(dplyr::tibble(as.data.frame(x)[attr(x, "mode")]), n = n)
  } else {
    print(dplyr::tibble(as.data.frame(x)), n = n)
  }
}

# summary(node_by_triad(mpn_elite_mex),
#         membership = node_regular_equivalence(mpn_elite_mex, "elbow"))
#' @export
summary.node_motif <- function(object, ...,
                                membership,
                                FUN = mean) {
  out <- t(sapply(unique(membership), function(x) {
    if (sum(membership==x)==1) object[membership==x,]
    else apply(object[membership == x, ], 2, FUN)
  }))
  rownames(out) <- paste("Block", unique(membership))
  dplyr::tibble(as.data.frame(out))
}

#' @export
print.network_motif <- function(x, ...) {
  names <- list(names(x))
  x <- as.numeric(x)
  mat <- matrix(x, dimnames = names)
  mat <- t(mat)
  out <- as.data.frame(mat)
  print(dplyr::tibble(out))
}
