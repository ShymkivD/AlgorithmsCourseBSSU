import Foundation

func methodChord() {
    print("\t\t\tMethod chord")
    print("x^3 - 0.2x^2 + 0.5x - 1.2")
    var x0 = -1.0
    var x1 = 1.0
    let eps = 0.001
    let f : (Double) -> Double = { x in
        let val = pow(x, 3) + 0.2 * x * x
        return val + 0.5 * x - 1.2
    }
    let x = {(xPrevious : inout Double, xCurrent : inout Double) -> Double in
        var xNext = 0.0
        var buf : Double
        var counter = 0
        repeat {
            counter += 1
            buf = xNext
            xNext = xCurrent - f(xCurrent) * (xPrevious - xCurrent) / (f(xPrevious) - f(xCurrent))
            xPrevious = xCurrent
            xCurrent = buf
            print(String(format: "\(counter). %.4f", xNext))
        } while fabs(xNext - xCurrent) > eps
        return xNext
    }
    print(String(format:"X = %.3f, with epsilon \(eps)", x(&x0, &x1)))
}
methodChord()