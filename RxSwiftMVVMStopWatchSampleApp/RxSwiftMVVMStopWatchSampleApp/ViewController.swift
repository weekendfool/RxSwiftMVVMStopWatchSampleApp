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
    
    private var viewModel: StopWatchViewModel2Type
    private var disposeBag = DisposeBag()
    
    
    // MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        bind()
    }


    // MARK: - 関数
    init (viewModel: StopWatchViewModel2Type) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // それぞれの部品をバインドする
    func bind() {
        // startbuttonのタップをシグナルとしてイベント発火
        startStopButton.rx.tap.asSignal()
            // 加工する: 値の合成　viewModel.isTimerWorkedの値を合成する
            .withLatestFrom(viewModel.output.isTimerWorked)
            // 購読処理
            .emit(onNext: { [ weak self] isTimerStop in
                guard let self = self else { return }
                // イベントの発火
                self.viewModel.input.isPauseTimer.accept(!isTimerStop)
            })
            .disposed(by: disposeBag)
        
        // resetButton
        resetButton.rx.tap.asSignal()
            // 購読処理
            .emit(to: viewModel.input.isResetButtonTapped)
            .disposed(by: disposeBag)
        
        // viewモデル
        //　viewModel.isTimerWorkedを購読する？
        viewModel.output.isTimerWorked
            // イベントの購読
            .drive(onNext: { [weak self] isWorked in
                guard let self = self else { return }
                if isWorked {
                    self.startStopButton.setTitle("stop", for: .normal)
                    self.startStopButton.backgroundColor = .red
                } else {
                    self.startStopButton.setTitle("start", for: .normal)
                    self.startStopButton.backgroundColor = .blue
                }
            })
            .disposed(by: disposeBag)
        
        // timerLabelの表示
        viewModel.output.timerText.asObservable()
            //　bind：購読する処理
            // to: timerLabel.rx.textが購読する
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
        
    
        // resetButtonの表示非表示
        viewModel.output.isResetButtonHidden
            .drive(resetButton.rx.isHidden)
            .disposed(by: disposeBag)

    }
    
}

