import Foundation

func grad(f: ([Double]) -> Double, x: inout [Double]) -> ([Double], Double) {
    let delta = 0.00001
    let length = x.count
    var arr = Array(repeating: 0.0, count: length)
    let f0 = f(x)
    for i in 0..<length {
        let temp = x[i]
        x[i] = temp + delta
        let f1 = f(x)
        x[i] = temp
        arr[i] = (f1 - f0) / delta
    }
    return (arr, f0)
}

let f : ([Double]) -> Double = { x in pow(x[0] - 2, 2) + pow(x[1] - 5, 2) }

func SteepestDescent() {
    var X = [1.0, 1.0]
    let eps = 0.0001
    let h = 0.01
    let len = X.count
    var error = 100.0
    var i = 0
    repeat {
        var fOld = 100.0
        var fNew = 0.0
        var arr = Array(repeating: 0.0, count: len)
        (arr, fNew) = grad(f: f, x: &X)
        fNew = f(X)
        while fOld > fNew {
            fOld = fNew
            X[i] -= h * arr[i]
            fNew = f(X)
        }
        i = i < len - 1 ? i + 1 : 0
        var maxX = arr[0]
        var minX = arr[0]
        for i in arr {
            maxX = maxX < i ? i : maxX
            minX = minX > i ? i : minX
        }
        error = max(fabs(maxX), fabs(minX))
    } while error > eps
    print(String(format: "x = %.7f, y = %.7f", X[0], X[1]))
    print(String(format: "f(x, y) = %.5f", f(X)))
}

srandom(UInt32(time(nil)))
public extension Double {
    public static func Random(lower: Double, upper: Double) -> Double {
        return Double(random()) / Double(UInt32.max) * (upper - lower) + lower
    }
}

func MonteCarlo() {
    var X = Array(repeating: Double.Random(lower: 0.0, upper: 10.0), count: 2)
    var min = 100.0
	var X1 = X
    for _ in 0..<50000 {
		X[0] = Double.Random(lower: 0.0, upper: 10.0)
		X[1] = Double.Random(lower: 0.0, upper: 10.0)
        let f0 = f(X)
		if (min > f0) {
			min = f0	
			X1 = X
		}
    }
    print(String(format: "x = %.7f, y = %.7f", X1[0], X1[1]))
    print(String(format: "f(x, y) = %.5f", min))
}


print("Method of steepest descent")
SteepestDescent()

print("Monte Carlo method")
MonteCarlo()