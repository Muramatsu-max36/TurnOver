//
//  GameViewModel.swift
//  TurnOver
//
//  Created by cmStudent on 2022/12/05.
//

import SwiftUI
import CoreMotion
import AudioToolbox

class GameViewModel: ObservableObject {
    
    var name = ""
    
    var kindValue: kind = .one
    
    var ranking: Ranking
    
    @Published var roll: Double = 0.0
    
    @Published var pitch: Double = 0.0
    
    @Published var count : Double = 0.0
    
    @Published var isHalf = false
    
    @Published var countTimer : Decimal = 0.0
    
    @Published var isStop = false
    
    @Published var timer: Timer?
    
    @Published var result: Double = 0.0
    
    @Published var countDownTimer : Decimal
    
    @Published var isCountDownTimer = true
    
    @Published var soundID: SystemSoundID = 1151
    
    @Published var countDownString = ""
    
    // privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    
    private let queue = OperationQueue()
    
    typealias Client = RealmClient<Ranking>
    
    func lode() {
        startQueuedUpdates()
    }
    
    init() {
        self.countDownTimer = Decimal(3.0)
        ranking = Ranking()
    }
    
    private func startQueuedUpdates() {
        self.startTimer()
        // ジャイロセンサーが使えない場合はこの先の処理をしない
        guard motion.isGyroAvailable else { return }
        
        // 更新間隔 0.1秒間隔
        motion.gyroUpdateInterval = 6.0 / 60.0
        
        self.motion.showsDeviceMovementDisplay = true
        
        // ジャイロセンサーを利用して値を取得する
        // とってくるdataの型はCMGyroData?になっている
        self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: self.queue) { data, error in
            if let validdata = data {
                
                let roll = validdata.attitude.roll * 57.3
                let pitch = validdata.attitude.pitch * 57.3
                
                DispatchQueue.main.async {
                    self.roll = round(roll * 100) / 100
                    self.pitch = round(pitch * 100) / 100
                    
                    self.loop {
                        if (roll > 170 || roll < -170) && self.isHalf == false {
                            if self.isHalf == false {
                                self.count += 0.5
                                print(self.count)
                            }
                            self.isHalf = true
                        }
                        if (-10 < roll && roll < 10) && self.isHalf == true {
                            if self.isHalf == true {
                                self.count += 0.5
                                print(self.count)
                            }
                            self.isHalf = false
                        }
                    }
                }
            }
        }
    }
    
    // ループ処理
    func loop(runnable: () -> ()){
        runnable()
    }
    
    // ストップタイマー
    func startTimer() {
        var second: Double = 5.0
        switch kindValue {
        case .one:
            second = 5.0
        case .two:
            second = 10.0
        case .three:
            second = 20.0
        }
        
        DispatchQueue.main.async {
            self.timer(end: Decimal(second), kindNum: 2)
        }
    }
    
    func startCountDownTimer() {
        print("スタート\(countDownTimer)")
        DispatchQueue.main.async {
            self.timer(end: Decimal(0), kindNum: 1)
        }
    }
    
    func addResult() {
        let dateTime = Date()
        ranking.name = name
        ranking.kind = kindValue.rawValue
        ranking.result = result
        ranking.date = dateTime
        Client.add(object: ranking)
        print("種類：" + String(kindValue.rawValue))
    }
    
    func setup(name: String, kindValue: Int) {
        self.name = name
        self.kindValue = kind(rawValue: kindValue)!
    }
    
    enum kind: Int {
        case one = 1
        case two = 2
        case three = 3
    }
    
    func timer(end: Decimal, kindNum: Int) {
        if kindNum == 1 {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] _ in
                self.countDownTimer -= Decimal(0.1)
                //文字列に置き換える
                self.countDownString = "\(countDownTimer)"
                
                print(self.countDownTimer)
                if self.countDownTimer == end {
                    self.timer!.invalidate()
                    self.countDownTimer = Decimal(3.0)
                    withAnimation {
                        self.isCountDownTimer = false
                        print("終わり")
                    }
                    self.timer = nil
                }
            }
        } else if kindNum == 2 {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.countTimer += Decimal(0.1)
                
                print(self.countTimer)
                
                if self.countTimer >= end {
                    self.timer!.invalidate()
                    self.countTimer = Decimal(0.0)
                    self.result = Double(Int(self.count * 10)) / Double(10.0)
                    print(self.result)
                    self.count = 0.0
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
                    withAnimation {
                        self.isStop = true
                    }
                    self.timer = nil
                }
            }
        }
        
    }
}

