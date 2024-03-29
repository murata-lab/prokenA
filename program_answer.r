## ---------------------------------------------------------------
## このプログラムで使う関数
## ---------------------------------------------------------------

## --------------------------------------
### ２つの配列間の距離を動的計画法により計算する関数DPを作成する
##
##  strsplit()について
##    strsplit()は文字列を入れると，文字列を分割して，
##    リストという形で返してくれる関数です．
##    strsplit(文字列の変数,分割したい文字)でつかうことができる．
##    リストの一要素目に分割結果が入っている場合はstrsplit()[[1]]という形
##    で取り出す．
##    例えば，strsplit("あいうえお","う")という風に入力すると,
##  「"あい","えお"」というふうに返す．
##    strsplit("あいうえお","")のように分割する文字に何も指定しないと,
##   「"あ","い","う","え","お"」というふうに返す．
## --------------------------------------

# 引数string1とstring2には計算する二つの文字列を代入する
DP <- function(string1,string2,S){
    # 文字列１を一つずつバラバラにする作業
    string1 <- strsplit(string1,"")[[1]]
    # 文字列２を同様にバラバラにする
    string2 <- strsplit(string2,"")[[1]]
    # 文字列１の長さをn1に格納
    n1 <- length(string1)
    # 文字列２の長さをn2に格納
    n2 <- length(string2)
    # 各格子点におけるコスト(距離)を代入する行列C
    C <- matrix(0,n1+1,n2+1)
    gap <- 1

    ### ↓↓ ここに動的計画法のアルゴリズムをプログラムすること ↓↓ ###

    for(i in 2:(n1+1)){
        for(j in 2:(n2+1)){
            C[i,1] <- i-1
            C[1,j] <- j-1

            #文字列１のi番目と文字列２のj番目とを比較した時の減点
            penalty <- S[string1[i-1],string2[j-1]]

            C[i,j] <- min(C[i-1,j-1]+penalty,C[i-1,j]+gap,C[i,j-1]+gap)
        }
    }

    ### ↑↑ ################################################## ↑↑ ###

    #ヒント
    #点数をいれていく操作．経路が端まで達したらGAPを角にたどり着くまで足していく.
    #端の点数を埋めたら、経路が上・左・左上から来たとしたとき，
    #点数最小となるものを選んで減点の合計を示す行列にいれていけば良い(min関数)

    # パスを通過した時の減点の合計が最小になった経路の減点を「dist」，行列Cを「C」と名前をつけて返す．
    return(list('dist'=C[n1+1,n2+1],'C'=C))
}
## --------------------------------------



## --------------------------------------
## データ群における全ての組合せの距離を計算する関数（変更しなくてよい）###
## この関数の説明
## --------------------------------------
distmatrix <- function(Data,S){
   # データ行列の行数を数えて，データ数を調べる．
    n <- nrow(Data)
   # 各データ同士の距離を格納する関数
    distm <- matrix(0,n,n)
    for(i in 2:n){
        for(j in 1:(i-1)){
            # ここで自分で作成したDP関数が使われる．
            distm[i,j] <- DP(Data[i,1],Data[j,1],S)[["dist"]]
            # 作成した関数DPはデータ一組ごとに距離を計算していくので，
            #iとjを変化させながら全ての組み合わせについて計算するようにfor文を回す．
        }
    }
    return(distm)
}
## --------------------------------------


## ///////////////////////////////////////////////////////////////

## ---------------------------------------------------------------
## メイン関数()
##　C言語のmain関数と同じような役割．上で作成した関数をここで呼び出して計算を行う．
##  自分の用意したデータで計算行うときはis_debugをFALSEにする．
## read.csv()について
##  read.csv()はcsvファイルを読み込む関数．
##  read.csv(○○.csv,row.names=1,header=F)と使うとcsvの中身の値を返す．
##  row.names=1は一列目の値を各行の名前にする設定，
##  header=Fはcsvファイルの一行目を列の名前にはしないという設定．
## ---------------------------------------------------------------

#DP関数の中身を書き込んで，自分の書いた物があってるか確かめる時はTRUE．
#課題で自分の用意したデータを使うときはFALSE．

setwd("/cloud/project/practice")

is_debug <- FALSE

if(is_debug == TRUE){
    # デバッグで使うファイルを読み込む
    source('program_debug.r')
}else{
    #本番で使う文字列ファイルを読み込みオブジェクトDataに格納
    #データフレーム型で読み込まれているのでmatrix型に変換する
    Data <- as.matrix(read.csv('honban_data.csv', row.names = 1, header = F))
    # 本番で使う減点行列を読み込む
    S    <- read.csv("honban_penalty.csv",row.names=1)

    ### 作成した関数をDataに用いて計算する ###

    #各文字列データ間の距離を計算する
    dist_mat <- distmatrix(Data,S)
    #もともと文字列データにそれぞれついていた名前を距離行列にも付ける
    rownames(dist_mat) <- rownames(Data)
    #系統樹を書く関数hclustに計算した距離行列を代入する．
    #method=はクラスタリングの際に使う方法（最長，最短距離法など）を選択することができるので,
    #データの性質に応じて変えること！！．
    #hclustはdist型という変数しか受け入れないので，
    #距離行列をas.dist()という関数を用いてdist型に変換する.
    #plot() で作成した系統樹を描画する．
    plot(hclust(as.dist(dist_mat),method='average'))
}
## ///////////////////////////////////////////////////////////////
