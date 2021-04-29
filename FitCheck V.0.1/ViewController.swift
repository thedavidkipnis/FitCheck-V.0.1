//
//  ViewController.swift
//  FitCheck V.0.1
//
//  Created by David Kipnis and Hannah Buzard on 4/7/21.
//  Copyright © 2021 David Kipnis and Hannah Buzard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isOn: Bool = false
    var imageStrings = [String]()
    var imageCount = 1
    //animating nav bar button clicks
    @IBAction func animateButton(sender: UIButton) {

        sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)

        UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(0.20),
                                   initialSpringVelocity: CGFloat(6.0),
                                   options: UIView.AnimationOptions.allowUserInteraction,
                                   animations: {
                                    sender.transform = CGAffineTransform.identity
            },
                                   completion: { Void in()  }
        )
    }
    
    //clicking the socials page button
    @IBAction func SocialClick(_ sender: UIButton) {
        isOn.toggle()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "social") as! SocialsPage
        self.view.window?.rootViewController = nextViewController
        self.present(nextViewController, animated: true, completion: {
            nextViewController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })}
    
    //clicking the home page button
    @IBAction func mainButtonPress(_ sender: UIButton) {
        isOn.toggle()
    }
    
    //clicking the closet page button
    @IBAction func ClosetClick(_ sender: UIButton) {
        isOn.toggle()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "closet") as! Closet
        self.view.window?.rootViewController = nextViewController
        self.present(nextViewController, animated: true, completion: {
            nextViewController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    //clicking the likes page button
    @IBAction func LikesClick(_ sender: UIButton) {
        isOn.toggle()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "likes") as! LikesPage
        self.view.window?.rootViewController = nextViewController
        self.present(nextViewController, animated: true, completion: {
            nextViewController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })}
    
    //outlets for the card and the two like icons on the card for swiping
    @IBOutlet weak var Card: UIImageView!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var dislikeIcon: UIImageView!
    @IBOutlet weak var navBar: UIView!
    
    //card Swiping
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        var leftRotate = false
        var regenFlag = false
        let card = sender.view!
        let ogy = card.center.y
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
            
        if xFromCenter > 0 {
            likeIcon.alpha = xFromCenter / 100
            dislikeIcon.alpha = 0
        } else {
            dislikeIcon.alpha = xFromCenter / -100
            likeIcon.alpha = 0
        }
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y - 50)
        
        //when user stops holding the card, check if it passed boundaries
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 75 {
            //move card off screen to the left
                leftRotate = true
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.transform = card.transform.rotated(by: -.pi/10)
                    card.alpha = 0
                })
                imageCount = imageCount + 1
                regenFlag = true
            } else if card.center.x > (view.frame.width - 75) {
            //move card off screen to the right
                leftRotate = false
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.transform = card.transform.rotated(by: .pi/10)
                    card.alpha = 0
                })
                imageCount = imageCount + 1
                regenFlag = true
            }
            
            if regenFlag == false {
            UIView.animate(withDuration: 0.2, animations: {
                card.center = CGPoint(x: self.view.center.x, y: ogy)
                self.likeIcon.alpha = 0
                self.dislikeIcon.alpha = 0
            })
            } else {
                likeIcon.alpha = 0
                dislikeIcon.alpha = 0
                card.center = CGPoint(x: self.view.center.x, y: ogy)
                if leftRotate == true {
                    card.transform = card.transform.rotated(by: .pi/10)
                } else {
                    card.transform = card.transform.rotated(by: -.pi/10)
                }
                card.alpha = 1
                let image = UIImage(named: imageStrings[imageCount - 1])
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 0, y: 0, width: 314, height: 540)
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = 20
                imageView.layer.masksToBounds = true
                self.Card.addSubview(imageView)
                Card.bringSubviewToFront(likeIcon)
                Card.bringSubviewToFront(dislikeIcon)
            }
        }
    }
    
    @IBOutlet weak var socialsButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var closetButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        animateButton(sender: mainButton)
        mainButton.tintColor = UIColor.systemYellow
        
        // Get each image in images folder and create array of images
        imageStrings.removeAll()
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("images.bundle")

        do {
          let contents = try fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)

          for item in contents
          {
            let filename = item.lastPathComponent
            let splitString = filename.components(separatedBy: ".")
            let file: String = splitString[0]
            imageStrings.append(file)
          }
        }
        catch let error as NSError {
          print(error)
        }
        
        //generating and adding image to first card
        let image = UIImage(named: imageStrings[0])
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 314, height: 540)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        self.Card.addSubview(imageView)
        Card.bringSubviewToFront(likeIcon)
        Card.bringSubviewToFront(dislikeIcon)
        
    }
}

