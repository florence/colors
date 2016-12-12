#lang debug racket
(require "private/shared.rkt" racket/draw)
(provide
 (contract-out
  [hsl?           predicate/c]
  [hsl            (-> hue/c %/c %/c hsl-color?)]
  [color->hsl     (-> color/c hsl-color?)]
  [hsl->color     (-> hsl-color? (is-a?/c color%))]))


(define (hsl h s v) (hsl-color h s v 1.0))
(define hsl? hsl-color?)

(define (color->hsl c*)
  (define-values (r g b alpha mn mx chroma hue) (color->rgbanxch c*))

  (define lightness (* 1/2 (+ mx mn)))
  (define saturation
    (if (or (= 1 lightness) (= 0 lightness))
        0
        (/ chroma (- 1 (abs (- (* 2 lightness) 1))))))
  (hsl-color hue saturation lightness alpha))

(define (hsl->color hsl)
  (match-define (hsl-color hue saturation lightness alpha) hsl)
  (define chroma (* saturation (- 1 (abs (- (* 2 lightness) 1)))))
  (define mn (- lightness (* 1/2 chroma)))
  (define-values (r g b) (compute-rgb-from-ir chroma hue mn))
  (make-object color% r g b alpha))
