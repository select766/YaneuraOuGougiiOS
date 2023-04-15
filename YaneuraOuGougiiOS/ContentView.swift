//
//  ContentView.swift
//  YaneuraOuGougiiOS
//
//  Created by Masatoshi Hidaka on 2022/10/19.
//

import SwiftUI
import YaneuraOuGougiiOSSPM

let userDefaultsUSIServerIpAddressKey = "usiServerIpAddress"

func stringToUnsafeMutableBufferPointer(_ s: String) -> UnsafeMutableBufferPointer<Int8> {
    let count = s.utf8CString.count
    let result: UnsafeMutableBufferPointer<Int8> = UnsafeMutableBufferPointer<Int8>.allocate(capacity: count)
    _ = result.initialize(from: s.utf8CString)
    return result
}

struct ContentView: View {
    @State private var usiHost: String = UserDefaults.standard.string(forKey: userDefaultsUSIServerIpAddressKey) ?? "127.0.0.1"
    @State private var connectionStatus = "接続先を設定してRunをタップ"
    @State private var running = false

    var body: some View {
        VStack {
            Text("YaneuraOu iOS (DEEP+NNUE)")
            Text("DEEP: port 8090, NNUE: port 8091")
            Text("将棋所の設定でDNN_Model1を空にする必要あり")
            Text(connectionStatus)
            HStack {
                Text("USI Host IP:")
                TextField("", text: $usiHost)
            }.padding()
            Button(action: {
                if self.running {
                    self.connectionStatus = "再接続はできません。アプリを再起動してください。"
                    return
                }
                self.running = true
                UserDefaults.standard.set(usiHost, forKey: userDefaultsUSIServerIpAddressKey)
                guard let nnue_eval_path = Bundle.main.path(forResource: "nn", ofType: "bin") else {
                    fatalError()
                }
                let nnue_eval_path_p = stringToUnsafeMutableBufferPointer(nnue_eval_path)
                let host_p = stringToUnsafeMutableBufferPointer(usiHost)
                print(DlShogiResnet.urlOfModelInThisBundle.absoluteString)
                let model_url_p = stringToUnsafeMutableBufferPointer(DlShogiResnet.urlOfModelInThisBundle.absoluteString)
                let compute_units: Int32 = 2 // 0:cpu, 1: cpuandgpu, 2: all (neural engine)
                let mainResult = YaneuraOuGougiiOSSPM.yaneuraou_ios_main(host_p.baseAddress!, 8090, model_url_p.baseAddress!, compute_units, host_p.baseAddress!, 8091, nnue_eval_path_p.baseAddress!)
                print("yaneuraou_ios_main", mainResult)
                var st = ""
                if mainResult & (1 << 0) != 0 {
                    st += "DEEP: OK"
                } else {
                    st += "DEEP: failed"
                }
                st += ", "
                if mainResult & (1 << 1) != 0 {
                    st += "NNUE: OK"
                } else {
                    st += "NNUE: failed"
                }
                self.connectionStatus = st
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
