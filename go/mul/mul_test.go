package mul

import (
	"testing"
	"testing/quick"
)

func Mul(x, y int) int {
	return x * y
}

func TestMulExample(t *testing.T) {
	examples := []struct {
		x   int
		y   int
		mul int
	}{
		{
			x:   3,
			y:   8,
			mul: 24,
		},
		{
			x:   5,
			y:   7,
			mul: 35,
		},
	}

	for _, e := range examples {
		if v := Mul(e.x, e.y); v != e.mul {
			t.Errorf("Expected Mul(%d, %d) to equal %d, but got: %d", e.x, e.y, e.mul, v)
		}
	}
}

func TestMulReflexivity(t *testing.T) {
	err := quick.Check(func(x, y int) bool {
		return Mul(x, y) == Mul(y, x)
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestMulIdentity(t *testing.T) {
	err := quick.Check(func(x int) bool {
		return Mul(x, 1) == x
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestMulNoIdentity(t *testing.T) {
	err := quick.Check(func(x, notId int) bool {
		if notId == 0 {
			return true
		}
		return Mul(x, notId) != x
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestMulZero(t *testing.T) {
	err := quick.Check(func(x int) bool {
		return Mul(x, 0) == 0
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestMulNoZero(t *testing.T) {
	err := quick.Check(func(x, notZero int) bool {
		if notZero == 0 {
			return true
		}
		return Mul(x, notZero) != 0
	}, nil)

	if err != nil {
		t.Error(err)
	}
}

func TestMulTransitivity(t *testing.T) {
	err := quick.Check(func(x, y, z int) bool {
		return Mul(x, Mul(y, z)) == Mul(Mul(x, y), z)
	}, nil)

	if err != nil {
		t.Error(err)
	}
}
