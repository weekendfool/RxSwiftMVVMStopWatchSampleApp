//
//  RxSwiftMVVMStopWatchSamplViewModel.swift
//  RxSwiftMVVMStopWatchSampleApp
//
//  Created by Oh!ara on 2022/05/28.
//

import Foundation
import RxCocoa
import RxSwift


class StopWatchViewModel {
    // MARK: - input
    
    // timerが止まっているかどうかフラグ
    private let isPauseTimerSubject = PublishSubject<Bool>()
    // リセットボタン押したフラグ
    private let isResetButtonTappedSubject = PublishSubject<Void>()
    
    // viewControllerと接続用
    var isPauseTimer: Observable<Bool> {
        return isPauseTimerSubject
    }
    
    var isResetButtonTapped: Observable<Void> {
        return isResetButtonTappedSubject
    }
    
    // MARK: - output
    
    // タイマーが動いているかフラグ
    private let isTimerWorkedSubject = PublishSubject<Bool>()
    // タイマー表示用ストリング
    private var timerTextSubject = PublishSubject<String>()
    // resetボタンの表示非表示
    private var isResetButtonIsHiddenSubject = PublishSubject<Bool>()
    
    // viewController接続用
    var isTimerWorked: Observable<Bool> {
        return isTimerWorkedSubject
    }
    
    var timerText: Observable<String> {
        return timerTextSubject
    }
    
    var isResetButtonIsHidden: Observable<Bool> {
        return isResetButtonIsHiddenSubject
    }
    
    // MARK: - その他
    private let disposebag = DisposeBag()
    // timerが何秒たったかの保持用関数？
//    private let totalTimerDuration = BehaviorRelay<Int>(value: 0)
    private let totalTimerDuration = BehaviorSubject<Int>(value: 0)
    
    // MARK: - 処理
    func setup() {
        // 時間経過の表示用アウトプット
        timerTextSubject = totalTimerDuration
            .map { event inprivate let totalTimerDuration = BehaviorRelay<Int>(value: 0)
                // String型に変換
                String(Double(event / 10))
            } as! PublishSubject<String>
        
        
        // resetButtonの表示非表示フラグ
        isResetButtonIsHiddenSubject = Observable.merge(isTimerWorkedSubject.asObservable(), isResetButtonTapped.map { _ in
            true
        }.asObservable())
        .skip(1) as! PublishSubject<Bool>
        
        //
        isTimerWorkedSubject.asObservable()
            .flatMapLatest { [weak self] isWorked -> Observable<Int> in
                if isWorked {
                    return Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
                        .withLatestFrom(Observable<Int>.just(self?.totalTimerDuration.value ?? 0)) { ($0 + $1) }
                } else {
                    let x = Observable<Int>.just(0)
                    return Observable<Int>.just(self?.totalTimerDuration.value ?? 0)
                }
            }
            .bind(to: totalTimerDuration)
            .disposed(by: disposebag)
        
        
        isResetButtonTapped.map { _ in 0 }
            .bind(to: totalTimerDuration)
            .disposed(by: disposebag)
    }
    
    
}
