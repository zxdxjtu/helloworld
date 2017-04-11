//
//  ViewController.swift
//  RITW.HelloWorld
//
//  Created by XIndong Zhang on 2017/1/28.
//  Copyright © 2017年 SmackInnovations. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tempImage: UIImage?
    @IBOutlet weak var img: UIImageView!
    
//    var listOfAPPs = ["helloworld","enterworld","byeworld", "MyGasFeed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let prefs = UserDefaults.standard
//        for name in listOfAPPs{
//            let nameactived = name+"Actived"
//            let namename = name+"appName"
//            let nameicon = name+"iconURL"
//            let nameapp = name+"appURL"
//            prefs.removeObject(forKey: nameactived)
//            prefs.removeObject(forKey: namename)
//            prefs.removeObject(forKey: nameicon)
//            prefs.removeObject(forKey: nameapp)
//        }
        // Do any additional setup after loading the view, typically from a nib.
        //Send info to Smack Hub
        UserDefaults(suiteName: "group.com.RITW")!.set(true, forKey: "helloworldActived")
        UserDefaults(suiteName: "group.com.RITW")!.set("http://www.apple.com/euro/ios/ios8/a/generic/images/og.png", forKey:"helloworldiconURL")
        UserDefaults(suiteName: "group.com.RITW")!.set("helloworld", forKey:"helloworldappName")
        UserDefaults(suiteName: "group.com.RITW")!.set("OpenAppTest://",forKey:"helloworldappURL")
//        
//        print("Begin of code")
//        if let checkedUrl = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
//            img.contentMode = .scaleAspectFit
//            downloadImage(url: checkedUrl)
//        }
//        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
        
    }

    @IBAction func LoadImage(_ sender: Any) {
        self.getImage()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func retrieveData(_ sender: Any) {
//        let userDefaults = UserDefaults(suiteName: "group.com.RITW")
//        if let testUserId = userDefaults?.object(forKey: "userId") as? String {
//            print("User Id: \(testUserId)")
//        }
        let firstmessage = UserDefaults(suiteName: "group.com.RITW")!.bool(forKey: "FirstLaunch")
        print("message we got: \(firstmessage)")
    }
    
    func saveImageDocumentDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("apple.jpg")
//        let image = UIImage(named: "apple.jpg")
        let image = self.tempImage
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImage(){
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("apple.jpg")
        if fileManager.fileExists(atPath: imagePAth){
            img.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
    }
    
    func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }

    func deleteDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
        }else{
            print("Something wronge.")
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.tempImage = UIImage(data: data)
            }
            self.createDirectory()
            self.saveImageDocumentDirectory()
        }
    }
    
    

}

