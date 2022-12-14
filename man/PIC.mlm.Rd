% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PIC.R
\name{PIC.mlm}
\alias{PIC.mlm}
\title{PIC method for Multivariable Linear Models}
\usage{
\method{PIC}{mlm}(object, newdata, group_sizes = NULL, bootstraps = NULL, ...)
}
\arguments{
\item{object}{A fitted model object of \code{\link[base]{class}} "mlm".}

\item{newdata}{An optional dataframe to be used as validation data in computing PIC. If omitted, the training data contained within \code{object} are used. If specified, \strong{\code{newdata}} must contain columns for each model response. See 'Details'.}

\item{group_sizes}{An optional scalar or numeric vector indicating the sizes of \code{newdata} partitions. If omitted, \code{newdata} is not partitioned. See 'Details'.}

\item{bootstraps}{An optional numeric value indicating the number of bootstrap samples to use for a bootstrapped PIC. See 'Details'.}

\item{...}{Further arguments passed to or from other methods.}
}
\value{
If \code{group_sizes = NULL} or \code{bootstraps > 0}, a scalar is returned. Otherwise, \code{newdata} is
returned with an appended column labeled 'PIC' containing either iPIC or gPIC values,
depending on the value provided to \code{group_sizes}.
}
\description{
Computation of predictive information criteria for multivariable linear models. Currently, computations are
supported for only bivariable linear models.
}
\details{
\code{PIC.mlm} computes PIC values based on the supplied multivariable regression model. Candidate models with relatively smaller criterion values are preferred.
Depending on the value(s) supplied to \strong{\code{group_sizes}}, one of three implementations of PIC are computed:

\itemize{
\item \strong{iPIC}: The individualized predictive information criterion (iPIC) is computed when \strong{\code{group_sizes = 1}}. A value
of iPIC is determined for each \emph{individual} observation in \strong{\code{newdata}}. Using iPIC, one may thus select optimal predictive
models specific to each particular validation datapoint.

\item \strong{gPIC}: The group predictive information criterion (gPIC) is computed when \strong{\code{group_sizes > 1}} or
\strong{\code{is.vector(group_sizes) == TRUE}}. A value of gPIC is determined for each cohort or \emph{group} of observations
defined by the partitions of \strong{\code{newdata}}. Using gPIC, one may thus select optimal predictive models specific to each
group of validation datapoints. For the class of regression models, the gPIC value of a group of validation observations
is equivalent to the sum of their individual iPIC values.

\item \strong{tPIC}: The total predictive information criterion (tPIC) is computed when \strong{\code{group_sizes = NULL}}. Computation of
the tPIC is the default, and one may use the tPIC to select the optimal predictive model for the entire set of validation
datapoints. The tPIC and gPIC are equivalent when \strong{\code{group_sizes = m}}, where \code{m} is the number of observations in
\strong{\code{newdata}}. When \strong{\code{newdata}} is not supplied, tPIC is exactly equivalent to the Akaike Information Criterion (\link[stats]{AIC}).
}

Distinct from the computation for the class of "lm" models (\link[picR]{PIC.lm}), the PIC computation for multivariable regression models differs
depending on the whether validation data are partially or completely unobserved. If partially unobserved, where only some values of the multivariable response vector
are unknown/unobserved, any remaining observed values are used in the PIC computation.

If a numeric value is supplied to \strong{\code{bootstraps}} the total Predictive information criterion (tPIC) is computed \strong{\code{bootstraps}} times, where
generated bootstrap samples are each used as sets of validation data in computing the tPIC. It is assumed that the multivariable response vectors are each
completely unobserved. The resulting tPIC values are then averaged to generate a single,
bootstrapped tPIC value. Model selection based on this bootstrapped tPIC value may lead to the selection of a more generally applicable predictive model whose
predictive accuracy is not strictly optimized to a particular set of validation data.

For further details, see \href{https://iro.uiowa.edu/esploro/outputs/doctoral/A-new-class-of-information-criteria/9984097169902771?institution=01IOWA_INST}{\emph{A new class of information criteria for improved prediction in the presence of training/validation data heterogeneity}}.
}
\examples{
require(dplyr, quietly = TRUE)
data(iris)

# Fit a bivariable regression model
mod <- lm(cbind(Sepal.Length, Sepal.Width) ~ ., data = iris)
class(mod)

# Hypothetical validation data
set.seed(1)
vdat <- iris[sample(1:nrow(iris), 10),]

# tPIC, completely unobserved response data
PIC(object = mod, newdata = vdat \%>\% dplyr::mutate(Sepal.Length = NA, Sepal.Width = NA))

# tPIC, partially unobserved response data
PIC(object = mod, newdata = vdat \%>\% dplyr::mutate(Sepal.Length = NA))

# tPIC, mix of completely and partially unobserved cases.
PIC(object = mod, newdata = vdat \%>\%
dplyr::mutate(Sepal.Length = ifelse(Sepal.Length < 6, NA, Sepal.Length),
Sepal.Width = ifelse(Sepal.Width < 3.3, NA, Sepal.Width)))

# tPIC, newdata not supplied
PIC(object = mod)

# gPIC
PIC(object = mod, newdata = vdat, group_sizes = c(5,3,2))
PIC(object = mod, newdata = vdat, group_sizes = 5)

# iPIC
PIC(object = mod, newdata = vdat, group_sizes = rep(1, 10))
PIC(object = mod, newdata = vdat, group_sizes = 1)

# bootstrapped tPIC (based on 10 bootstrap samples)
set.seed(1)
PIC(object = mod, bootstraps = 10)

}
\references{
Flores, J.E. (2021), \emph{A new class of information criteria for improved prediction in the presence of training/validation data heterogeneity} [Unpublished PhD dissertation]. University of Iowa.
}
\seealso{
\code{\link[picR]{PIC}}, \code{\link[picR]{PIC.lm}}, \code{\link[stats]{lm}}
}
