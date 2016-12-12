#lang debug racket
(require "private/shared.rkt" racket/draw)
(provide
 (contract-out
  [color->hsi     (-> color/c hsi-color?)]
  [hsi->color     (-> hsi-color? (is-a?/c color%))]))

(define (color->hsi c*)
  (define-values (r g b alpha mn mx chroma hue) (color->rgbanxch c*))
  (define intensity (* 1/3 (+ r g b)))
  (define sat
    (if (zero? intensity)
        0
        (- 1 (/ mn intensity))))
  (hsi-color hue sat intensity alpha))

(define (hsi->color hsi)
  (match-define (hsi-color hue sat intensity alpha) hsi)
  (define h* (* hue 6))
  (define chroma (/ (* 3 intensity sat)
                    (+ 1 (- 1 (abs (- (float-modulo h* 2) 1))))))
  (define mn (* intensity (- 1 sat)))
  (define-values (r g b)
    (compute-rgb-from-ir chroma hue mn))
  (make-object color% r g b))
