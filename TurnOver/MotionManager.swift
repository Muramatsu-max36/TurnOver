//
//  MotionManager.swift
//  TurnOver
//
//  Created by cmStudent on 2022/12/05.
//

import Foundation
import CoreMotion

final class MotionManager {
    // staticでインスタンスを保持しておく
    // MotionManager.shardでアクセスができる
    static let shared: MotionManager = .init()
    // privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    
    private let queue = OperationQueue()
    
    private var taple : (x: Double, y: Double, z: Double) = (0.0, 0.0, 0.0)
    // シングルトンにするためにinitを潰す
    private init() {}
    
    func startQueuedUpdates() {
        // ジャイロセンサーが使えない場合はこの先の処理をしない
        guard motion.isGyroAvailable else { return }
        
        // 更新間隔 0.1秒間隔
        motion.gyroUpdateInterval = 6.0 / 60.0
        
        // ジャイロセンサーを利用して値を取得する
        // とってくるdataの型はCMGyroData?になっている
        motion.startGyroUpdates(to: queue) { data, error in
            // dataはオプショナル型なので、安全に取り出す
            if let validData = data {
//                let x = validData.rotationRate.x
//                let y = validData.rotationRate.y
//                let z = validData.rotationRate.z
                self.taple = (validData.rotationRate.x, validData.rotationRate.y, validData.rotationRate.z)
                
                print(self.taple)
            }
        }
    }
    
}
