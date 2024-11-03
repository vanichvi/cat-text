//
//  TextedCatViewConroller.swift
//  ConcerteApp
//
//  Created by Ivan Vinogradov on 03.11.2024.
//

import Foundation
import UIKit

class TextedCatViewController: UIViewController, UITextFieldDelegate {
    
    private let scrollView = UIScrollView()
    private let textField = UITextField()
    private let downloadButton = UIButton(type: .system)
    private let catImageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        textField.placeholder = "Enter text"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textField)
        
        downloadButton.setTitle("Download Cat", for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadCatImage), for: .touchUpInside)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(downloadButton)
        
        catImageView.contentMode = .scaleAspectFit
        catImageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(catImageView)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            catImageView.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 20),
            catImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            catImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            catImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: catImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: catImageView.centerYAnchor)
        ])
    }
    
    @objc private func downloadCatImage() {
        guard let text = textField.text, !text.isEmpty else {

            let alert = UIAlertController(title: "Error", message: "Please enter some text", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        activityIndicator.startAnimating()
        downloadButton.isEnabled = false
        
        downloadCat(with: text)
    }
    
    private func downloadCat(with text: String) {
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)?fontSize=50&color=white") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.downloadButton.isEnabled = true
                
                guard let data = data, error == nil else {
                    let alert = UIAlertController(title: "Error", message: "Could not load the image.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    return
                }
                
                self?.catImageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
