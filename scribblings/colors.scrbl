#lang scribble/doc

@(require
   scribble/eval
   scribble/manual

   (for-label racket colors))

@(provide
  (all-from-out scribble/eval
                scribble/manual)
  (for-label (all-from-out racket colors)))

@title{Colors}

@author[(author+email "Spencer Florence" "spencer@florence.io")]

@defmodule[colors]

@section{Colors}

the colors library provides alternatives to rgb color representations. it current supports hsl (hue,
saturation, luminosity), hsi (hue, saturation, intensity), and hsv (hue, saturation, value).

For a full introduction to hsl and hsv color systems see @link["https://en.wikipedia.org/wiki/HSL_and_HSV"]{Wikipedia}.

@section{structures and contracts}

@defthing[h**/c contract?]{

 Contract that accepts @racket[hsl?], @racket[hsv?], or @racket[hsi?] values.
                       
}

@defproc[(hsl? [it any/c]) boolean?]{

  is @racket[_it] an hsl color type?

}

@defproc[(hsi? [it any/c]) boolean?]{

  is @racket[_it] an hsi color type?

}

@defproc[(hsv? [it any/c]) boolean?]{

  is @racket[_it] an hsv color type?

}

@defthing[color/c contract?]{

 Contract which accepts any color like type: @racket[color%]'s, strings, or @racket[h**/c] values.
                             
}


@defthing[%/c contract?]{

 Contract for value percentages. Equivalent to @racket[(real-in 0 1)].

}

@defthing[hue/c contract?]{

 Contract for value hues. Equivalent to @racket[(or/c (real-in 0 1) +nan.0)].
 This contract is similar to @racket[%/c] except @racket[+nan.0] is use for
 colors which do not have a defined hue.

}

@section{Color Construction}

@;{hsl represents colors in a cylindrical coordinate system.  the rotation access determines the
``hue'', which is the location in a color wheel.  the radial access is the ``saturation'', which
determines the grayness of the color. the vertical access is the ``luminosity'',which determines the
brightness of the color, between completely black and completely light.}

@defproc[(color->hsl [color color/c]) hsl?]{

  Convert to an HSL color.

}

@defproc[(hsl->color [hsl hsl?]) (is-a/c color%)]{

  Convert back to an RGB Color.

}

@defproc[(color->hsv [color color/c]) hsv?]{

  Convert to an HSV color.

}

@defproc[(hsv->color [hsv hsv?]) (is-a/c color%)]{

  Convert back to an RGB Color.

}

@defproc[(color->hsi [color color/c]) hsi?]{

  Convert to an HSI color.

}

@defproc[(hsi->color [hsi hsi?]) (is-a/c color%)]{

  Convert back to an RGB Color.

}

@defproc[(hsl [hue hue/c] [saturation %/c] [lightness %/c] [alpha %/c 1.0]) hsl?]{

 Directly construct an HSL color.
                                                                                  
}

@defproc[(hsv [hue hue/c] [saturation %/c] [value %/c] [alpha %/c 1.0]) hsv?]{

 Directly construct an HSV color.
                                                                                  
}

@defproc[(hsi [hue hue/c] [saturation %/c] [intensity %/c] [alpha %/c 1.0]) hsi?]{

 Directly construct an HSI color.
                                                                                  
}

@section{Color manipulation}

@define[same]{@list{The resulting color has the same type as @racket[_color].}}

@defproc[(compliment [color h**/c]) h**/c]{

 Get the compiment of a color. @same
                                           
}

@defproc[(set-hue [color h**/c] [hue hue/c]) h**/c]{

 Construct a color like @racket[_color] but with the given @racket[_hue]. @same
                                           
}

@defproc[(set-saturation [color h**/c] [saturation %/c]) h**/c]{

 Construct a color like @racket[_color] but with the given @racket[saturation]. @same
                                           
}

@defproc[(set-brigthness [color h**/c] [brighness %/c]) h**/c]{

 Construct a color like @racket[_color] but with the given @racket[brighness]. @same
                                           
}
