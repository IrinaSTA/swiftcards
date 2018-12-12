//
//  GameViewController.swift
//  SwiftCards
//
//  Created by Imogen Misso on 12/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet var gamePage: UIView!
    @IBOutlet weak var handView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func deckTapped(_ sender: Any) {
        player.draw(deck: deck)
    }
    @IBAction func load(_ sender: UIButton) {
        let game = Game(handSize: handSize, players: [player])
        let image = UIImage(named: game.deck.cards[0].name + ".png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 50, y: 50, width: 100, height: 200)
        handView.addSubview(imageView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
