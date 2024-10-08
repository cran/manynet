% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_read.R
\name{make_cran}
\alias{make_cran}
\alias{read_cran}
\title{Making networks of package dependencies}
\source{
https://www.r-bloggers.com/2016/01/r-graph-objects-igraph-vs-network/
}
\usage{
read_cran(pkg = "all")
}
\arguments{
\item{pkg}{The name}
}
\description{
Researchers regularly need to work with a variety of external data formats.
The following functions offer ways to import from some common external
file formats into objects that \code{{manynet}} and other graph/network packages
in R can work with:
\itemize{
\item \code{read_matrix()} imports adjacency matrices from Excel/csv files.
\item \code{read_edgelist()} imports edgelists from Excel/csv files.
\item \code{read_nodelist()} imports nodelists from Excel/csv files.
\item \code{read_pajek()} imports Pajek (.net or .paj) files.
\item \code{read_ucinet()} imports UCINET files from the header (.##h).
\item \code{read_dynetml()} imports DyNetML interchange format for rich social network data.
\item \code{read_graphml()} imports GraphML files.
}
}
\details{
Note that these functions are not as actively maintained as others
in the package, so please let us know if any are not currently working
for you or if there are missing import routines
by \href{https://github.com/stocnet/manynet/issues}{raising an issue on Github}.
}
\examples{
# mnet <- read_cran()
# mnet <- to_ego(mnet, "manynet", max_dist = 2)
# graphr(mnet, layout = "hierarchy", 
#        edge_color = "type", node_color = "Compilation")
}
\seealso{
\link{as}

Other makes: 
\code{\link{make_create}},
\code{\link{make_ego}},
\code{\link{make_explicit}},
\code{\link{make_learning}},
\code{\link{make_motifs}},
\code{\link{make_play}},
\code{\link{make_random}},
\code{\link{make_read}},
\code{\link{make_stochastic}},
\code{\link{make_write}}
}
\concept{makes}
