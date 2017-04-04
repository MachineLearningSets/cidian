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
decode_scel(scel = "细胞词库路径", output = "输出文件路径", cpp =  TRUE)

decode_scel(scel = "细胞词库路径",output = "输出文件路径",cpp =  FALSE, progress = TRUE)

# 输出调试信息
decode_scel(scel = "细胞词库路径", output = "输出文件路径", cpp = FALSE, progress = TRUE, rdebug = TRUE)
```

## 读取词典和编辑词典文件

```r
## 读取用户词典

load_user_dict(filePath = "用户词典路径", default_tag = "默认标记")

## 读取系统词典
load_sys_dict(filePath = "系统词典路径")

## 增加用户词典词

add_user_words(dict = "load_user_dict 读取的词典", words = "UTF-8 编码文本向量", tags = "标记")

## 增加系统词典词

add_sys_words(dict = "load_sys_dict 读取的词典", words = "UTF-8 编码文本向量", freq = "词频", tags = "标记")

## 删除词典词

remove_words(dict = "load_user_dict 或 load_sys_dict 读取的词典", words = "UTF-8 编码文本向量")

## 写入

write_dict(dict = "load_user_dict 或 load_sys_dict 读取的词典", output = "输出路径")
```

```r
(userd = load_user_dict(jiebaR::USERPATH))

userd = add_user_words(userd, enc2utf8("测试"), "v")

write_dict(userd, jiebaR::USERPATH)

(userd = load_user_dict(jiebaR::USERPATH))
```

```r
userd = remove_words(userd, enc2utf8(c("测试","蓝翔")))

write_dict(userd, jiebaR::USERPATH)

(userd = load_user_dict(jiebaR::USERPATH))
```
