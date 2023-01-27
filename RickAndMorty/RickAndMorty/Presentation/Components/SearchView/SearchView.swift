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

final class SearchView: XibView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var deleteTextButtonView: UIView!
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<CharactersSearchViewState, Never>()
    var publisher: AnyPublisher<CharactersSearchViewState, Never> { subject.eraseToAnyPublisher() }
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    
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
        showShadow(false)
    }
    
    func showShadow(_ show: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.layer.shadowOpacity = show ? 1 : 0
        }
    }
}

private extension SearchView {
    func setupView() {
        configureShadow()
        configureContainerView()
        configureTextField()
    }
    
    func configureShadow() {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowRadius = iPadDevice ? 10 : 5
        layer.shadowOpacity = 0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: iPadDevice ? 5 : 3)
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

extension SearchView: UITextFieldDelegate {
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
