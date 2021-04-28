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
    
    @IBAction func buttonPress(_ sender: UIButton) {
        isOn.toggle()
        sender.tintColor = UIColor.systemYellow
        mainButton.tintColor = UIColor.white
        closetButton.tintColor = UIColor.white
        likesButton.tintColor = UIColor.white
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "social") as! SocialsPage
        self.view.window?.rootViewController = nextViewController
        self.present(nextViewController, animated: true, completion: {
            nextViewController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })}
    
    @IBAction func mainButtonPress(_ sender: UIButton) {
        isOn.toggle()
    }
    
    @IBAction func ClosetClick(_ sender: UIButton) {
        isOn.toggle()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "closet") as! Closet
        self.view.window?.rootViewController = nextViewController
        self.present(nextViewController, animated: true, completion: {
            nextViewController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @IBAction func LikesClick(_ sender: UIButton) {
        isOn.toggle()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "likes") as! LikesPage
        self.view.window?.rootViewController = nextViewController
        self.present(nextViewController, animated: true, completion: {
            nextViewController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })}
    //card Swiping
    @IBOutlet weak var Card: UIView!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var dislikeIcon: UIImageView!
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        if xFromCenter > 0 {
            likeIcon.alpha = xFromCenter / 100
            dislikeIcon.alpha = 0
        } else {
            dislikeIcon.alpha = xFromCenter / -100
            likeIcon.alpha = 0
        }
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            if card.center.x < 75 {
            //move card off screen to the left
                UIView.animate(withDuration: 0.6, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                UIView.animate(withDuration: 0.6, animations: {
                    card.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
                })
                return
            } else if card.center.x > (view.frame.width - 75) {
            //move card off screen to the right
                UIView.animate(withDuration: 0.6, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                UIView.animate(withDuration: 0.6, animations: {
                    card.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
                })
                return
            }
            
            
            UIView.animate(withDuration: 0.2, animations: {
                card.center = self.view.center
                self.likeIcon.alpha = 0
                self.dislikeIcon.alpha = 0
            })
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
    }
}

