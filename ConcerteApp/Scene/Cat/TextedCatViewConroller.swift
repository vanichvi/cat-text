//
//  TextedCatViewConroller.swift
//  ConcerteApp
//
//  Created by Ivan Vinogradov on 03.11.2024.
//

import Foundation
import UIKit

class TextedCatViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        view.backgroundColor = .white
    }
    
    @IBAction private func downloadCatImage() {
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
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)?fontSize=50&fontColor=white") else { return }
        
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
