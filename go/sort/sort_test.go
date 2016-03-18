package sort

import (
	"reflect"
	"testing"
	"testing/quick"
)

func Sort(array []int) []int {
	if len(array) < 2 {
		return array
	}

	half := (len(array) + 1) / 2
	return merge(Sort(array[0:half]), Sort(array[half:]))
}

func merge(left, right []int) []int {
	result := make([]int, len(left)+len(right))

	i := 0
	j := 0
	k := 0
	for i < len(left) && j < len(right) {
		if left[i] <= right[j] {
			result[k] = left[i]
			i++
		} else {
			result[k] = right[j]
			j++
		}

		k++
	}

	for i < len(left) {
		result[k] = left[i]
		i++
		k++
	}

	for j < len(right) {
		result[k] = right[j]
		j++
		k++
	}

	return result
}

func TestSortAppliedTwiceSameResult(t *testing.T) {
	err := quick.Check(func(array []int) bool {
		return reflect.DeepEqual(Sort(Sort(array)), Sort(array))
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestSortContainsSameElements(t *testing.T) {
	err := quick.Check(func(array []int) bool {
		return reflect.DeepEqual(frequencies(Sort(array)), frequencies(array))
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestSortOrdersElements(t *testing.T) {
	if err := quick.Check(callAndCheck(Sort, isOrdered), nil); err != nil {
		t.Error(err)
	}
}

func frequencies(array []int) map[int]int {
	result := map[int]int{}
	for _, item := range array {
		if _, ok := result[item]; !ok {
			result[item] = 0
		}

		result[item]++
	}

	return result
}

func callAndCheck(f func([]int) []int, g func([]int) bool) func([]int) bool {
	return func(array []int) bool {
		return g(f(array))
	}
}

func isOrdered(array []int) bool {
	var previous *int

	for _, item := range array {
		if previous != nil {
			if *previous > item {
				return false
			}
		}

		nextPrevious := item
		previous = &nextPrevious
	}

	return true
}
