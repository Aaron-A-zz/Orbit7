//
//  GameViewController.swift
//  Orbit7
//
//  Created by James Martinez on 2/7/15.
//  Copyright (c) 2015 Aaron Ackerman. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

  // MARK: - Properties

  let scene = GameScene()

  // MARK: - UIViewController

  override func loadView() {
    view = SKView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let view = self.view as SKView


    view.presentScene(scene)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    scene.size = view.bounds.size
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
