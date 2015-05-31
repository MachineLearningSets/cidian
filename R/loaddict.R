#' LoadDIctionaries
#'
#' This function can load jiebaR dictionaries
#' @param filePath SCEL file path
#' @param defaultWeight output path
#' @param defaultTag default frequency
#' @examples
#' \dontrun{
#' test = loaddict("yy.dict",1,"tag")
#' }
#' @export
loaddict = function(filePath, defaultWeight, defaultTag){
  tes = loadUserDict(filePath, defaultWeight, defaultTag)
  if(.Platform$OS.type=="windows"){
    Encoding(names(tes)) = "UTF-8"
  }
  tes
}

#' Add or remove words from list
#'
#' add or remove words from list
#' @param dict a list
#' @param words words to add or remove
#' @param tags POS tags
#' @examples
#' \dontrun{
#' remove_user_words(dict,words)
#' }
#' @export
remove_user_words = function(dict,words){
  for(wod in words){
    dict[[wod]] = NULL
  }
  return(dict)
}

#' @rdname remove_words
#' @export
add_user_words = function(dict,words,tags){
  if(length(words)!=length(tags)){
    stop("no freqs for words")
  }
  for(wod in 1:length(words)){
    dict[[words[wod]]] = as.character(tags[wod])
  }
  return(dict)
}
