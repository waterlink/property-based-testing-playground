(ns clj.core-test
    (:require [clojure.test.check :as tc]
              [clojure.test.check.generators :as gen]
              [clojure.test.check.properties :as prop :include-macros true]
              [clojure.test.check.clojure-test :refer [defspec]]
              [clojure.test :refer [deftest is]]))

(defn add [x y]
  (+ x y))

(defspec add-reflexivity
  100
  (prop/for-all [x gen/int
                 y gen/int]
                (= (add x y) (add y x))))

(defspec add-identity
  100
  (prop/for-all [x gen/int]
                (= (add x 0) x)))

(defspec add-no-identity
  100
  (prop/for-all [x gen/int
                 not-id gen/int]
                (or (= 0 not-id)
                    (not= (add x not-id) x))))

(defspec add-associativity
  100
  (prop/for-all [x gen/int
                 y gen/int
                 z gen/int]
                (= (add x (add y z))
                   (add (add x y) z))))

(defn mul [x y]
  (* x y))

(defspec mul-reflexivity
  100
  (prop/for-all [x gen/int
                 y gen/int]
                (= (mul x y) (mul y x))))

(defspec mul-identity
  100
  (prop/for-all [x gen/int]
                (= (mul x 1) x)))

(defspec mul-zero
  100
  (prop/for-all [x gen/int]
                (= (mul x 0) 0)))

(defspec mul-no-identity
  100
  (prop/for-all [x gen/int
                 not-id gen/int]
                (or (= 1 not-id)
                    (= 0 x)
                    (not= (mul x not-id) x))))

(defspec mul-associativity
  100
  (prop/for-all [x gen/int
                 y gen/int
                 z gen/int]
                (= (mul x (mul y z))
                   (mul (mul x y) z))))

(defn mysort [xs]
  (let [n (count xs)]
    (if (< n 2)
      xs
      (let [i (rand-int n)
            pivot (nth xs i)
            swap-with (nth xs 0)
            xs (-> xs
                   (assoc i swap-with)
                   (assoc 0 pivot))
            xs (rest xs)
            left (filterv #(<= % pivot) xs)
            right (filterv #(> % pivot) xs)]
        (into
          (conj (mysort left) pivot)
          (mysort right))))))

(defn- is-ordered [xs]
  (reduce (fn [acc [x y]] (and acc (<= x y)))
          true
          (partition 2 1 xs)))

(defspec mysort-applied-twice-is-same-as-once
  100
  (prop/for-all [xs (gen/vector gen/int)]
                (= (mysort (mysort xs)) (mysort xs))))

(defspec mysort-contains-same-elements
  100
  (prop/for-all [xs (gen/vector gen/int)]
                (= (frequencies (mysort xs)) (frequencies xs))))

(defspec mysort-orders-elements
  100
  (prop/for-all [xs (gen/vector gen/int)]
                (is-ordered (mysort xs))))
