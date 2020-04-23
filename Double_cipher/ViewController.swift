//
//  ViewController.swift
//  Double_cipher
//
//  Created by Doru Mancila on 20/04/2020.
//  Copyright © 2020 Doru Mancila. All rights reserved.
//

import UIKit
import CipherAlgorithms

class ViewController: UIViewController {
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var textOffset: UITextField!
    @IBOutlet weak var outputText: UITextView!
    @IBOutlet weak var stateSwitch: UISwitch!
    @IBOutlet weak var computeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputText.delegate = self
        password.delegate = self
        textOffset.delegate = self
        computeButton.layer.cornerRadius = 10
        computeButton.layer.borderWidth = 0.5
        
        let str = readFile()
        
        
        var polybius = CipherAlgorithms()
        polybius.polybiusCipher("secretosi")

        let encryptedMessage = polybius.polybiusEncryption(polybius.cezarCypher(str, "3", true))
        writeFile(encryptedMessage)
//        print(encryptedMessage)
//
//        let decryptedText = polybius.polybiusDecryption("2552253125432125515332")
//        print(polybius.cezarCypher(decryptedText, "3", false))
//
//        print(polybius.cezarCypher("xyz", "2", true))
//        print(polybius.cezarCypher("yza", "1", false))
    }
    
    @IBAction func compute(_ sender: UIButton) {
        var doubleCipher = CipherAlgorithms()
        doubleCipher.polybiusCipher(password.text!)
        
        if !stateSwitch.isOn {
            let encryptedCezarText = doubleCipher.cezarCypher(inputText.text!, textOffset.text!, true)
            let encryptedPolybiusText = doubleCipher.polybiusEncryption(encryptedCezarText)
            outputText.text = encryptedPolybiusText
            writeFile(encryptedPolybiusText)
        } else {
            let decryptedPolybiusText = doubleCipher.polybiusDecryption(inputText.text!)
            let decryptedCezarText = doubleCipher.cezarCypher(decryptedPolybiusText, textOffset.text!, false)
            outputText.text = decryptedCezarText
            writeFile(decryptedCezarText)
        }
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if stateSwitch.isOn {
            inputText.keyboardType = .numberPad
        } else {
            inputText.keyboardType = .default
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if stateSwitch.isOn && inputText.text!.count % 2 != 0 {
            let alert = UIAlertController(title: "Number of digits isn't par.", message: "You need to write a par number of digits. Verify encrypted message", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            textOffset.resignFirstResponder()
            inputText.resignFirstResponder()
        }
    }
    
    func writeFile(_ text: String) {
        let name = "output.txt"
        let fileManager = FileManager.default
        
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:true)
            let fileURL = documentDirectory.appendingPathComponent(name)
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            print(fileURL.path)
        } catch {
            print(error)
        }
    }
    
    func readFile() -> String {
        if let filepath = Bundle.main.path(forResource: "input", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                return contents
            } catch {
                print(error)
            }
        } else {
            print("File not found!")
        }
        return ""
    }
}


extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // input clear text cannot contain numeric numbers
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let characterSet = CharacterSet.letters
        if string.rangeOfCharacter(from: characterSet.inverted) != nil && textField.keyboardType != .numberPad {
            return false
        }
        return true
    }
}
