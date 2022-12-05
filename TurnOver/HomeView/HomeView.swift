//
//  HomeView.swift
//  TurnOver
//
//  Created by cmStudent on 2022/12/05.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("ひっくり返せ")
                .font(.system(size: 40, weight: .black, design: .default))
            
            Spacer()
            
            Group {
                Text("ランキング")
                    .font(.title)
                    .fontWeight(.black)
                ScrollView {
                    
                    
                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 15 * 1)
                            .foregroundColor(.black)
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    viewModel.switchKind = .one
                                    viewModel.lode(kind: viewModel.switchKind.rawValue)
                                }
                            } label: {
                                Text("5秒")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width / 7)
                                
                            }
                            Spacer()
                            Button {
                                withAnimation {
                                    viewModel.switchKind = .two
                                    viewModel.lode(kind: viewModel.switchKind.rawValue)
                                }
                            } label: {
                                Text("10秒")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width / 7)
                                
                            }
                            Spacer()
                            Button {
                                withAnimation {
                                    viewModel.switchKind = .three
                                    viewModel.lode(kind: viewModel.switchKind.rawValue)
                                }
                            } label: {
                                Text("20秒")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width / 7)
                                
                            }
                            Spacer()
                        }
                        .padding(.bottom)
                        
                        VStack {
                            Spacer()
                                .frame(height: UIScreen.main.bounds.height / 50)
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.height / 80)
                                .cornerRadius(30)
                                .foregroundColor(.white)
                                .offset(x: viewModel.switchKind == .one ? -UIScreen.main.bounds.width / 3.5  : viewModel.switchKind == .two ? 0 : UIScreen.main.bounds.width / 3.5 , y: 0)
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 15 * 2)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 15 * 2)
                    
                    VStack {
                        ForEach(0 ..< viewModel.rankings.count, id: \.self) { num in
                            if num < 5 {
                                RankingItemView(rankingNumber: String(viewModel.rankingNumber[num]) + "位",
                                                date: viewModel.stringFromDate(date: viewModel.rankings[num].date, format: "yyyy-MM-dd HH:mm:ss +0000") ,
                                                name: viewModel.rankings[num].name,
                                                resultNumber: String(viewModel.rankings[num].result) + "回")
                            } else {
                                if viewModel.isRanking {
                                    RankingItemView(rankingNumber: String(viewModel.rankingNumber[num]) + "位",
                                                    date: viewModel.stringFromDate(date: viewModel.rankings[num].date, format: "yyyy-MM-dd HH:mm:ss +0000") ,
                                                    name: viewModel.rankings[num].name,
                                                    resultNumber: String(viewModel.rankings[num].result) + "回")
                                }
                            }
                        }
                        .onAppear {
                            viewModel.lode(kind: viewModel.switchKind.rawValue)
                        }
                        if viewModel.rankings.count > 5 {
                            if viewModel.isRanking {
                                Button {
                                    withAnimation {
                                        viewModel.isRanking = false
                                    }
                                } label: {
                                    Text("閉じる")
                                }
                            } else {
                                Button {
                                    withAnimation {
                                        viewModel.isRanking = true
                                    }
                                } label: {
                                    Text("もっと見る")
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                .frame(width: CGFloat(UIScreen.main.bounds.width / 13 * 12), height: CGFloat(UIScreen.main.bounds.height / 2))
            }
            
            Spacer()
            Button(action: {
                withAnimation {
                    viewModel.isSetting = true
                }
            }) {
                Text("次へ")
                    .font(.system(size: 12, weight: .black, design: .default))
                    .frame(width: 160, height: 48)
                    .foregroundColor(Color(.white))
                    .background(Color.black)
                    .cornerRadius(24)
            }
            
            .padding()
            .fullScreenCover(isPresented: $viewModel.isSetting, onDismiss: {
                viewModel.name = ""
                viewModel.kindValue = .one
                viewModel.lode(kind: viewModel.switchKind.rawValue)
            }) {
                SettingView(viewModel: viewModel)
            }
            Spacer()
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
