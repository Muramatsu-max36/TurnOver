//
//  HomeViewModel.swift
//  TurnOver
//
//  Created by cmStudent on 2022/12/05.
//

import Foundation

class HomeViewModel : ObservableObject {
    
    @Published var isShowGameView : Bool = false
    @Published var isShowAlert : Bool = false
    @Published var name = ""
    typealias Client = RealmClient<Ranking>
    @Published var rankings : [Ranking] = Client.kindFind(kind: 1)
    var rankingNumber : [Int] = []
    @Published var rankingIndex = 0
    @Published var isRanking = false
    @Published var kindValue: kind = .one
    @Published var isSetting = false
    @Published var switchKind: kind = .one
    init() {
        lode(kind: switchKind.rawValue)
        print(rankings)
    }
    
    func lode(kind: Int) {
        rankingIndex = 0
        
        rankingNumber = []
        self.rankings = Client.kindFind(kind: kind)
        for i in 0..<Client.index(kind: switchKind.rawValue) {
            rankingIndex += 1
            if i != 0 && rankings[i - 1].result == rankings[i].result {
                for n in 2...(i + 1) {
                    if !(((i - n) >= 0) && rankings[i - n].result == rankings[i].result) {
                        rankingIndex -= n - 1
                        rankingNumber.append(rankingIndex)
                        rankingIndex += n - 1
                        break
                    }
                }
            } else {
                rankingNumber.append(rankingIndex)
            }
        }
        print(rankingNumber)
    }
    
    func startBtn() {
        if name.isEmpty {
            isShowAlert = true
        } else {
            isShowGameView = true
        }
    }
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func switchKindValue() -> String {
        var second: String = "5.0秒"
        switch kindValue {
        case .one:
            second = "5.0秒"
        case .two:
            second = "10.0秒"
        case .three:
            second = "20.0秒"
        }
        return second
    }
    
    enum kind: Int {
        case one = 1
        case two = 2
        case three = 3
    }
}

