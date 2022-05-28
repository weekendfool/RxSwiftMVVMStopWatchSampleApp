//
//  RxSwiftMVVMStopWatchSamplViewModel.swift
//  RxSwiftMVVMStopWatchSampleApp
//
//  Created by Oh!ara on 2022/05/28.
//

import Foundation
import RxCocoa
import RxSwift


//class StopWatchViewModel {
//    // MARK: - input
//
//    // timerが止まっているかどうかフラグ
//    private let isPauseTimerSubject = PublishRelay<Bool>()
//    // リセットボタン押したフラグ
//    private let isResetButtonTappedSubject = PublishRelay<Void>()
//
//    // viewControllerと接続用
//    var isPauseTimer: PublishRelay<Bool> {
//        return isPauseTimerSubject
//    }
//
//    var isResetButtonTapped: PublishRelay<Void> {
//        return isResetButtonTappedSubject
//    }
//
//    // MARK: - output
//
//    // タイマーが動いているかフラグ
//    private let isTimerWorkedSubject = PublishRelay<Bool>()
//    // タイマー表示用ストリング
//    private var timerTextSubject = PublishRelay<String>()
//    // resetボタンの表示非表示
//    private var isResetButtonIsHiddenSubject = PublishRelay<Bool>()
//
//    // viewController接続用
//    var isTimerWorked: PublishRelay<Bool> {
//        return isTimerWorkedSubject
//    }
//
//    var timerText: PublishRelay<String> {
//        return timerTextSubject
//    }
//
//    var isResetButtonIsHidden: PublishRelay<Bool> {
//        return isResetButtonIsHiddenSubject
//    }
//
//    // MARK: - その他
//    private let disposebag = DisposeBag()
//    // timerが何秒たったかの保持用関数？
//    private let totalTimerDuration = BehaviorRelay<Int>(value: 0)
////    private let totalTimerDuration = BehaviorSubject<Int>(value: 0)
//
//    // MARK: - 処理
//    func setup() {
//        // 時間経過の表示用アウトプット
//        timerTextSubject = totalTimerDuration
//            .map {
//                // String型に変換
//                String(Double($0 / 10))
//            }
//
//
//        // resetButtonの表示非表示フラグ
//        isResetButtonIsHiddenSubject = Observable.merge(isTimerWorkedSubject.asObservable(), isResetButtonTapped.map { _ in
//            true
//        }.asObservable())
//        .skip(1) as! PublishSubject<Bool>
//
//        //
//        isTimerWorkedSubject.asObservable()
//            .flatMapLatest { [weak self] isWorked -> Observable<Int> in
//                if isWorked {
//                    return Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
//                        .withLatestFrom(Observable<Int>.just(self?.totalTimerDuration.value ?? 0)) { ($0 + $1) }
//                } else {
//                    let x = Observable<Int>.just(0)
//                    return Observable<Int>.just(self?.totalTimerDuration.value ?? 0)
//                }
//            }
//            .bind(to: totalTimerDuration)
//            .disposed(by: disposebag)
//
//
//        isResetButtonTapped.map { _ in 0 }
//            .bind(to: totalTimerDuration)
//            .disposed(by: disposebag)
//    }
//
//
//}
