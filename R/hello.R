
FILE_ENCODING = "UTF-16LE";
PY_START = 0x1540 +1 ;
CN_WORD_START = 0x2628;
NAME_START = 0x130 +1 ;
NAME_END = 0x338 +1 ;
CATEGORY_START = 0x338 +1 ;
CATEGORY_END = 0x540 +1 ;
DESCRIPTION_START = 0x540 +1 ;
DESCRIPTION_END = 0xd40 +1 ;
EXAMPLE_START = 0xd40 +1 ;
EXAMPLE_END = PY_START;

scel_header = as.raw(c(0x40, 0x15, 0x00, 0x00, 0x44, 0x43, 0x53, 0x01, 0x01,
                       0x00, 0x00, 0x00))

into_int2 = function(text,offset){
  as.numeric(paste("0x",paste(text$text[c(offset,offset+1)],collapse = ""),sep = ""))
}

into_int1 = function(text,offset){
  as.numeric(paste("0x",paste(text$text[c(offset)],collapse = ""),sep = ""))
}

#' Decode SCEL files
#'
#' This function can decode SCEL file into jiebaR dictionaries
#' @param scel SCEL file path
#' @param output output path
#' @param tag default tag
#' @param cpp use Rcpp
#' @param progress TRUE
#' @examples
#' \dontrun{
#' decode_scel(scel = "test.scel",output = "test.dict",tag = 1)
#' }
#' @export
decode_scel = function(scel,output=NULL,tag="n",cpp=T,progress=F){

  info_file = file.info(scel)
  if(!file.exists(scel)){
    stop("no such files.")
  }
  if(is.null(output)){
    basenames <- gsub("\\.[^\\.]*$", "", scel[1])
    extnames  <- gsub(basenames, "", scel[1], fixed = TRUE)
    times_char = gsub(" |:","_",as.character(Sys.time()))
    output    <- paste(basenames, extnames,"_",times_char ,".dict", sep = "")
  }

  if(cpp==T){

    temp_res = decode_scel_cpp(scel,output,tag,progress)
    temp_res = stri_split_fixed(stri_encode(temp_res,from = FILE_ENCODING,to = "UTF-8"),"\n")[[1]]
    temp_res = paste(paste(temp_res[!(temp_res=="")],tag),collapse ="\n")
    output.w <- file(output, open = "ab", encoding = "UTF-8")
    tryCatch({
      writeBin(charToRaw(temp_res), output.w)
      writeBin(charToRaw("\n"), output.w)
    },
    finally = {
      try(close(output.w))
    }
    )


    # end cpp part
  } else {
  # R part

  # teee[c(CN_WORD_START,CN_WORD_START+1)]
  teee = new.env(parent = emptyenv())
  teee$text = readBin(scel,"raw",n = info_file$size)

  if(!all(teee$text[1:12] == scel_header)){
    stop("not a valid .scel file?")
  }

  temp_res = character(length = 10^7)
  base_index = 0
  index_res = 1
  teee_length = length(teee$text)
  now_index = CN_WORD_START
  if(progress ==T){
    if (.Platform$OS.type == "windows") {
      pboptions(type="win",title="Decoding...")
    } else{
      pboptions(type="txt",title="Decoding...")
    }
    pb <- startpb(0, teee_length)
  }
  while(now_index<teee_length ){
    if(progress ==T){
      setpb(pb, now_index)
    }
    samePinyinCount = into_int2(teee,now_index)
    pyIndexBytesLength = into_int2(teee,now_index+2)
    now_index = now_index+4 +pyIndexBytesLength
    for( i in 1:samePinyinCount ){

      cnWordLength = into_int1(teee,now_index+1)
      if(index_res>10^7){
        temp_res = c(temp_res,character(length = 10^7))
        index_res = 1
        base_index = base_index+10^7
      }
      temp_res[base_index+index_res] = stri_encode(teee$text[(now_index+2+1):(now_index+2+cnWordLength)],from = FILE_ENCODING,to = "UTF-8")
      index_res = index_res + 1
      now_index = now_index+2+cnWordLength+12

    }

  }
  temp_res = paste(paste(temp_res[!(temp_res=="")],tag),collapse ="\n")
  if(progress ==T){
    closepb(pb)
  }
  output.w <- file(output, open = "ab", encoding = "UTF-8")
  tryCatch({
    writeBin(charToRaw(temp_res), output.w)
    writeBin(charToRaw("\n"), output.w)
  },
  finally = {
    try(close(output.w))
  }
  )
  # end R part
  }
  message(paste("output file:",output))

}
