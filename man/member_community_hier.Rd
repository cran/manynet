% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/member_community.R
\name{member_community_hier}
\alias{member_community_hier}
\alias{node_in_betweenness}
\alias{node_in_greedy}
\alias{node_in_eigen}
\alias{node_in_walktrap}
\title{Hierarchical community partitioning algorithms}
\usage{
node_in_betweenness(.data)

node_in_greedy(.data)

node_in_eigen(.data)

node_in_walktrap(.data, times = 50)
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

\item{times}{Integer indicating number of simulations/walks used.
By default, \code{times=50}.}
}
\description{
These functions offer algorithms for hierarchically clustering
networks into communities. Since all of the following are hierarchical,
their dendrograms can be plotted:
\itemize{
\item \code{node_in_betweenness()} is a hierarchical, decomposition algorithm
where edges are removed in decreasing order of the number of
shortest paths passing through the edge.
\item \code{node_in_greedy()} is a hierarchical, agglomerative algorithm,
that tries to optimize modularity in a greedy manner.
\item \code{node_in_eigen()} is a top-down, hierarchical algorithm.
\item \code{node_in_walktrap()} is a hierarchical, agglomerative algorithm based on random walks.
}

The different algorithms offer various advantages in terms of computation time,
availability on different types of networks, ability to maximise modularity,
and their logic or domain of inspiration.
}
\section{Edge-betweenness}{

This is motivated by the idea that edges connecting different groups
are more likely to lie on multiple shortest paths when they are the
only option to go from one group to another.
This method yields good results but is very slow because of
the computational complexity of edge-betweenness calculations and
the betweenness scores have to be re-calculated after every edge removal.
Networks of ~700 nodes and ~3500 ties are around the upper size limit
that are feasible with this approach.
}

\section{Fast-greedy}{

Initially, each node is assigned a separate community.
Communities are then merged iteratively such that each merge
yields the largest increase in the current value of modularity,
until no further increases to the modularity are possible.
The method is fast and recommended as a first approximation
because it has no parameters to tune.
However, it is known to suffer from a resolution limit.
}

\section{Leading eigenvector}{

In each step, the network is bifurcated such that modularity increases most.
The splits are determined according to the leading eigenvector of the modularity matrix.
A stopping condition prevents tightly connected groups from being split further.
Note that due to the eigenvector calculations involved,
this algorithm will perform poorly on degenerate networks,
but will likely obtain a higher modularity than fast-greedy (at some cost of speed).
}

\section{Walktrap}{

The general idea is that random walks on a network are more likely to stay
within the same community because few edges lead outside a community.
By repeating random walks of 4 steps many times,
information about the hierarchical merging of communities is collected.
}

\examples{
node_in_betweenness(ison_adolescents)
node_in_greedy(ison_adolescents)
node_in_eigen(ison_adolescents)
node_in_walktrap(ison_adolescents)
}
\references{
\subsection{On edge-betweenness community detection}{

Newman, Mark, and Michelle Girvan. 2004.
"Finding and evaluating community structure in networks."
\emph{Physical Review E} 69: 026113.
\doi{10.1103/PhysRevE.69.026113}
}

\subsection{On fast-greedy community detection}{

Clauset, Aaron, Mark E.J. Newman, and Cristopher Moore. 2004.
"Finding community structure in very large networks."
\emph{Physical Review E}, 70: 066111.
\doi{10.1103/PhysRevE.70.066111}
}

\subsection{On leading eigenvector community detection}{

Newman, Mark E.J. 2006.
"Finding community structure using the eigenvectors of matrices"
\emph{Physical Review E} 74:036104.
\doi{10.1103/PhysRevE.74.036104}
}

\subsection{On walktrap community detection}{

Pons, Pascal, and Matthieu Latapy. 2005.
"Computing communities in large networks using random walks".
1-20.
\doi{10.48550/arXiv.physics/0512106}
}
}
\seealso{
Other memberships: 
\code{\link{mark_core}},
\code{\link{member_brokerage}},
\code{\link{member_cliques}},
\code{\link{member_community_non}},
\code{\link{member_components}},
\code{\link{member_equivalence}}
}
\concept{memberships}
