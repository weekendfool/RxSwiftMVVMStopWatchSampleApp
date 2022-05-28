//
//  StopWatchViewModel2.swift
//  RxSwiftMVVMStopWatchSampleApp
//
//  Created by Oh!ara on 2022/05/29.
//

import Foundation
import RxSwift
import RxCocoa


protocol StopWatchViewModel2Input {
    // timerを止めるかどうかのイベント
    var isPauseTimer: PublishRelay<Bool> { get } //  get専用
    // resetボタンを押されたかどうかのイベント
    var isResetButtonTapped: PublishRelay<Void> { get }
}

protocol StopWatchViewModel2Output {
    // タイマーを作動させるかどうか
    var isTimerWorked: Driver<Bool> { get }
    // timerの表示用
    var timerText: Driver<String> { get }
    // リセットボタンの表示非表示
    var isResetButtonHidden: Driver<Bool> { get }
    
}

protocol StopWatchViewModel2Type {
    var input: StopWatchViewModel2Input { get }
    var output: StopWatchViewModel2Output { get}
}

final class StopWatchViewModel2: StopWatchViewModel2Type, StopWatchViewModel2Input, StopWatchViewModel2Output {
    var input: StopWatchViewModel2Input { return self }
    var output: StopWatchViewModel2Output { return self }
    
    // MARK: - input
    // インスタンス化
    var isPauseTimer = PublishRelay<Bool>()
    var isResetButtonTapped = PublishRelay<Void>()
    
    // MARK: - output
    var isTimerWorked: Driver<Bool>
    var timerText: Driver<String>
    var isResetButtonHidden: Driver<Bool>
    
    // その他の変数
    // 購読の管理
    private let disposeBag = DisposeBag()
    // カウント用の変数、初期値あり
    private let totalTimeDuration = BehaviorRelay<Int>(value: 0)
    
    // MARK: - 関数
    
    init() {
        // timerが動いているかどうか
        // isPauseTimer: inputされたものがDriverになっている
        // (onErrorDriveWith: .empty())はエラーを無視
        isTimerWorked = isPauseTimer.asDriver(onErrorDriveWith: .empty())
        
        // タイマーに表示する文字の設定
        timerText = totalTimeDuration
            .map { value in
                // totalTimeDurationの値を加工する
                String("\( Double(value) / 10) ")
            }
        // Driverとして流す
            .asDriver(onErrorDriveWith: .empty())
        
        // resetButtoを表示するかどうか
        //　Observable.mergで新しいObservableを生成：isTimerWorked.asObservable()　と　isResetButtonTapped　のふたつで
        //　Observableを生成する前にisResetButtonTappedの値を加工
        isResetButtonHidden = Observable.merge(isTimerWorked.asObservable(), isResetButtonTapped.map { _ in true}.asObservable() )
            .skip(1) // 元の一個だけは購読をしない
            .asDriver(onErrorDriveWith: .empty()) // Driverとして流す
        
        // isTimerWorked は普段はイベントを流す側
        //　Observableとしての挙動も可能、今回はObservable側の挙動を設定する
        isTimerWorked.asObservable()
        // flatMapLatest: イベントをObservableに変更する、常に新しいイベントにスイッチして通知する
        // -> Observable<Int>　返り値の設定
            .flatMapLatest { [weak self] isWorked -> Observable<Int> in
                // timerが起動している場合
                if isWorked {
                    //　返却用のObservableの生成
                    //　interval：何秒おきに発火させるか
                    return Observable<Int>.interval( DispatchTimeInterval.milliseconds(1), scheduler: MainScheduler.instance)
                    // withLatestFrom: ObservableにあるObservableに合成する
                    // 合成するObservable実装、self?.totalTimeDuration.valueをもとに生成させる
                    //　{ $0 + $1 }：一個目と二個目の要素をたす加工内容
                        .withLatestFrom(Observable<Int>.just(self?.totalTimeDuration.value ?? 0)) { $0 + $1 }
                } else {
                //　timerが起動していない場合
                    //　返却用のObservableの生成
                    return Observable<Int>.just(self?.totalTimeDuration.value ?? 0)
                }
            }
            // totalTimeDurationに接続する
            .bind(to: totalTimeDuration)
            .disposed(by: disposeBag)
        
        // tapされたかどうかのイベント
        // 加工する：　あたいを全て０にする
        isResetButtonTapped.map { _ in 0 }
            //　totalTimeDurationに接続する
            .bind(to: totalTimeDuration)
            .disposed(by: disposeBag)
    }
    
    
}
