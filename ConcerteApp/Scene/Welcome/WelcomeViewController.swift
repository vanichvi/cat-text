//
//  WelcomeViewController.swift
//  ConcerteApp
//
//  Created by Konstantin Kulakov on 27.10.2024.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    private let openTextedCatButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = "Готов к загрузке!"
        activityIndicator.hidesWhenStopped = true
        
        view.backgroundColor = .white
        setupTextedCatButton()
    }
    
    private func downloadCat() {
        guard let url = URL(string: "https://cataas.com/cat") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.catImageView.image = UIImage(data: data)
                self?.statusLabel.text = "Загрузка кота закончена"
                self?.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        activityIndicator.startAnimating()
        statusLabel.text = "Начинаю загрузку кота!"
        downloadCat()
    }
    
    private func setupTextedCatButton() {
        openTextedCatButton.setTitle("Открыть TextedCat", for: .normal)
        openTextedCatButton.addTarget(self, action: #selector(openTextedCat), for: .touchUpInside)
        openTextedCatButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openTextedCatButton)
        
        NSLayoutConstraint.activate([
            openTextedCatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openTextedCatButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func openTextedCat() {
        let textedCatVC = TextedCatViewController()
        textedCatVC.modalPresentationStyle = .fullScreen
        present(textedCatVC, animated: true, completion: nil)
    }
}

