//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 16/07/24.
//

import UIKit

class SearchVC: UIViewController {
    var imageView: UIImageView = UIImageView(image: .ghLogo)
    var button: GFButton = GFButton(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
    var textField: GFTextField = GFTextField()
    
    var isUserNameEntered: Bool {
        !(textField.text?.isEmpty ?? true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addKeyBoardNotification()
        createTapGesture()
        self.view.addSubViews(imageView, textField, button)
        configureImageview()
        configureTextField()
        configureButton()
    }
    
    func addKeyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo, 
        let keyBoardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        let currentTextField = UIResponder.currentFirst() as? UITextField else {
            return
        }
        
        let keyboardTopY = keyBoardFrame.cgRectValue.origin.y

        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview) // keyboard coordinate is w.r.t parent view, so need to convert to parent
        
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.height
        if textFieldBottomY > keyboardTopY {
            let newFrame = (textFieldBottomY - keyboardTopY + 20.0) * -1 // 20.0 for space between element & keyboard
            view.frame.origin.y = newFrame
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func createTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.textField.text = ""
    }
   
    func configureImageview() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func configureTextField() {
        textField.delegate = self
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 48),
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureButton() {
        button.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func pushFollowerListVC() {
        guard isUserNameEntered else {
            self.presentGFAlertViewController(
                title: "Empty Username",
                message: "Please enter an username, we need to know who to look for 😄.",
                buttonTitle: "Ok")
            return
        }
        
        textField.resignFirstResponder()
        
        let followerListVC = FollowersListVC(userName: textField.text!)
        self.navigationController?.pushViewController(followerListVC, animated: true)
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}

#Preview {
    SearchVC()
}
