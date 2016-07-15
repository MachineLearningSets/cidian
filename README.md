# cidian

分词词典工具

Linux & Mac: [![Build Status](https://travis-ci.org/qinwf/cidian.svg?branch=master)](https://travis-ci.org/qinwf/cidian)　Win : [![Build status](https://ci.appveyor.com/api/projects/status/d1omhpb0tc165bu0/branch/master?svg=true)](https://ci.appveyor.com/project/qinwf/cidian/branch/master)



## 安装

```r
install.packages("devtools")
install.packages("stringi")
install.packages("pbapply")
install.packages("Rcpp")
install.packages("RcppProgress")
library(devtools)
install_github("qinwf/cidian")
```

## 使用

```r
decode_scel(scel = "细胞词库路径",output = "输出文件路径",cpp = TRUE)

decode_scel(scel = "细胞词库路径",output = "输出文件路径",cpp = FALSE,progress =TRUE)
```

## 

```r

```
