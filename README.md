# cidian

分词词典工具

Linux : [![Build Status](https://travis-ci.org/qinwf/jiebaR.svg?branch=master)](https://travis-ci.org/qinwf/jiebaR)　Mac : [![Build Status](https://travis-ci.org/qinwf/jiebaR.svg?branch=osx)](https://travis-ci.org/qinwf/jiebaR)　Win : [![Build status](https://ci.appveyor.com/api/projects/status/k8swxpkue1caiiwi/branch/master?svg=true)](https://ci.appveyor.com/project/qinwf53234/jiebar/branch/master)

## 安装

```r
install.packages("devtools")
install.packages("stringi")
install.packages("pbapply")
library(devtools)
install_github("qinwf/cidian")
```

## 使用

```r
decode_scel("细胞词库路径","输出文件路径")
```
