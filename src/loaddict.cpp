#include <Rcpp.h>
#include <string>
#include <iostream>
#include <vector>
#include <fstream>
#include "Limonp/StringUtil.hpp"
using namespace Rcpp;
using namespace std;
using namespace Limonp;

// [[Rcpp::export]]
List loadUserDict(CharacterVector filePath, IntegerVector defaultWeight, CharacterVector defaultTag)
{

  //Environment env = new_env(Environment::empty_env());
  std::map<string, string> res;
  const char *const files_path = filePath[0];
  const char *const tagss = defaultTag[0];
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
    split(line, buf, " ");
    if (!(buf.size() >= 1))
    {
      continue;
    }

    //env.assign( buf[0], (buf.size() == 2 ? buf[1] : tagss) ) ;
    res.insert(std::pair<string,string>(buf[0], (buf.size() == 2 ? buf[1] : tagss)));
    //nodeInfo.weight = defaultWeight;
    //nodeInfo.tag = (buf.size() == 2 ? buf[1] : defaultTag);
    //_nodeInfos.push_back(nodeInfo);
  }
  // LogInfo("load userdict[%s] ok. lines[%u]", filePath.c_str(), lineno);
  return wrap(res);
}

// void _loadDict(const string &filePath)
// {
//   ifstream ifs(filePath.c_str());
//   if (!(ifs))
//   {
//     stop("File Open Fail  DictTrie.hpp : 180 (bad dictionary file)");
//   }
//   string line;
//   vector<string> buf;
//
//   DictUnit nodeInfo;
//   for (size_t lineno = 0 ; getline(ifs, line); lineno++)
//   {
//     split(line, buf, " ");
//     if (!(buf.size() == DICT_COLUMN_NUM))
//     {
//       Rcpp::Rcout << "Dict line: " << lineno << std::endl;
//       Rcpp::Rcout << "Word column: " << buf.size() << std::endl;
//       Rcpp::stop("buf.size() != DICT_COLUMN_NUM");
//     }
//     if (!TransCode::decode(buf[0], nodeInfo.word))
//     {
//       // LogError("line[%u:%s] illegal.", lineno, line.c_str());
//       continue;
//     }
//     nodeInfo.weight = atof(buf[1].c_str());
//     nodeInfo.tag = buf[2];
//
//     _nodeInfos.push_back(nodeInfo);
//   }
// }

