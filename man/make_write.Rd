% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_read.R
\name{make_write}
\alias{make_write}
\alias{write_matrix}
\alias{write_edgelist}
\alias{write_nodelist}
\alias{write_pajek}
\alias{write_ucinet}
\alias{write_graphml}
\title{Making networks to external files}
\source{
\code{write_ucinet()} kindly supplied by Christian Steglich,
constructed on 18 June 2015.
}
\usage{
write_matrix(.data, filename, ...)

write_edgelist(.data, filename, ...)

write_nodelist(.data, filename, ...)

write_pajek(.data, filename, ...)

write_ucinet(.data, filename, name)

write_graphml(.data, filename, ...)
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

\item{filename}{Character string filename.
If missing, the files will have the same name as the object
and be saved to the working directory.
An appropriate extension will be added if not included.}

\item{...}{Additional parameters passed to the write function.}

\item{name}{Character string to name the network internally, e.g. in UCINET.
By default the name will be the same as the object.}
}
\value{
The \code{write_}functions export to different file formats,
depending on the function.

A pair of UCINET files in V6404 file format (.##h, .##d)
}
\description{
Researchers may want to save or work with networks outside R.
The following functions offer ways to export to some common external
file formats:
\itemize{
\item \code{write_matrix()} exports an adjacency matrix to a .csv file.
\item \code{write_edgelist()} exports an edgelist to a .csv file.
\item \code{write_nodelist()} exports a nodelist to a .csv file.
\item \code{write_pajek()} exports Pajek .net files.
\item \code{write_ucinet()} exports a pair of UCINET files in V6404 file format (.##h, .##d).
\item \code{write_graphml()} exports GraphML files.
}
}
\details{
Note that these functions are not as actively maintained as others
in the package, so please let us know if any are not currently working
for you or if there are missing import routines
by \href{https://github.com/stocnet/manynet/issues}{raising an issue on Github}.
}
\seealso{
\link{as}

Other makes: 
\code{\link{make_cran}},
\code{\link{make_create}},
\code{\link{make_ego}},
\code{\link{make_explicit}},
\code{\link{make_learning}},
\code{\link{make_motifs}},
\code{\link{make_play}},
\code{\link{make_random}},
\code{\link{make_read}},
\code{\link{make_stochastic}}
}
\concept{makes}
