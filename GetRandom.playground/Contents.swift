func getZeroOrOne() -> Int {
    Int.random(in: 0 ... 1)
}

func getRandom(maxNumber: Int) -> Int {
    guard maxNumber > 2 else {
        if maxNumber == 2 { return getZeroOrOne() }
        else { return 0 }
    }
    var resutString = String()
    let binaryString = String(maxNumber - 1, radix: 2)
    
    for _ in 0 ..< binaryString.count - 1 {
        resutString += String(getZeroOrOne())
    }
    
    if Int(binaryString.dropFirst(), radix: 2)! < Int(resutString, radix: 2)! {
        return Int(resutString, radix: 2)!
    } else {
        resutString = String(getZeroOrOne()) + resutString
        return Int(resutString, radix: 2)!
    }
}

for _ in 0 ... 50 {
    print(getRandom(maxNumber: 2))
}

