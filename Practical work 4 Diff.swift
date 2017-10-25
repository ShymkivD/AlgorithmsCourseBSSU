import Foundation
typealias Matrix = [[Double]]
func f(x : [Double], x0 : [Double], t : Double, dt : Double) -> [Double] {
    var leftSideExp = Array(repeating: 0.0, count: 5)
	leftSideExp[0] = x[0] + 10 * sin(10 * t)
    leftSideExp[1] = sqrt(x[4]) + x[1]
    leftSideExp[2] = x[2] * x[2]
    leftSideExp[3] = x[3]
    leftSideExp[4] = x[1] + x[3] + x[4]
	for i in 0..<leftSideExp.count {
		leftSideExp[i] = x[i] - x0[i] - dt * leftSideExp[i] 
	}
    return leftSideExp
}
func Eiler() -> () {
    let eps = 0.001
    var xStart = [1.0, 1.0, 1.0, 1.0, 1.0]
    let len = xStart.count
	var counter = 1
	var error = 0.0
	var t = 0.0
	var dt = 0.1
	var X = Array(repeating: 0.0, count: len)
	var B = Array(repeating: 0.0, count: len)
    var A = Array(repeating: Array(repeating: 0.0, count: len), count: len)
	
	func jacobian(x : inout [Double]) -> ([[Double]], [Double]) {
    	let delta = 0.0001
    	let len = x.count
    	var matrix = Array(repeating: Array(repeating: 0.0, count: len), count: len)
    	var f0 = f(x: x, x0: xStart, t: t, dt: dt)
    	for i in 0..<len {
        	let temp = x[i]
        	x[i] = temp + delta
        	var f1 = f(x: x, x0: xStart, t: t, dt: dt)
        	x[i] = temp
        	for j in 0..<len {
        	    matrix[j][i] = (f1[j] - f0[j]) / delta
        	}
    	}
    	return (matrix, f0)
	}
	
	for _ in 0..<10 {
		t += dt
		for i in 0..<len { X[i] = xStart[i] }
		repeat {
        	var f0 = Array(repeating: 0.0, count: len)
        	(A, f0) = jacobian(x: &X)
        	for i in 0..<len {
            	B[i] = -f0[i]
        	}
        	var dx = doolittle(A, rightValue: B, len: len)
        	for i in 0..<len {
            	X[i] += dx[i]
        	}
        	var maxX = dx[0]
        	for i in dx { maxX = maxX < i ? i : maxX }
        	error = maxX
		} while error > eps
		var out = ""
		out += "Iter #\(counter). t has value: \(t)\n"
		counter += 1
		for i in 0..<len {
			out += String(format: "x\(i+1) = %.5f\((i != len-1) ? ", " : ".")", X[i])
		}
        print(out)
		for i in 0..<len { xStart[i] = X[i] }
	}
}