//
//  ViewController.swift
//  RxSwiftMVVMStopWatchSampleApp
//
//  Created by Oh!ara on 2022/05/28.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - 変数

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    private var viewModel: StopWatchViewModel
    
    
    // MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    // MARK: - 関数
    init (viewModel: StopWatchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // それぞれの部品をバインドする
    func bind() {
        
    }
    
}

