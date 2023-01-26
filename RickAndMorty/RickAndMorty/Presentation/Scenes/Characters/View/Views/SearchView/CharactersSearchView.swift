//
//  CharactersSearchView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

import UIKit
import Combine

enum CharactersSearchViewState {
    case searched(String)
}

final class CharactersSearchView: XibView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var deleteTextButtonView: UIView!
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<CharactersSearchViewState, Never>()
    var publisher: AnyPublisher<CharactersSearchViewState, Never> {
        subject.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func close() {
        textfield.text?.removeAll()
        deleteTextButtonView.isHidden = true
        textfield.resignFirstResponder()
    }
}

private extension CharactersSearchView {
    func setupView() {
        configureContainerView()
        configureTextField()
    }
    
    func configureContainerView() {
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 2
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContainerView))
        containerView.addGestureRecognizer(gestureRecognizer)
        containerView.isUserInteractionEnabled = true
    }
    
    func configureTextField() {
        textfield.delegate = self
        textfield.keyboardType = .default
        textfield.returnKeyType = .search
        textfield.enablesReturnKeyAutomatically = true
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .sentences
        textfield.placeholder = .characters.searchPlaceholder.localized
    }
    
    @objc func didTapContainerView() {
        textfield.becomeFirstResponder()
    }
    
    @IBAction func didTapDeleteTextButton(_ sender: UIButton) {
        textfield.text?.removeAll()
        deleteTextButtonView.isHidden = true
    }
}

extension CharactersSearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textfield.text else { return true }
        textfield.resignFirstResponder()
        subject.send(.searched(text))
        return true
    }
    
    @IBAction func textFieldTextChanged(_ sender: UITextField) {
        guard let text = textfield.text else { return }
        deleteTextButtonView.isHidden = text.isEmpty
    }
}
