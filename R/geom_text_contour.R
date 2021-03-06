#' Label contours
#'
#' Draws labels on contours built with [ggplot2::stat_contour].
#'
#' @inheritParams ggplot2::geom_text
#' @inheritParams ggplot2::geom_label
#' @param min.size minimum number of points for a contour to be labeled.
#' @param skip number of contours to skip
#' @param rotate logical indicating wether to rotate text following the contour.
#'
#' @details
#' Is best used with a previous call to [ggplot2::stat_contour] with the same
#' parameters.
#' Note that while `geom_text_contour()` can angle itself to follow the contour,
#' this is not the case with `geom_label_contour()`.
#'
#' @examples
#' library(ggplot2)
#' v <- data.table::melt(volcano)
#' g <- ggplot(v, aes(Var1, Var2)) +
#'        geom_contour(aes(z = value))
#' g + geom_text_contour(aes(z = value, label = ..level..))
#'
#' # Small hack, best used with uniform background
#' geom_label_contour2 <- function(...) {
#'     list(geom_label_contour(fill = "white", label.r = unit(0, "lines"),
#'                             label.padding = unit(0.04, "lines"), color = NA, ...),
#'          geom_text_contour(..., rotate = FALSE))
#' }
#' g + geom_label_contour2(aes(z = value, label = ..level..)) +
#'    theme_void()
#'
#' @section Aesthetics:
#' \code{geom_text_contour} understands the following aesthetics (required aesthetics are in bold):
#'
#' \itemize{
#' \item \strong{x}
#' \item \strong{y}
#' \item \strong{label}
#' \item \code{alpha}
#' \item \code{angle}
#' \item \code{colour}
#' \item \code{family}
#' \item \code{fontface}
#' \item \code{group}
#' \item \code{hjust}
#' \item \code{lineheight}
#' \item \code{size}
#' \item \code{vjust}
#'}
#'
#'
#' @export
#' @import ggplot2 data.table
#' @family ggplot2 helpers
geom_text_contour <- function(mapping = NULL, data = NULL,
                      stat = "text_contour",
                      position = "identity",
                      ...,
                      min.size = 10,
                      skip = 1,
                      rotate = TRUE,
                      parse = FALSE,
                      nudge_x = 0,
                      nudge_y = 0,
                      check_overlap = FALSE,
                      na.rm = FALSE,
                      show.legend = NA,
                      inherit.aes = TRUE)
{
    if (!missing(nudge_x) || !missing(nudge_y)) {
        if (!missing(position)) {
            stop("Specify either `position` or `nudge_x`/`nudge_y`", call. = FALSE)
        }

        position <- position_nudge(nudge_x, nudge_y)
    }

    layer(
        data = data,
        mapping = mapping,
        stat = stat,
        geom = GeomTextContour,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(
            skip = skip,
            min.size = min.size,
            rotate = rotate,
            parse = parse,
            check_overlap = check_overlap,
            na.rm = na.rm,
            ...
        )
    )
}


# from https://stackoverflow.com/questions/21868353/drawing-labels-on-flat-section-of-contour-lines-in-ggplot2
minvar <- function (x, y){
    N <- length(x)
    xdiffs <- x[2:N] - x[1:(N-1)]
    ydiffs <- y[2:N] - y[1:(N-1)]
    avgGradient <- ydiffs/xdiffs
    squareSum <- avgGradient * avgGradient
    variance <- (squareSum - (avgGradient * avgGradient) / N / N)
    variance <- c(NA, NA, variance[3:(N-2)], NA, NA)
    return(variance == min(variance, na.rm = T))
}

GeomTextContour <- ggproto("GeomTextContour", Geom,
   required_aes = c("x", "y", "label"),
   default_aes = ggplot2::aes(colour = "black", size = 3.88, angle = 0, hjust = 0.5,
                     vjust = 0.5, alpha = NA, family = "", fontface = 1,
                     lineheight = 1.2),

   draw_panel = function(data, panel_params, coord, parse = FALSE,
                         na.rm = FALSE, check_overlap = FALSE, min.size = 20,
                         skip = 1, rotate = TRUE) {
       data <- data.table::as.data.table(coord$transform(data, panel_params))

       breaks <- unique(data$level)
       breaks.keep <- breaks[seq(1, length(breaks), by = skip + 1)]
       data <- data[level %in% breaks.keep]

       data[, N := .N, by = piece]
       data <- data[N >= min.size]

       if (rotate) data[, angle := .cont.angle(x, y), by = piece]

       data[, var := minvar(x, y), by = .(piece)]
       data <- data[var == T][, head(.SD, 1), by = piece]

       lab <- data$label
       if (parse) {
           lab <- parse(text = as.character(lab))
       }

       if (is.character(data$vjust)) {
           data$vjust <- ggplot2:::compute_just(data$vjust, data$y)
       }
       if (is.character(data$hjust)) {
           data$hjust <- ggplot2:::compute_just(data$hjust, data$x)
       }

       grid::textGrob(
           lab,
           data$x, data$y, default.units = "native",
           hjust = data$hjust, vjust = data$vjust,
           rot = data$angle,
           gp = grid::gpar(
               col = alpha(data$colour, data$alpha),
               fontsize = data$size * .pt,
               fontfamily = data$family,
               fontface = data$fontface,
               lineheight = data$lineheight
           ),
           check.overlap = check_overlap
       )
   },

   draw_key = draw_key_text
)


.cont.angle <- function(x, y) {
    N <- length(x)
    dx <- x[c(2:N, 1)] - x[c(N, 1:(N-1))]
    dy <- y[c(2:N, 1)] - y[c(N, 1:(N-1))]
    angle <- atan2(dy, dx)*180/pi
    # angle <- ifelse(angle > 180, angle - 180, angle)
    angle <- ifelse(angle > 90, angle - 180, angle)
    angle <- ifelse(angle < -90, angle + 180, angle)
    angle
}


