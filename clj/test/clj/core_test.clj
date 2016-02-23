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
