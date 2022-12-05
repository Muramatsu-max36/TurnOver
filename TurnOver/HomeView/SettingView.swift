//
//  SettingView.swift
//  TurnOver
//
//  Created by cmStudent on 2022/12/05.
//

import SwiftUI

struct SettingView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("設定")
                .font(.system(size: 25, weight: .black, design: .default))
            
            Group {
                Spacer()
                
                if !viewModel.name.isEmpty {
                    Text("こんにちは！ " + viewModel.name + "さん")
                        .font(.system(size: 20, weight: .black, design: .default))
                }
                TextField("名前を入力してください", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
                Text(viewModel.switchKindValue())
                    .font(.system(size: 20, weight: .black, design: .default))
                Picker(selection: $viewModel.kindValue, label: Text("秒数を選択")) {
                    Text("5秒").tag(HomeViewModel.kind.one)
                    Text("10秒").tag(HomeViewModel.kind.two)
                    Text("20秒").tag(HomeViewModel.kind.three)
                }
                .pickerStyle(WheelPickerStyle())
                Spacer()
            }
            
            Button {
                withAnimation {
                    viewModel.startBtn()
                }
            } label: {
                Text("スタート")
                    .font(.system(size: 12, weight: .black, design: .default))
                    .frame(width: 160, height: 48)
                    .foregroundColor(Color(.white))
                    .background(Color.black)
                    .cornerRadius(24)
            }
            .padding()

            Spacer()
        }
        .alert(isPresented: $viewModel.isShowAlert, content: {
            Alert(title: Text("名前を入力してください"))
        })
        .fullScreenCover(isPresented: $viewModel.isShowGameView, onDismiss: {
            withAnimation {
                dismiss()
            }
        }) {
            GameView(name: viewModel.name, kind: viewModel.kindValue.rawValue)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: HomeViewModel())
    }
}
