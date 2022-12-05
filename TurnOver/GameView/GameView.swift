//
//  GameView.swift
//  TurnOver
//
//  Created by cmStudent on 2022/12/05.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var viewModel = GameViewModel()
    @Environment(\.dismiss) var dismiss
    
    init(name: String, kind: Int) {
        viewModel.setup(name: name, kindValue: kind)
        viewModel.startCountDownTimer()
    }
    
    var body: some View {
        if viewModel.isStop {
            VStack {
                Spacer()
                Text(viewModel.name + "さんの結果")
                    .font(.system(size: 30, weight: .black, design: .default))
                    .frame(alignment: .leading)
                Spacer()
                Text("結果：" + String(viewModel.result) + "回")
                    .font(.system(size: 50, weight: .black, design: .default))
                    .frame(alignment: .leading)
                Spacer()
                Button {
                    withAnimation {
                        dismiss()
                    }
                    
                } label: {
                    Text("スタート画面へ")
                }
                .frame(width: 160, height: 48)
                .foregroundColor(Color(.white))
                .background(Color.black)
                .cornerRadius(24)
                .padding()
                Spacer()
            }
            .onAppear {
                viewModel.addResult()
            }
            
        } else {
            if viewModel.isCountDownTimer {
                VStack {
                    Text("カウントダウン")
                        .font(.system(size: 30, weight: .black, design: .default))
                        .frame(alignment: .leading)
                    Text(viewModel.countDownString)
                        .font(.system(size: 30, weight: .black, design: .default))
                        .frame(alignment: .leading)
                }
                .onAppear {

                }
            } else {
                VStack {
                    Text("時間：" + "\(viewModel.countTimer)秒")
                        .font(.system(size: 30, weight: .black, design: .default))
                        .frame(alignment: .leading)
                    Text("回数：" + "\(viewModel.count)回")
                        .font(.system(size: 30, weight: .black, design: .default))
                        .frame(alignment: .leading)
                }
                .onAppear {
                    viewModel.lode()
                }
            }
        }
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(name: "condor", kind: 1)
    }
}
