% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mark_ties.R
\name{mark_ties}
\alias{mark_ties}
\alias{tie_is_multiple}
\alias{tie_is_loop}
\alias{tie_is_reciprocated}
\alias{tie_is_feedback}
\alias{tie_is_bridge}
\title{Marking ties based on structural properties}
\usage{
tie_is_multiple(.data)

tie_is_loop(.data)

tie_is_reciprocated(.data)

tie_is_feedback(.data)

tie_is_bridge(.data)
}
\arguments{
\item{.data}{An object of a manynet-consistent class:
\itemize{
\item matrix (adjacency or incidence) from \code{{base}} R
\item edgelist, a data frame from \code{{base}} R or tibble from \code{{tibble}}
\item igraph, from the \code{{igraph}} package
\item network, from the \code{{network}} package
\item tbl_graph, from the \code{{tidygraph}} package
}}
}
\description{
These functions return logical vectors the length of the ties
in a network identifying which hold certain properties or positions in the network.
\itemize{
\item \code{tie_is_multiple()} marks ties that are multiples.
\item \code{tie_is_loop()} marks ties that are loops.
\item \code{tie_is_reciprocated()} marks ties that are mutual/reciprocated.
\item \code{tie_is_feedback()} marks ties that are feedback arcs causing the network to not be acyclic.
\item \code{tie_is_bridge()} marks ties that cut or act as articulation points in a network.
}

They are most useful in highlighting parts of the network that
are particularly well- or poorly-connected.
}
\examples{
tie_is_multiple(ison_marvel_relationships)
tie_is_loop(ison_marvel_relationships)
tie_is_reciprocated(ison_algebra)
tie_is_feedback(ison_algebra)
tie_is_bridge(ison_brandes)
}
\seealso{
Other marks: 
\code{\link{mark_diff}},
\code{\link{mark_nodes}},
\code{\link{mark_select}},
\code{\link{mark_tie_select}}
}
\concept{marks}
