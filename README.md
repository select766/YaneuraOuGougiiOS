#  ふかうら王 iOS移植サンプル

[ふかうら王](https://github.com/yaneurao/YaneuraOu)（やねうら王のDeep Learning系評価関数利用バージョン）をiOSで動作するよう移植したサンプルです。

# インストール

Xcodeでプロジェクトを開いてビルドし、端末にインストール。

Xcode 14.0.1, iOS 15.7, iPad 第9世代で動作確認。


# 実行方法
現在、GUI上に局面を表示する機能がありません。Mac等で将棋所を動作させ、TCP接続で連携する必要があります。仕組みの説明: https://select766.hatenablog.com/entry/2022/02/15/190100

## サーバスクリプトの設置(Mac側)

以下の内容のファイルを`listen.sh`として設置。

```
#!/bin/sh
nc -l 8090
```

`chmod +x listen.sh`

## 将棋所へ登録

将棋所のエンジン登録で、先ほど作成した`listen.sh`を登録する。`listen.sh`を開いてエンジン登録待ちにする。次に、アプリ上のUSI Host IPにMacのIPアドレスを入力。アプリ上のRunボタンをタップ。

※アプリの初回起動時にはネットワークアクセスを許可するか否かのダイアログが表示されるので、許可する必要がある。ただし、初回の接続は失敗してしまう。一度アプリを終了（ホームボタンダブルタップ＋アプリの画面を上にスワイプ）し、将棋所でも対局やエンジン登録を一度キャンセルし、接続をやり直す必要がある。

## エンジン設定

将棋所のエンジン設定ボタンをクリックしてから、登録時と同様にアプリから接続を行う。エンジン設定が終わったら一度アプリを終了する必要がある。

**現状、`DNN_Model1`を空欄にする設定が必要。**

# 将棋所で対局

対局時は、将棋所で対局開始してから、iOSアプリ側でMacのIPアドレスを入力して接続。floodgateでの連続対局も可能。

# モデルの変更

`DlShogiResnet.mlmodel`を別のモデルに置換する。dlshogi等で用いられるONNX形式ではなく、Apple独自のmlmodel形式が必要。作り方の参考: https://select766.hatenablog.com/entry/2022/01/29/190100

Githubリポジトリに含まれているモデルは5ブロック64チャンネルの小さいもの。他に使える学習済みモデルファイルは https://github.com/select766/FukauraOu-CoreML/releases/tag/coreml-sample-20220613 にある。

`nn.bin`は水匠5評価関数。 https://github.com/HiraokaTakuya/get_suisho5_nn/raw/master/suisho5_nn/nn.bin から取得した。
