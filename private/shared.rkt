#lang debug racket
(require racket/draw)
(provide
 maybe-lookup-db
 hue/c
 %/c
 color/c
 compute-hue
 float-modulo
 modulo-+
 compute-rgb-from-ir
 color->rgbanxch
 (struct-out h**-color)
 (struct-out hsl-color)
 (struct-out hsv-color)
 (struct-out hsi-color))

(define hue/c (or/c (real-in 0 1) +nan.0))
(define %/c (real-in 0 1))
(define color/c
  (or/c (is-a?/c color%)
        string?))

(struct h**-color (hue saturation value alpha) #:transparent)
(struct hsl-color h**-color () #:transparent)
(struct hsv-color h**-color () #:transparent)
(struct hsi-color h**-color () #:transparent)

(define (compute-rgb-from-ir chroma hue mn)
  (define hue-from-0-to-6 (* hue 6))
  (define-values (r g b)
    (cond
      [(nan? hue) (values 0 0 0)]
      [else
       (define extract-color (* chroma
                                (- 1 (abs (- (float-modulo hue-from-0-to-6 2) 1)))))
       (define hue-digit (exact-floor hue-from-0-to-6))
       (define c chroma)
       (define x extract-color)
       (case hue-digit
         [(0)      (values c x 0)]
         [(1)      (values x c 0)]
         [(2)      (values 0 c x)]
         [(3)      (values 0 x c)]
         [(4)      (values x 0 c)]
         [(5)      (values c 0 x)]
         [else (error 'color-conversion "nonsense hue: ~a, internal: ~a" hue hue-digit)])]))
  (define (convert x) (negative-normalize (exact-round (* 255 (+ x mn)))))
  (define (negative-normalize x)
    (if (negative? x)
        (+ 255 (add1 x))
        x))
  (values (convert r) (convert g) (convert b)))

(define (float-modulo a n)
  (- a (* n (floor (/ a n)))))
(define (modulo-+ a b)
  (define part (+ a b))
  (cond
    [(> a 1) (- a (exact-floor a))]
    [(< a 0) (add1 (+ a (exact-floor a)))]
    [else a]))
(require racket/draw)
(define (maybe-lookup-db c)
  (make-object color% c))


;; computer the RGB values, alpha, min, max, chroma, and hue
;; yeah, bad function name...
(define (color->rgbanxch c*)
  (define c (maybe-lookup-db c*))
  (define (% col) (/ col 255))
  (define r (% (send c red)))
  (define g (% (send c green)))
  (define b (% (send c blue)))
  (define alpha (send c alpha))
  (define mx (max r g b))
  (define mn (min r g b))
  (define chroma (- mx mn))
  (define hue (compute-hue r g b chroma mx))
  (values r g b alpha mn mx chroma hue))

(define (compute-hue r g b chroma mx)
  (define hue-in-0-to-6
    (cond
      [(zero? chroma)
       ;; this is technically "undefined", but we need something
       +nan.0]
      [(= r mx)
       (float-modulo (/ (- g b) chroma) 6)]
      [(= g mx)
       (+ 2 (/ (- b r) chroma))]
      [(= b mx)
       (+ 4 (/ (- r g) chroma))]))
  (/ hue-in-0-to-6 6))
