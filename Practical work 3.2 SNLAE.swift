import Foundation
typealias Matrix = [[Double]]
let f: ([Double]) -> [Double] = { x in
    var leftSideExp = Array(repeating: 0.0, count: 4)
    leftSideExp[0] = x[0] * x[0] + x[1] + x[2] + x[3] - 10.0
    leftSideExp[1] = 2.0 * x[0] + 2.0 * x[1] * x[1] + 2.0 * x[2] + 4.0 * x[3] - 32.0
    leftSideExp[2] = x[0] + 4.0 * x[1] + x[2] * x[2] + 4.0 * x[3] - 34.0
    leftSideExp[3] = x[1] + 2.0 * x[2] + x[3] * x[3] - 24.0
    return leftSideExp
}
func newtonRaphoson() -> () {
    let eps = 0.001
    var x = [1.0, 1.0, 1.0, 1.0]
    let len = x.count
    var B = Array(repeating: 0.0, count: len)
    var A = Array(repeating: Array(repeating: 0.0, count: len), count: len)
	var count = 1
	var error = 0.0
    repeat {
        var f0 = Array(repeating: 0.0, count: len)
        (A, f0) = jacobian(f: f, x: &x)
        for i in 0..<len {
            B[i] = -f0[i]
        }
        var dx = doolittle(A, rightValue: B, len: len)
        for i in 0..<len {
            x[i] += dx[i]
        }
        var maxX = dx[0]
        var minX = dx[0]
        for i in dx {
            maxX = maxX < i ? i : maxX
            minX = minX > i ? i : minX
        }
        error = max(fabs(maxX), fabs(minX))
		
		var out = ""
		out += "\(count). "
		count += 1
		for i in 0..<len {
			out += String(format: "x\(i+1) = %.5f, ", x[i])
		}
        print(out)
    } while error > eps
    
}

func jacobian(f: ([Double]) -> [Double], x : inout [Double]) -> ([[Double]], [Double]) {
    let delta = 0.0001
    let len = x.count
    var matrix = Array(repeating: Array(repeating: 0.0, count: len), count: len)
    var f0 = f(x)
    for i in 0..<len {
        let temp = x[i]
        x[i] = temp + delta
        var f1 = f(x)
        x[i] = temp
        for j in 0..<len {
            matrix[j][i] = (f1[j] - f0[j]) / delta
        }
    }
    return (matrix, f0)
}

func doolittle(_ matrix: Matrix, rightValue: [Double], len: Int) -> ([Double]) {
    var L : Matrix = Array(repeating: Array(repeating: 0, count: len), count: len)
    var U : Matrix = Array(repeating: Array(repeating: 0, count: len), count: len)
    for j in 0..<len {
        for i in 0..<len {
            if i <= j {
                U[i][j] = matrix[i][j]
                for k in stride(from: 0, to: i, by: 1) {
                    U[i][j] -= L[i][k] * U[k][j]
                }
                if i == j {
                    L[i][j] = 1
                } else {
                    L[i][j] = 0
                }
            } else {
                L[i][j] = matrix[i][j]
                for k in stride(from: 0, to: j, by: 1) {
                    L[i][j] -= L[i][k] * U[k][j]
                }
                L[i][j] /= U[j][j]
                U[i][j] = 0
            }
        }
    }
    var Z : [Double] = Array(repeating: 0, count: len)
    for i in 0..<len {
        Z[i] = rightValue[i]
        for j in 0..<i {
            Z[i] -= L[i][j] * Z[j]
        }
    }
    var X = Array(repeating: 0.0, count: len)
    for i in (0..<len).reversed() {
        X[i] = Z[i]
        for j in (i+1..<len).reversed() {
            X[i] -= U[i][j] * X[j]
        }
        X[i] /= U[i][i]
    }
    return X
}
newtonRaphoson()