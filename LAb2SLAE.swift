import Foundation
typealias Matrix = [[Double]]
let A : Matrix = [[1.7,-1.3,-1.1,-1.2],
                  [10,-10,-1.3,1.3],
                  [3.5,3.3,1.2,1.3],
                  [1.3,1.1,-1.3,-1.1]]
let B : [Double] = [2.2,1.1,1.2,10]
let len : Int = B.count
func printMatrix(matrix: Matrix) -> () {
    for col in 0..<matrix.count {
        var line = ""
        for row in 0..<matrix[col].count {
            line += String(format: "%.2f\t", matrix[col][row])
            line += " "
        }
        print(line)
    }
}
let showExpr = {(A : Matrix, B : [Double]) -> Void in
    var row : String
    for i in 0..<A.count {
        row = ""
        for j in 0..<A[i].count {
            if j > 0 {
                row +=  A[i][j] > 0.0 ? "+ \(A[i][j])x\(j+1) " : "- \(fabs(A[i][j]))x\(j+1) "
            } else { row += "\(A[i][j])x\(j+1) "}
        }
        row += "= \(B[i])"
        print(row)
    }
}

func doolittle(_ matrix: Matrix, rightValue: [Double], len: Int) -> () {
    print("\t\t\tLU Doolittle method")
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
    print("L-matrix: ")
    printMatrix(matrix: L)
    print("U-matrix: ")
    printMatrix(matrix: U)
    var Z : [Double] = Array(repeating: 0, count: len)
    for i in 0..<len {
        Z[i] = rightValue[i]
        for j in 0..<i {
            Z[i] -= L[i][j] * Z[j]
        }
    }
    let showArray : ([Double]) -> () = { array in
        var str : String = ""
        for i in 0..<len {
            str += String(format: "%.3f\t", array[i])
        }
        print(str)
    }
    print("Z array: ")
    showArray(Z)
    
    var X = Array(repeating: 0.0, count: len)
    for i in (0..<len).reversed() {
        X[i] = Z[i]
        for j in (i+1..<len).reversed() {
            X[i] -= U[i][j] * X[j]
        }
        X[i] /= U[i][i]
    }
    print("X array: ")
    showArray(X)
}

func gaussSeidel(_ matrix: Matrix, rightValue: [Double], len: Int) -> () {
    print("\n\t\t\tGauss–Seidel method")
    var X = Array(repeating: 0.0, count: len)
    var previousX = Array(repeating: 0.0, count: len)
    let eps = 0.001
    var s : Double = 0
    func diagonalDominant() -> Bool {
            for i in 0..<len {
                s = 0
                for j in 0..<len {
                    if i != j {
                        s += fabs(matrix[i][j])
                    }
                }
                if fabs(matrix[i][i]) < s { return false }
        }
        return true
    }
    if !diagonalDominant() { /*Checking the diagonal dominant condition*/
        print("The matrix is not diagonally dominant.")
        return
    }
    var iter = 1
    repeat {
        var out = ""
        out += "\(iter).\t"
        iter += 1;
        for i in 0..<len {
            s = 0
            for j in 0..<len {
                if i != j {
                    s += matrix[i][j] * X[j]
                }
            }
            X[i] = (rightValue[i] - s) / matrix[i][i]
            out += String(format: "%.4f\t\t", previousX[i])
        }
        print(out)
        
        var error = 0.0
        for k in 0..<len {
            error += fabs(X[k] - previousX[k])
        }
        if error < eps { break }
        for i in 0..<len {
            previousX[i] = X[i]
        }
    } while(true)
    
}

showExpr(A, B)
doolittle(A, rightValue: B, len: len)
gaussSeidel(A, rightValue: B, len: len)


print("\n\t\t\tAnother matrix example")
let A2 : Matrix = [[4,1,1,1],
                   [1,4,1,1],
                   [1,1,4,1],
                   [1,1,1,4]]
let B2 : [Double] = [1, 2, 3, 4]
showExpr(A2, B2)
doolittle(A2, rightValue: B2, len: A2.count)
gaussSeidel(A2, rightValue: B2, len: A2.count)