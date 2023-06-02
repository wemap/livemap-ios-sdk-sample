//
//  CustomARView.swift
//  livemap-ios-sdk
//
//  Created by Bertrand Mathieu-Daudé on 21/10/2020.
//  Copyright © 2020 Bertrand Mathieu-Daudé. All rights reserved.
//

import UIKit
import WebKit

public class CustomARView: UIView {
    
    let nibName = "CustomARView"
    var contentView: UIView!

    @IBOutlet weak var livemapContenairView: UIView!
    @IBOutlet internal weak var cameraView: CameraView!
    
    // MARK: Set Up View
    public override init(frame: CGRect) {
        // For use in code
        super.init(frame: frame)
        setUpView()
    }

    public required init?(coder aDecoder: NSCoder) {
        // For use in Interface Builder
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(contentView)
        
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
    
        cameraView.isOpaque = false
        cameraView.backgroundColor = .clear
        setupConstrains(view: self.cameraView, parent: contentView)
    }
    
    // Provide functions to update view
    public func set(isHidden: Bool) {
        self.cameraView.isHidden = isHidden
    }
    
    // Provide functions to update view
    public func set(webMapView: WKWebView) {
        self.livemapContenairView.addSubview(webMapView)
        setupConstrains(view: webMapView, parent: livemapContenairView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = self.bounds
        self.livemapContenairView.frame = self.bounds
        self.cameraView.frame = self.bounds
    }
    
    private func setupConstrains(view: UIView, parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0)
        let leftConstraint = view.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: 0)
        let bottomConstraint = view.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0)
        let rightConstraint = view.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: 0)

        NSLayoutConstraint.activate([topConstraint, leftConstraint, bottomConstraint, rightConstraint].compactMap { $0 })
    }
}
