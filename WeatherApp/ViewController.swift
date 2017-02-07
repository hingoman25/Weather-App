//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sahil M. Hingorani on 2/3/17.
//  Copyright © 2017 Sahil M. Hingorani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var degree: Int!
    var condition: String!
    var imgURL:String!
    var city: String!
    
    var exists: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let urlRequest = URLRequest(url: URL(string: "http://api.apixu.com/v1/current.json?key=f35e1fe966454cc4914205843170302&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil { //*****
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    
                    if let current = json["current"] as? [String: AnyObject] {  //**
                        self.degree = current["temp_c"] as! Int
                            
                        if let condition = current["condition"] as? [String: AnyObject] {
                            self.condition = condition["text"] as! String
                            let icon = condition["icon"] as! String
                            self.imgURL = "http:\(icon)"
                        }
                    } //**
                    
                    if let location = json["location"] as? [String: AnyObject] { //***
                        self.city = location["country"] as! String
                        
                    } //***
                    
                    if let _ = json["error"] {
                        self.exists = false
                    }
                    
                    DispatchQueue.main.async {
                        if self.exists {
                            self.degreeLabel.isHidden = false
                            self.conditionLabel.isHidden = false
                            self.imgView.isHidden = false
                            self.degreeLabel.text = "\(self.degree.description)°"
                            self.cityLabel.text = self.city
                            self.conditionLabel.text = self.condition
                            self.imgView.downloadImage(from: self.imgURL)
                        }
                        else {
                            self.degreeLabel.isHidden = true
                            self.conditionLabel.isHidden = true
                            self.imgView.isHidden = true
                            self.cityLabel.text = "City does not exist"
                            self.exists = true
                        }
                    }
                    
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
                
            } //*****
        }
        task.resume()
    }
}

extension UIImageView {
    
    
    func downloadImage(from url: String)  {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

