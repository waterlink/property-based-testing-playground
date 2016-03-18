package add

import (
	"testing"
	"testing/quick"
)

func Add(x, y int) int {
	return x + y
}

func TestAddExample(t *testing.T) {
	examples := []struct {
		x   int
		y   int
		add int
	}{
		{
			x:   3,
			y:   8,
			add: 11,
		},
		{
			x:   5,
			y:   7,
			add: 12,
		},
	}

	for _, e := range examples {
		if v := Add(e.x, e.y); v != e.add {
			t.Errorf("Expected Add(%d, %d) to equal %d, but got: %d", e.x, e.y, e.add, v)
		}
	}
}

func TestAddReflexivity(t *testing.T) {
	err := quick.Check(func(x, y int) bool {
		return Add(x, y) == Add(y, x)
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestAddIdentity(t *testing.T) {
	err := quick.Check(func(x int) bool {
		return Add(x, 0) == x
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestAddNoIdentity(t *testing.T) {
	err := quick.Check(func(x, notId int) bool {
		if notId == 0 {
			return true
		}
		return Add(x, notId) != x
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestAddTransitivity(t *testing.T) {
	err := quick.Check(func(x, y, z int) bool {
		return Add(x, Add(y, z)) == Add(Add(x, y), z)
	}, nil)

	if err != nil {
		t.Error(err)
	}
}
