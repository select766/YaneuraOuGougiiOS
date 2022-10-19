//
//  ContentView.swift
//  FukauraOuiOS
//
//  Created by Masatoshi Hidaka on 2022/10/19.
//

import SwiftUI
import YaneuraOuiOSSPM

func stringToUnsafeMutableBufferPointer(_ s: String) -> UnsafeMutableBufferPointer<Int8> {
    let count = s.utf8CString.count
    let result: UnsafeMutableBufferPointer<Int8> = UnsafeMutableBufferPointer<Int8>.allocate(capacity: count)
    _ = result.initialize(from: s.utf8CString)
    return result
}

struct ContentView: View {
    @State private var usiHost = "127.0.0.1"
    var body: some View {
        VStack {
            Text("FukauraOu iOS")
            Text("将棋所の設定でDNN_Model1を空にする必要あり")
            HStack {
                Text("USI Host IP:")
                TextField("", text: $usiHost)
            }.padding()
            Button(action: {
                let host_p = stringToUnsafeMutableBufferPointer(usiHost)
                print(DlShogiResnet.urlOfModelInThisBundle.absoluteString)
                let model_url_p = stringToUnsafeMutableBufferPointer(DlShogiResnet.urlOfModelInThisBundle.absoluteString)
                print("yaneuraou_ios_main", YaneuraOuiOSSPM.yaneuraou_ios_main(host_p.baseAddress!, 8090, model_url_p.baseAddress!))
            }) {
                Text("Run")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
