### clustering example code for lecture

#### 階層的クラスター分析サンプルコード
### Rプログラミングでわからないことは大概Google先生で[R 日本語 pdf plot]みたいなノリで調べれば分かる。

### 同じディレクトリ内に保存しているCSVファイル形式のデータセットを読み込む.
### 注意：ダウンロードしたファイルはmacOSではデフォルトで ~/Downloads 以下に保存される．
### 1列目のデータを行名としてデータを読み込む
dataset <- read.csv("./youtuber.csv",row.names=1)

### datasetがどのようなものか確認
dataset

### データ間の距離を定義する。(以下の3つから任意の距離を選択する)
data_dist_method <- "euclidean"     #ユークリッド距離
data_dist_method <- "manhattan"     #マンハッタン距離
data_dist_method <- "maximum"       #最大距離

### 全データ間の距離をdata_dist_methodの距離定義に基づいて計算する（距離行列を求める）
distance_matrix <- dist(dataset, method=data_dist_method)

### 距離行列の確認
as.matrix(distance_matrix)[1:6,1:6]

### クラスター間の距離の計算方法を決める。(以下の3つから任意の距離を選択する)
cluster_dist_method <- "average"   #群平均法
cluster_dist_method <- "single"    #最小距離法
cluster_dist_method <- "complete"  #最大距離法

### データの正規化を行うか決定する
is_scale <- T #T=正規化を行う; F=正規化を行わない
### is_scale=Tならばデータの正規化を行う
if(is_scale==T) dataset <- scale(dataset)

### datasetの確認
head(dataset)

### 距離行列からcluster_dist_methodで定義したクラスター距離定義に基づいてクラスター分析を行う
cl_result <- hclust(distance_matrix, method=cluster_dist_method)

### クラスター分析結果の系統樹を出力する
plot(cl_result, hang=-1, main=sprintf("Cluster Dendrogram (DataDist:%s,ClusterDist:%s)",data_dist_method,cluster_dist_method))


### 出力結果の保存(作業ディレクトリに保存されるように設定)
pdf(sprintf("./cl_scale_%s_dtdis_%s_cldis_%s.pdf",is_scale,data_dist_method,cluster_dist_method), paper="a4r", width=10, height=8)
plot(cl_result, hang=-1, main=sprintf("Cluster Dendrogram (DataDist:%s,ClusterDist:%s)",data_dist_method,cluster_dist_method))
dev.off()

### 距離行列の保存
write.csv(as.matrix(distance_matrix), file=sprintf("./distance_matrix_scale_%s_%s.csv",is_scale, data_dist_method))
