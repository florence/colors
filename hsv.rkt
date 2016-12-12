#lang racket
(require "private/shared.rkt" racket/draw)
(provide
 (contract-out
  [color->hsv     (-> color/c hsv-color?)]
  [hsv->color     (-> hsv-color? (is-a?/c color%))]))

(module+ test (require rackunit))

(define (color->hsv c*)
  (define-values (r g b alpha mn mx chroma hue) (color->rgbanxch c*))

  (define value mx)
  (define saturation
    (if (zero? value) 0 (/ chroma value)))
  (hsv-color hue saturation value alpha))

(define (hsv->color hsv)
  (match-define (hsv-color hue sat value alpha) hsv)
  (define chroma (* value sat))
  (define mn (- value chroma))
  (define-values (r g b) (compute-rgb-from-ir chroma hue mn))
  (make-object color% r g b alpha))
