#include <Rcpp.h>
#include <string>
#include <iostream>
#include <vector>
#include <fstream>
#include "Limonp/StringUtil.hpp"
#include "Limonp/TransCode.hpp"

using namespace Rcpp;
using namespace std;
using namespace limonp;
using namespace cppjieba;

// [[Rcpp::export]]
List loadUserDict(std::string filePath, std::string defaultTag)
{

  //Environment env = new_env(Environment::empty_env());
  map<string, string> res;
  const char *const files_path = filePath.c_str();
  const char *const tagss = defaultTag.c_str();
  ifstream ifs(files_path);
  if (!(ifs))
  {
    stop("File Open Fail: no such files?");
  }
  string line;
  //DictUnit nodeInfo;
  vector<string> buf;
  size_t lineno;
  for (lineno = 0; getline(ifs, line); lineno++)
  {
    //Rprintf("%d ",lineno);
    buf.clear();
    Split(line, buf, " ");
    if (!(buf.size() >= 1))
    {
      continue;
    }
    res.insert(std::pair<string,string>(buf[0], (buf.size() == 2 ? buf[1] : tagss)));
  }
  List rt(res.size());
  CharacterVector vname(res.size());
  auto id = res.begin();
  for (auto it = 0; it!= rt.size(); it++,id++){
    CharacterVector dx(1);
    SET_STRING_ELT(vname, it, Rf_mkCharLenCE(id->first.c_str(),  strlen(id->first.c_str()) , CE_UTF8));

    SET_STRING_ELT(dx, 0, Rf_mkCharLenCE(id->second.c_str(),  strlen(id->second.c_str()) , CE_UTF8));
    rt[it] = dx;
  }
  rt.attr("names") = vname;
  return rt;
}

// [[Rcpp::export]]
List loadSysDict(const std::string &filePath)
{
  ifstream ifs(filePath.c_str());
  if (!(ifs))
  {
    stop("can not open file.");
  }
  string line;
  vector<string> buf;

  RCPP_UNORDERED_MAP<string, pair<float,string>> res;

  for (size_t lineno = 0 ; getline(ifs, line); lineno++)
  {
    Split(line, buf, " ");
    if (!(buf.size() == 3))
    {
      stringstream ss;
      ss << "only " << buf.size() << " column in line "<< lineno;
      Rcpp::warning( ss.str());
      continue;
    }

    res.insert(
      std::pair<string,pair<float,string> >(
          buf[0],
             pair<float,string>(atof(buf[1].c_str()), buf[2])
      )
      );
  }
  List rt(res.size());
  CharacterVector vname(res.size());
  auto id = res.begin();
  for (auto it = 0; it!= rt.size(); it++,id++){
    CharacterVector dx(1);
    SET_STRING_ELT(vname, it, Rf_mkCharLenCE(id->first.c_str(),  strlen(id->first.c_str()) , CE_UTF8));

    SET_STRING_ELT(dx, 0, Rf_mkCharLenCE(id->second.second.c_str(),  strlen(id->second.second.c_str()) , CE_UTF8));
    rt[it] = List::create(dx, id->second.first);
  }
  rt.attr("names") = vname;
  return rt;
}

// [[Rcpp::depends(RcppProgress)]]
#include <progress.hpp>


// [[Rcpp::export]]
CharacterVector gen_sys_character(List input, bool disp){
  CharacterVector res(input.size());
  vector<string> vname = input.attr("names");
  Progress p(input.size(),disp);
  p.update(0);
  for (auto it = 0; it != input.size(); it++){
    p.update(it);
    List ilist = as<List>(input[it]);
    stringstream ss;
    ss<< as<float>(ilist[1]);
    res[it] = vname[it] + " " + ss.str() + " " +  as<string>(ilist[0]);
  }
  return res;
}

// [[Rcpp::export]]
CharacterVector gen_user_character(List input, bool disp){
  CharacterVector res(input.size());
  vector<string> vname = input.attr("names");
  Progress p(input.size(),disp);
  p.update(0);
  for (auto it = 0; it != input.size(); it++){
    p.update(it);
    res[it] = vname[it] + " " +  as<string>(input[it]);
  }
  return res;
}
