#lang racket
(provide
 (contract-out
  [hsl?           predicate/c]
  [hsi?           predicate/c]
  [hsv?           predicate/c]
  [color/c contract?]
  [%/c contract?]
  [hue/c contract?]
  [h**/c contract?]

  [rename color->hsv* color->hsv     (-> color/c hsv?)]
  [hsv->color     (-> hsv? (is-a?/c color%))]
  [rename color->hsl* color->hsl     (-> color/c hsl?)]
  [hsl->color     (-> hsl? (is-a?/c color%))]
  [rename color->hsi* color->hsi     (-> color/c hsi?)]
  [hsi->color     (-> hsi? (is-a?/c color%))]

  [hsv            (->* (hue/c %/c %/c) (%/c) hsv-color?)]
  [hsi            (->* (hue/c %/c %/c) (%/c) hsi-color?)]
  [hsl            (->* (hue/c %/c %/c) (%/c) hsl-color?)]

  [complement     (-> h**/c h**/c)]
  ;; for backwards compatibility with some terrible spelling
  [rename complement compliment (-> h**/c h**/c)]
  [set-hue        (-> h**/c hue/c h**/c)]
  [set-saturation (-> h**/c %/c h**/c)]
  [set-brightness (-> h**/c %/c h**/c)]))

      

(require "private/shared.rkt"
         "hsl.rkt"
         "hsi.rkt"
         "hsv.rkt"
         (only-in racket/draw color%))


(define hsv? hsv-color?)
(define hsi? hsi-color?)
(define hsl? hsl-color?)
(define h**/c (or/c hsv? hsi? hsl?))

(define (hsl h s v [a 1.0]) (hsl-color h s v a))
(define (hsi h s v [a 1.0] ) (hsi-color h s v a))
(define (hsv h s v [a 1.0]) (hsv-color h s v a))

(define (->color c)
  (cond
    [(hsv? c) (hsv->color c)]
    [(hsi? c) (hsi->color c)]
    [(hsl? c) (hsl->color c)]
    [else c]))


(define color->hsv* (compose color->hsv ->color))
(define color->hsi* (compose color->hsi ->color))
(define color->hsl* (compose color->hsl ->color))


(module+ test (require rackunit racket/draw))

(define (complement h**)
  (match-define (h**-color hue sat lightness alpha) h**)
  ((get-constructor h**)
   (if (> hue 1/2) (- hue 1/2) (+ hue 1/2))
   sat
   lightness
   alpha))

(define (set-saturation h** new-sat)
  (match-define (h**-color hue sat lightness alpha) h**)
  ((get-constructor h**) hue new-sat lightness alpha))

(define (set-brightness h** new-lightness)
  (match-define (h**-color hue sat lightness alpha) h**)
  ((get-constructor h**) hue sat new-lightness alpha))

(define (set-hue h** new-hue)
  (match-define (h**-color hue sat lightness alpha) h**)
  ((get-constructor h**) new-hue sat lightness alpha))

(define (get-constructor h**)
  (cond
    [(hsl-color? h**) hsl-color]
    [(hsv-color? h**) hsv-color]
    [(hsi-color? h**) hsi-color]))

(module+ test

  (check-equal?
   (color->hsv "black")
   (hsv +nan.0 0 0))
  (check-equal?
   (color->hsv "white")
   (hsv +nan.0 0 1))
  (check-equal?
   (color->hsv "gray")
   (hsv +nan.0 0 (/ 190 255)))
  (check-equal?
   (color->hsv (make-object color% 255 0 0))
   (hsv 0 1 1))

  (define (check-identity c** color-> ->color)
    (define (str c)
      (if (string? c)
          c
          (list (send c red) (send c green) (send c blue))))
    (define c* (maybe-lookup-db c**))
    (define c #f)
    (check-not-exn
     (lambda ()
       (set! c (->color (color-> c*))))
     (~a "conversion:" (str c**) (object-name ->color)))
    (unless c (error "aborting tests"))
    (check-equal? (send c red) (send c* red) (~a "red:" c** (object-name ->color)))
    (check-equal? (send c blue) (send c* blue) (~a "blue:" c** (object-name ->color)))
    (check-equal? (send c green) (send c* green) (~a "green:" c** (object-name ->color))))

  (define colors-to-check (send the-color-database get-names))
  (define pairs-to-check
    (list (list color->hsv hsv->color)
          (list color->hsi hsi->color)
          (list color->hsl hsl->color)))
  (for* ([c (in-list colors-to-check)]
         [p (in-list pairs-to-check)])
    (apply check-identity c p))
  (for* ([r (in-range 0 32)]
         [g (in-range 0 32)]
         [b (in-range 0 32)]
         [c (in-value (make-object color% (* 8 r) (* 8 g) (* 8 b)))]
         [p (in-list pairs-to-check)])
    (apply check-identity c p)))
