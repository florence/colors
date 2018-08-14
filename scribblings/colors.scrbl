#lang scribble/doc

@(require
   scribble/eval
   scribble/manual

   (for-label racket colors))

@(provide
  (all-from-out scribble/eval
                scribble/manual)
  (for-label (all-from-out racket colors)))


@author[(author+email "Spencer Florence" "spencer@florence.io")]

@section{Colors}

the colors library provides alternatives to rgb color representations. it current supports hsl (hue,
saturation, luminosity), hsi (hue, saturation, intensity), and hsv (hue, saturation, value).

For a full introduction to hsl and hsv color systems see @link["https://en.wikipedia.org/wiki/hsl_and_hsv"].

@section{hsl}

@;{hsl represents colors in a cylindrical coordinate system.  the rotation access determines the
``hue'', which is the location in a color wheel.  the radial access is the ``saturation'', which
determines the grayness of the color. the vertical access is the ``luminosity'',which determines the
brightness of the color, between completely black and completely light.}

@defproc[(hsl? [it any/c]) boolean?]{

  is @racket[_it] an hsl color type?

}

@defproc[(color->hsl [color color/c]) hsl?]{

  Convert to an HSL color.

}

@defproc[(hsl->color [hsl hsl?]) (is-a/c color%)]{

  Convert back to an RGB Color.

}

@section{hsv}
