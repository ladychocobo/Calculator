//
//  ViewController.swift
//  calculator
//
//  Created by Jamie Chen on 3/11/17.
//  Copyright © 2017 Jamie Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var button:UIButton!
    var label:UILabel!
    var buttonCollection = [UIButton]()
    var buttonTitleArray = [["X²", "√", "%", "÷"], ["7", "8", "9", "x"], ["4", "5", "6", "-"], ["1", "2", "3", "+"], ["C", "0", ".", "="]]
    var calculation: Double {
        get {
            return Double(self.label.text!)!
        }
        
        set {
            self.label.text = String(newValue)
        }
    }
    var isInputNumbers = false
    var outerStackView:UIStackView!
    private var calculate = OperatorCalculation()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        self.outerStackView = self.setupStackView(direction: .vertical, view: .fillProportionally)
        
        self.label = UILabel()
        self.label.text = "0"
        self.label.backgroundColor = .darkGray
        self.label.textAlignment = .right
        self.label.font = UIFont(name: self.label.font.fontName, size: 60)
        self.label.textColor = UIColor(red: 1.0, green: 253 / 255, blue: 231 / 255, alpha: 1.0)
        self.label.adjustsFontSizeToFitWidth = true
        self.outerStackView.addArrangedSubview(self.label)
        // 內部stackview
        var innerButtonStackView:UIStackView!
        // 外部stackview -> 包內部stackview
        let outerButtonStackView = self.setupStackView(direction: .vertical, view: .fillEqually, spacing: 2)
        for eachArray in self.buttonTitleArray {
            innerButtonStackView = self.setupStackView(direction: .horizontal, view: .fillEqually, spacing: 2, auto: true)
            for title in eachArray {
                self.button = UIButton()
                self.button.setTitle(title, for: .normal)
                
                // grass green
                self.button.backgroundColor = UIColor(red: 139 / 255, green: 195 / 255, blue: 74 / 255, alpha: 1.0)
                // light yellow
                self.button.setTitleColor(UIColor(red: 255 / 255, green: 253 / 255, blue: 231 / 255, alpha: 1.0), for: .normal)
                self.button.titleLabel?.font = UIFont.systemFont(ofSize: 48)
                self.button.layer.borderColor = UIColor.darkGray.cgColor
                switch title {
                case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", "C":
                    self.button.addTarget(self, action:#selector(self.onNumericAction(_:)), for: .touchUpInside)
                default:
                    self.button.addTarget(self, action:#selector(self.onOperatorAction(_:)), for: .touchUpInside)
                }
                self.buttonCollection.append(self.button)
                innerButtonStackView.addArrangedSubview(self.button)
            }
            outerButtonStackView.addArrangedSubview(innerButtonStackView)
        }
        self.outerStackView.addArrangedSubview(outerButtonStackView)
        self.view.addSubview(self.outerStackView)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[outerStackView]-10-|", options: .alignAllLeading, metrics: nil, views: ["outerStackView":self.outerStackView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[outerStackView]-10-|", options: .alignAllLeading, metrics: nil, views: ["outerStackView":self.outerStackView]))
    }
    
    func onOperatorAction(_ sender: UIButton) {
        if self.isInputNumbers {
            self.calculate.setOperand(self.calculation)
            self.isInputNumbers = false
        }
        
        if let operatorSymobol = sender.currentTitle {
            // 按到哪一個按鈕將會出現邊筐提示使用者
            for eachButton in self.buttonCollection {
                if operatorSymobol == eachButton.currentTitle, operatorSymobol != "=" {
                    eachButton.layer.borderWidth = 5.0
                } else {
                    // 清除邊筐
                    eachButton.layer.borderWidth = 0.0
                }
            }
            
            self.calculate.performOperation(operatorSymobol)
        }
        
        if let result = self.calculate.result {
            self.calculation = result
        }
    }

    func onNumericAction(_ sender: UIButton!) {
        // 清除所有button的border
        let digit = sender.currentTitle!
        for eachButton in self.buttonCollection {
            if eachButton.layer.borderWidth > 0 {
                eachButton.layer.borderWidth = 0.0
            }
        }

        switch digit {
        // 清除數字
        case "C":
            isInputNumbers = false
            self.label.text = "0"
        // 小數點：不清除0直接放小數點
        case ".":
            self.label.text = self.label.text! + digit
            isInputNumbers = true
        // 0~9
        default:
            let maxNumber = 12
            if let textCurrentlyInDisplay = self.label.text, textCurrentlyInDisplay.characters.count < maxNumber {
                if isInputNumbers {
                    self.label.text = textCurrentlyInDisplay + sender.currentTitle!
                } else {
                    // 如果是聽一個數字按到0的時候，不會出現很多0
                    if self.label.text == digit, digit == "0" {
                        self.label.text = digit
                    } else {
                        self.label.text = digit
                        isInputNumbers = true
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupStackView(direction axis: UILayoutConstraintAxis, view distribution: UIStackViewDistribution, spacing space:CGFloat = 10, auto resizing: Bool = false) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = resizing
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.spacing = space
        stackView.distribution = distribution
        return stackView
    }
}


