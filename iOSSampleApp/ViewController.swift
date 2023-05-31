//
//  ViewController.swift
//  iOSSampleApp
//
//  Created by Mustapha ELOMARI on 24/05/2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("launch map", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemOrange
        // Create a vertical stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        // Add the buttons to the stack view
        stackView.addArrangedSubview(button)
        
        // Add the stack view to the view controller's view
        view.addSubview(stackView)
        
        // Configure the stack view's layout constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        //self.view.addSubview(button)
        self.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }

    @objc func buttonTapped() {
            // Button action code here
            print("Button tapped!")
            let vc = MapViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        }
}

