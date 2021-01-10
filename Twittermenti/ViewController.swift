//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    
    
    let sentimentClassifer = TextClassifier()

    let swifter = Swifter(consumerKey: "VSxnMnbbQCzu372w78ObpCVoI", consumerSecret: "NkzAGsXOIYohoBbO2FYyVidTBc9IYcwsZ6FXbtJfHHl9YYcGto")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweet()
        
    }
            
    func fetchTweet(){
        if let textToSearch = textField.text{
        swifter.searchTweet(using: textToSearch, lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in
            
            var tweetArray = [TextClassifierInput]()

            for i in 0..<100{
                if let tweet = results[i]["full_text"].string{
                    let tweetInput = TextClassifierInput(text: tweet)
                    tweetArray.append(tweetInput)
                }
            }
            self.makePrediction(array: tweetArray)
    } failure: { (error) in
        print(error)
    }
    }else {
        print("Search field is empty")
    }
    }
    
        func makePrediction(array: [TextClassifierInput]){
        do{
            var count = 0
            let predictions = try self.sentimentClassifer.predictions(inputs: array)
            for pred in predictions {
                if pred.label == "Pos"{
                    count += 1
                }
                if pred.label == "Neg"{
                    count -= 1
                }
            }
            updateUI(count: count)
    } catch{
        print(error )
    }
}
    func updateUI(count: Int){
        if count > 20{
            self.sentimentLabel.text = "😍"
        }else if count > 10{
            self.sentimentLabel.text = "☺️"
        }else if count > 0{
            self.sentimentLabel.text = "😐"
        }else if count > -10{
            self.sentimentLabel.text = "😧"
        }else if count > -20{
            self.sentimentLabel.text = "😡"
        }
    }
}
