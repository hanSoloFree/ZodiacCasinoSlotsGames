//
//  SlotViewController.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 16.08.2021.
//

import UIKit
import AVFoundation
import AVKit
import SpriteKit

class SlotViewController: BaseVC, SKSceneDelegate {
    
    @IBOutlet weak var spinButton: UIButton!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var levelProgressBar: LevelProgressBar!
    @IBOutlet weak var maxWin: UIButton!
    
    private var maxWinCounter = 0 {
        didSet {
            maxWin.setTitle(String(maxWinCounter), for: .normal)
        }
    }
    
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var imageLevel: UIImageView!
    
    var player: AVAudioPlayer!
    
    @IBAction func musicTapped(_ sender: Any) {
        if Level.shared.musicOn == false {
            backgroundPlayer.cheer()
            musicButton.setImage(UIImage(named: "soundOn"), for: .normal)
            Level.shared.musicOn = true
        }else {
            backgroundPlayer.stop()
            musicButton.setImage(UIImage(named: "soundOff"), for: .normal)
            Level.shared.musicOn = false
        }
    }
    
    private var progressPoints: Int = Level.shared.progress {
        didSet {
            if progressPoints > 1000 {
                Level.shared.progressLevel = 2
                Level.shared.progress = 0
                imageLevel.image = UIImage(named: "star2")
            }
            progressPoints = Level.shared.progress
            levelProgressBar.progress = CGFloat(progressPoints) / 1000.0
            print(levelProgressBar.progress, Level.shared.progress)
        }
    }
    
    @IBAction func goToShopFromCounterButton(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    private var coinsPool = Level.shared.coinsPool {
        didSet {
            Level.shared.coinsPool = coinsPool
            coinsCounterLabel.text = "\(coinsPool.withCommas())"
        }
    }
    
    @IBOutlet weak var coinsCounterLabel: UILabel! {
        didSet {
            coinsCounterLabel.text = "\(Level.shared.coinsPool.withCommas())"
        }
    }
    
    private var arrayOfElements: [UIImage] = []
    var slotsElements: [UIImage] = []
    
    private var numberOfRawsInOneSlot = 30
    private var cellID = "cellID"
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Level.shared.musicOn == false {
            musicButton.setImage(UIImage(named: "soundOff"), for: .normal)
        }else {
            musicButton.setImage(UIImage(named: "soundOn"), for: .normal)
        }
    }
    
    var didSpin = false
    
    @IBAction func rollTapped(_ sender: Any) {
        Level.shared.progress = Level.shared.progress + 10
        progressPoints += 10
        if coinsPool <= 0 {
            coinsPool = 0
            spinButton.isEnabled = false
        }
        spinPlayer.cheer()
        if didSpin == false {
            coinsPool = coinsPool - coinsToBet
            if coinsPool < 0 {
                coinsPool = 0
            }
            didSpin = true
            spinButton.isEnabled = false
            machineScene.startSpinning { [self] win in
                Level.shared.coinsPool = Level.shared.coinsPool + (win * coinsToBet)
                maxWinCounter = win * coinsToBet
                print(win)
                print(Level.shared.coinsPool)
                coinsCounterLabel.text = "\(Level.shared.coinsPool.withCommas())"
                didSpin = false
                spinButton.isEnabled = true
                spinPlayer.stop()
            }
        }
    }
    
    var machineScene: SMScene!
    var delegate: SpinMachineDelegate?
    
    private var coinsToBet = 200_000
    
    @IBOutlet weak var coinsToBetButton: UIButton!{
        didSet {
            coinsToBetButton.setTitle("\(coinsToBet)", for: .normal)
        }
    }
    
    @IBAction func bet25MoreCoins(_ sender: UIButton) {
        if coinsToBet < 300_000_000 {
            coinsToBet += 10000
            coinsToBetButton.setTitle("\(coinsToBet)", for: .normal)
        }
    }
    
    @IBAction func bet25LessCoins(_ sender: UIButton) {
        if coinsToBet > 10000 {
            coinsToBet -= 10000
            coinsToBetButton.setTitle("\(coinsToBet)", for: .normal)
        }
    }
    
    var ismusicPlaying: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressPoints = Level.shared.progress
        setupScene()
        ismusicPlaying = false
        arraysFilling()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        spinButton.trailingAnchor.constraint(equalTo: musicButton.trailingAnchor,constant: -4).isActive = true
    }
    
    private func setupScene() {
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        sceneView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true

        machineScene = SMScene()
        machineScene.delegate = self
        machineScene.scaleMode = .resizeFill
        sceneView.backgroundColor = .clear
        sceneView.presentScene(machineScene)
        
    }
    
    private func arraysFilling() {
        for _ in 1...5 {
            slotsElements.forEach { (slot) in
                arrayOfElements.append(slot)
            }
        }
    }
    
    @IBOutlet weak var moreButton: UIButton!
}
