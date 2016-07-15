#' Load user dictionaries
#'
#' This function can load a jiebaR user dictionary, and then we can use remove_user_words() and add_user_words() to edit the dictionary.
#' @param filePath jiebaR dict path
#' @param default_tag default frequency
#' @examples
#' \dontrun{
#' test = load_user_dict(jiebaR::USERPATH)
#' }
#' @export
load_user_dict = function(filePath, default_tag= "n"){
  dict = loadUserDict(filePath, default_tag)
  class(dict) = "user_dict"
  dict
}

#' Add or remove words from list
#'
#' add or remove words from list
#' @param dict a list
#' @param words words to add or remove
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

#' Add or remove words from list
#'
#' add or remove words from list
#' @param dict a list
#' @param words words to add or remove
#' @param tags POS tags
#' @export
add_user_words = function(dict,words,tags){
  stopifnot(inherits(dict, "user_dict"))
  if(length(words)!=length(tags)){
    stop("no freqs for words")
  }
  for(wod in 1:length(words)){
    dict[[words[wod]]] = as.character(tags[wod])
  }
  dict
}


#' Load system dictionaries
#'
#' This function can load a jiebaR system dictionary, and then we can use remove_sys_words() and add_sys_words() to edit the dictionary.
#' @param filePath jiebaR dict path
#' @examples
#' \dontrun{
#' test = load_sys_dict(jiebaR::DICTPATH)
#' }
#' @export
load_sys_dict = function(filePath){
  dict  = loadSysDict(filePath)
  class(dict) = "sys_dict"
  dict
}

#' Add or remove words from list
#'
#' add or remove words from list
#' @param dict a list
#' @param words words to add or remove
#' @examples
#' \dontrun{
#' remove_user_words(dict,words)
#' }
#' @export
remove_sys_words = function(dict,words){
  for(wod in words){
    dict[[wod]] = NULL
  }
  return(dict)
}

#' Add or remove words from list
#'
#' Add or remove words from list
#' @param dict a list
#' @param words words to add or remove
#' @param freq frequencies for words
#' @param tags POS tags
#' @export
add_sys_words = function(dict,words,freq,tags){
  stopifnot(inherits(dict, "sys_dict"))
  if(length(words)!=length(tags) || length(freq)!=length(tags)){
    stop("no freqs for words")
  }
  for(wod in 1:length(words)){
    dict[[words[wod]]] = list(as.character(tags[wod]),as.numeric(freq[wod]))
  }
  return(dict)
}

#' Write the loaded dictionaries to a file
#'
#' @export
#' @param dict a list
#' @param output output path
#' @param cpp use cpp mode, FALSE will give better error message
#' @param cpp_progress use progress in cpp mode
#' @examples
#' \dontrun{
#' sysd = load_sys_dict(jiebaR::DICTPATH)
#' write_dict(sysd,"somepath")
#' }
write_dict = function(dict, output, cpp = TRUE, cpp_progress = TRUE){
  res = vector("character", length(dict))
  pb <- startpb(1, length(dict))
  on.exit(closepb(pb))
  if (inherits(dict,"sys_dict")){
    if (!cpp){
      for ( x in 1:length(dict) ){
        setpb(pb, x)
        if(is.na(dict[[x]][[2]]) || is.null(dict[[x]][[2]]) ||
           is.na(dict[[x]][[1]]) || is.null(dict[[x]][[1]]) ||
           is.na(names(dict[x])) || is.null(names(dict[x])) ){
          warning(paste("skip index", x," with NA or NULL."))
          next
        }
        res[x] = paste(names(dict[x]), as.character(dict[[x]][[2]]),dict[[x]][[1]], collapse = " ")
      }
    } else {
      res = gen_sys_character(dict,cpp_progress)
    }

    if (.Platform$OS.type == "windows"){
      writeLines(res, con = output,useBytes = T)
    }else {
      writeLines(res,con = output)
    }
  } else if (inherits(dict, "user_dict")){
    if(!cpp){
      for ( x in 1:length(dict) ){
        setpb(pb, x)
        if(
          is.na(dict[[x]]) || is.null(dict[[x]]) ||
          is.na(names(dict[x])) || is.null(names(dict[x])) ){
          warning(paste("skip index", x," with NA or NULL."))
          next
        }

        res[x] = paste(names(dict[x]), dict[[x]], collapse = " ")
      }
    } else{
      res = gen_user_character(dict,cpp_progress)
    }

    if (.Platform$OS.type == "windows"){
      writeLines(res, con = output,useBytes = T)
    }else {
      writeLines(res,con = output)
    }

  } else {
    stop("not a dictionary list.")
  }
  return(invisible(output))
}
