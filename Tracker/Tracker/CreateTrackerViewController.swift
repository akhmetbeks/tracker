//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 22.08.2025.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    private let titleTextField = UITextField()
    private let clearButton = UIButton()
    private let errorLabel = UILabel()
    
    private var showErrorLabel = false {
        didSet {
            if oldValue == false {
                errorLabel.isHidden = false
            } else {
                errorLabel.isHidden = true
            }
        }
    }
    
    private var showClearButton = false {
        didSet {
            if oldValue == false {
                clearButton.isHidden = false
            } else {
                clearButton.isHidden = true
            }
        }
    }
    
    let maxLength = 38
    
    override func viewDidLoad() {
        view.backgroundColor = .ybBlack
        navigationItem.title = "Новая привычка"
        
        titleTextField.placeholder = "Введите название трекера"
        titleTextField.addTarget(self, action: #selector(limitLength), for: .editingChanged)
        titleTextField.font = .ypRegular
        titleTextField.textColor = .text
        titleTextField.backgroundColor = .background
        titleTextField.layer.cornerRadius = 16
        titleTextField.layer.masksToBounds = true
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        clearButton.setImage(UIImage(resource: .clear), for: .normal)
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        clearButton.isHidden = true
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel.text = "Ограничение 38 символов"
        errorLabel.textColor = .ybRed
        errorLabel.font = .ypRegular
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.addSubview(clearButton)
        view.addSubview(titleTextField)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            clearButton.centerYAnchor.constraint(equalTo: titleTextField.centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor, constant: -12),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
        ])
    }
    
    @objc private func limitLength(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 && showClearButton == false {
                showClearButton = true
            } else if text.count == 0 && showClearButton == true {
                showClearButton = false
            }
            
            if text.count > maxLength {
                textField.text = String(text.prefix(maxLength))
                if showErrorLabel == false { showErrorLabel = true }
            } else if showErrorLabel == true {
                showErrorLabel = false
            }
        }
    }
    
    @objc private func clearTextField() {
        titleTextField.text = ""
    }
}
