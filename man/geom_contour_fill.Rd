% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom_contour_fill.R, R/stat_contour_fill.R
\name{geom_contour_fill}
\alias{geom_contour_fill}
\alias{stat_contour_fill}
\title{Filled 2d contours of a 3d surface}
\usage{
geom_contour_fill(mapping = NULL, data = NULL, stat = "ContourFill",
  position = "identity", ..., breaks = NULL, bins = NULL,
  binwidth = NULL, na.rm = FALSE, circular = NULL, show.legend = NA,
  inherit.aes = TRUE)

stat_contour_fill(mapping = NULL, data = NULL, geom = "ContourFill",
  position = "identity", ..., breaks = scales::fullseq, bins = NULL,
  binwidth = NULL, na.rm = FALSE, circular = NULL, show.legend = NA,
  inherit.aes = TRUE)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by \code{\link[=aes]{aes()}} or
\code{\link[=aes_]{aes_()}}. If specified and \code{inherit.aes = TRUE} (the
default), it is combined with the default mapping at the top level of the
plot. You must supply \code{mapping} if there is no plot mapping.}

\item{data}{The data to be displayed in this layer. There are three
options:

If \code{NULL}, the default, the data is inherited from the plot
data as specified in the call to \code{\link[=ggplot]{ggplot()}}.

A \code{data.frame}, or other object, will override the plot
data. All objects will be fortified to produce a data frame. See
\code{\link[=fortify]{fortify()}} for which variables will be created.

A \code{function} will be called with a single argument,
the plot data. The return value must be a \code{data.frame.}, and
will be used as the layer data.}

\item{stat}{The statistical transformation to use on the data for this
layer, as a string.}

\item{position}{Position adjustment, either as a string, or the result of
a call to a position adjustment function.}

\item{...}{other arguments passed on to \code{\link[=layer]{layer()}}. These are
often aesthetics, used to set an aesthetic to a fixed value, like
\code{color = "red"} or \code{size = 3}. They may also be parameters
to the paired geom/stat.}

\item{breaks}{numeric vector of breaks}

\item{bins}{Number of evenly spaced breaks.}

\item{binwidth}{Distance between breaks.}

\item{na.rm}{If \code{FALSE}, the default, missing values are removed with
a warning. If \code{TRUE}, missing values are silently removed.}

\item{circular}{either NULL, "x" or "y" indicating which dimension is circular,
if any.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.
It can also be a named logical vector to finely select the aesthetics to
display.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link[=borders]{borders()}}.}

\item{geom}{The geometric object to use display the data}
}
\description{
While ggplot2's \code{\link[ggplot2]{geom_contour}} can plot nice contours, it
doesn't work with the polygon geom. This stat makes some small manipulation
of the data to ensure that all contours are closed and also computes a new
aesthetic \code{int.level}, which differs from \code{level} (computed by
\link[ggplot2:geom_contour]{ggplot2::geom_contour}) in that represents
the value of the \code{z} aesthetic \emph{inside} the contour instead of at the edge.
}
\section{Aesthetics}{

\code{geom_contour_fill} understands the following aesthetics (required aesthetics are in bold):

\itemize{
\item \strong{x}
\item \strong{y}
\item \code{alpha}
\item \code{colour}
\item \code{group}
\item \code{linetype}
\item \code{size}
\item \code{weight}
}
}

\section{Computed variables}{

\describe{
\item{int.level}{value of the interior contour}
}
}

\examples{
library(ggplot2)
surface <- reshape2::melt(volcano)
ggplot(surface, aes(Var1, Var2, z = value)) +
  geom_contour_fill() +
  geom_contour(color = "black", size = 0.1)

# Plots only deviations from the mean.
ggplot(surface, aes(Var1, Var2, z = as.numeric(scale(value)))) +
  geom_contour_fill(complete = FALSE, exclude = 0)

# If one uses level instead of int.level, one of the small
# contours near the crater disapears
ggplot(surface, aes(Var1, Var2, z = value)) +
  geom_contour_fill(aes(fill = ..level..))



}
\seealso{
Other ggplot2 helpers: \code{\link{DivideTimeseries}},
  \code{\link{MakeBreaks}}, \code{\link{RepeatCircular}},
  \code{\link{geom_arrow}}, \code{\link{geom_contour2}},
  \code{\link{geom_label_contour}},
  \code{\link{geom_relief}}, \code{\link{geom_streamline}},
  \code{\link{geom_vector}},
  \code{\link{guide_colourstrip}},
  \code{\link{map_labels}}, \code{\link{reverselog_trans}},
  \code{\link{scale_divergent}},
  \code{\link{scale_longitude}}, \code{\link{stat_na}},
  \code{\link{stat_subset}}
}
\concept{ggplot2 helpers}
