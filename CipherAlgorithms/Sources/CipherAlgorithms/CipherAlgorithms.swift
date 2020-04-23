public struct CipherAlgorithms {
    let alphabet: String = "abcdefghiklmnopqrstuvwxyz"
    var usedLetters: [(letter: Character, value: Bool)] = []
    var polybiusSquare = [[Character]]()
    
    public init() {
        for letter in alphabet {
            usedLetters.append((letter: letter, value: false))
        }
    }
    
    // FUNCTIONS FOR POLYBIUS ENCRYPTION
    
    func checkUsedLetters(_ char: Character) -> Bool {
        let index: Int?
        
        if (char == "j") {
            index = usedLetters.firstIndex(where: {($0.letter == "i")})
        } else {
            index = usedLetters.firstIndex(where: {($0.letter == char)})
        }
        
        return usedLetters[index!].value
    }
    
    mutating func markLetterUsed(_ char: Character) {
        let index: Int?
        
        if (char == "j") {
            index = usedLetters.firstIndex(where: {($0.letter == "i")})
        } else
        {
            index = usedLetters.firstIndex(where: {($0.letter == char)})
        }
        
        usedLetters[index!].value = true
    }
    
    func findLetterPosition(_ char: Character) -> String {
        var position: String = ""
        for row in 0..<5 {
            for col in 0..<5 {
                if polybiusSquare[row][col] == char {
                    position += String(row + 1)
                    position += String(col + 1)
                    return position
                }
            }
        }
        return position
    }
    
    public mutating func polybiusCipher(_ password: String) {
        var index: Int = 0
        var lineIndex: Int = 0
        
        for _ in 0...4 {
            polybiusSquare.append([Character]())
        }
        
        for char in password {
            if !checkUsedLetters(char) {
                if index > 4 {
                    index = 0
                    lineIndex += 1
                }
                polybiusSquare[lineIndex].append(char)
                markLetterUsed(char)
                index += 1
            }
        }
        
        for (letter, val) in usedLetters
        {
            if val == false {
                if index > 4 {
                    index = 0
                    lineIndex += 1
                }
                
                polybiusSquare[lineIndex].append(letter)
                markLetterUsed(letter)
                index += 1
            }
        }

//        for row in 0..<5 {
//            for col in 0..<5 {
//                print("\(polybiusSquare[row][col])", terminator: " ")
//            }
//            print()
//        }
        
    }
    
    public func polybiusEncryption(_ text: String) -> String {
        var encryptedText: String = ""
        
        for char in text {
            encryptedText += findLetterPosition(char)
        }
        
        return encryptedText
    }
    
    public func polybiusDecryption(_ encryptedText: String) -> String {
        var decryptedText: String = ""
        let intArray = encryptedText.compactMap{$0.wholeNumberValue}
        
        for index in  0..<intArray.count where index % 2 == 0 {
            decryptedText += String(polybiusSquare[intArray[index] - 1][intArray[index + 1] - 1])
        }
        
        return decryptedText
    }
    
    // END FUNCTIONS FOR POLYBIUS ENCRYPTION
    
    
    // FUNCTIONS FOR CEZAR ENCRYPTION
    
    func getIndexOfLetter(_ char: Character) -> Int {
        for index in alphabet.indices {
            if alphabet[index] == char {
                return index.utf16Offset(in: alphabet)
            }
        }
        return 0
    }
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
    
    public func cezarCypher(_ text: String, _ offset: String, _ encrypt: Bool) -> String {
        var encryptedText: String = ""
        let offsetI = Int(offset)
        for char in text {
            var index = getIndexOfLetter(char)
            if encrypt {
                index = mod((index + offsetI!), 25)
            } else {
                index = mod((index - offsetI!), 25)
            }
            let strIndex = alphabet.index(alphabet.startIndex, offsetBy: index)
            encryptedText += String(alphabet[strIndex])
        }
        
        return encryptedText
    }
    
    // END FUNCTIONS FOR CEZAR ENCRYPTION
}
