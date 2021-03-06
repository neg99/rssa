\name{ssa}
\alias{ssa}
\alias{new.ssa}
\title{Create a new SSA object}

\description{
  Set up the SSA object and perform the decomposition, if necessary.
}

\usage{
ssa(x,
    L = (N + 1) \%/\% 2,
    \dots,
    kind = c("1d-ssa", "2d-ssa", "toeplitz-ssa"),
    svd.method = c("nutrlan", "propack", "svd", "eigen"),
    force.decompose = TRUE)
}

\arguments{
  \item{x}{object to be decomposed. Vector or time series object for 1d
    SSA (or something which can be coerced to a vector), matrix-like
    object for 2d SSA.}
  \item{L}{integer, window length. Fixed to half of the series length by
    default. Should be vector of length 2 for 2d SSA}
  \item{\dots}{further arguments passed to
    \code{\link[Rssa:decompose.ssa]{decompose}} (e.g. \code{neig}).}
  \item{kind}{SSA method. This includes ordinary 1d SSA, 2d SSA and
    Toeplitz variant of 1d SSA.}
  \item{svd.method}{singular value decomposition method. See 'Details'
    for more info.}
  \item{force.decompose}{logical, if 'TRUE' then the decomposition is
    performed before return.}
}

\value{
  Object of class `ssa'. The precise layout of the object is mostly
  meant opaque and subject to change in different version of the
  package. See \code{\link[Rssa:ssa-object]{ssa-object}} for details.
}

\details{
  This is the main entry point to the package. This routine
  constructs the SSA object filling all necessary internal structures
  and performing the decomposition if necessary.

  \subsection{Variants of SSA}{
    The following implementations of the SSA method are supported
    (corresponds to different values of \code{kind} argument):
    \itemize{
      \item Basic 1d SSA as described in Chapter 1 of (Golyandina et al,
      2001). This is also known as Broomhead-King variant of SSA or
      BK-SSA, see (Broomhead and King, 1986).
      \item 2d SSA for decomposition of images and fields. See (Golyandina
      and Usevich, 2009) for more information. The so-called M-SSA method
      (aka multichannel SSA) is a special version of 2d SSA with window
      length having one component set to one.
      \item Toeplitz variant of 1d SSA. See Section 1.7.2 in (Golyandina
      et al, 2001). This is also knows as Vatuard-Gill varian of SSA or
      VG-SSA for analysis of stationary time series, see (Vautard and
      Ghil, 1989).
    }
  }

  \subsection{SVD methods}{
    The main step of the SSA method is the singular decomposition of the
    so-called series trajectory matrix. Package provides several
    implementations of this procedure (corresponds to different values of
    \code{svd.method}) argument:
    \describe{
      \item{nutrlan}{Thick-restart Lanczos eigensolver which operates on
        cross-product matrix. This methods exploits the Hankel structure of
        the trajectory matrix efficiently and is really fast. The method
        allows the truncated SVD (only specifid amount of eigentriples to be
        computed) and the continuation of the decomposition. See
        (Korobeynikov, 2010) for more information.}
      \item{propack}{SVD via implicitly restarted Lanczos
        bidiagonalization with partial reothogonalization. This methods
        exploits the Hankel structure of the trajectory matrix efficiently
        and is really fast. This is the 'proper' SVD implementation (the
        matrix of factor vectors are calculated), thus the memory
        requirements of the methods are higher than for nu-TRLAN. Usually
        the method is slightly faster that nu-TRLAN and more numerically
        stable. The method allows the truncated SVD (only specifid amount
        of eigentriples to be computed). See (Korobeynikov, 2010) for more
        information.}
      \item{svd}{Full SVD as provided by LAPACK DGESDD
        routine. Neither continuation of the decomposition nor the
        truncated SVD is supported. The method does not assume anything
        special about the trajectory matrix and thus is slow.}
      \item{eigen}{Full SVD via eigendecompsition of the cross-product
        matrix. In many cases faster than previous method, but still
        really slow for more or less non-trivial matrix sizes.}
    }

    Usually the \code{ssa} function tries to provide the best SVD
    implementation for given series length and the window size. In
    particular, for small series and window sizes it is better to use
    generic black-box routines (as provided by 'svd' and 'eigen'
    methods). For long series special-purpose routines are to be used.
  }
}

\references{
  Broomhead, D.S., and King, G.P. (1986a): \emph{Extracting qualitative
  dynamics from experimental data}, Physica D, 20, 217--236.

  Vautard, R., and Ghil, M. (1989): \emph{Singular spectrum analysis in
  nonlinear dynamics, with applications to paleoclimatic time series},
  Physica D, 35, 395--424.

  Golyandina, N., Nekrutkin, V. and Zhigljavsky, A. (2001): \emph{Analysis of
    Time Series Structure: SSA and related techniques.} Chapman and
  Hall/CRC. ISBN 1584881941
 
  Golyandina, N. and Usevich, K. (2009). \emph{2D-extensions of singular
  spectrum analysis: algorithm and elements of theory.} In Matrix
  Methods: Theory, Algorithms, Applications. World Scientific
  Publishing, 450-474.

  Korobeynikov, A. (2010) \emph{Computation- and space-efficient
    implementation of SSA.} Statistics and Its Interface, Vol. 3, No. 3,
    Pp. 257-268  
}
\seealso{
  \code{\link[svd:svd]{svd}},
  \code{\link[Rssa:ssa-object]{ssa-object}},
  \code{\link[Rssa:decompose.ssa]{decompose}},
  \code{\link[Rssa:reconstruct]{reconstruct}},
  \code{\link[Rssa:plot]{plot}},
  \code{\link[Rssa:forecast]{forecast}},
}

\examples{
# Decompose 'co2' series with default parameters
s <- ssa(co2)
# Show the summary
summary(s)
# Reconstruct the series, with suitable grouping
r <- reconstruct(s, groups = list(c(1, 4), c(2, 3), c(5, 6)))
plot(r)
}
