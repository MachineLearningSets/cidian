#' LoadDIctionaries
#'
#' This function can load jiebaR dictionaries
#' @param filePath SCEL file path
#' @param defaultWeight output path
#' @param defaultTag default frequency
#' @examples
#' \dontrun{
#' decode_scel(scel = "test.scel",output = "test.dict",freq = 1)
#' }
#' @export
loaddict = function(filePath, defaultWeight, defaultTag){
  tes = loadUserDict(filePath, defaultWeight, defaultTag)
  if(.Platform$OS.type=="windows"){
    Encoding(names(tes)) = "UTF-8"
  }
  tes
}

#' @export
remove_words = function(dict,words){
  for(wod in words){
    dict[[wod]] = NULL
  }
  return(dict)
}

#' @export
add_words = function(dict,words,freqs){
  if(length(words)!=length(freqs)){
    stop("no freqs for words")
  }
  for(wod in 1:length(words)){
    dict[[words[wod]]] = as.character(freq[i])
  }
  return(dict)
}
