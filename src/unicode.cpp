#include <Rcpp.h>
#include <string>
#include <iostream>
#include <vector>
#include <fstream>
// [[Rcpp::depends(RcppProgress)]]
#include <progress.hpp>

using namespace Rcpp;
using namespace std;

const size_t CN_WORD_START = 0x2627;

unsigned char const header_scel[] = {0x40, 0x15, 0x00, 0x00, 0x44, 0x43, 0x53, 0x01, 0x01,
              0x00, 0x00, 0x00};

unsigned char* copy_next_nbytes(size_t n,size_t begin, unsigned char *ret){
  unsigned char *res = new unsigned char[n];
  for (size_t i = 0; i < n; i++) {
    //Rprintf("0x%.2x ",ret[i+begin]);
    res[i] = ret[i+begin];
  }
  return res;
}

unsigned int byte2ToInt(unsigned char* bytes)
{
  //Rprintf("0x%.2x ",bytes[0]);
  //Rprintf("0x%.2x ",(bytes[1]));
  unsigned int  addr = (bytes[1] |( (unsigned int)(bytes[0]) << 8));
  return addr;
}


unsigned int get_double(size_t begin, unsigned char *ret){
  auto two_bit = copy_next_nbytes(2,begin,ret);
  unsigned int two_value = byte2ToInt(two_bit);
  delete [] two_bit;
  return two_value;
}


unsigned int get_one(size_t begin, unsigned char *ret){
  auto one_bit = copy_next_nbytes(1,begin,ret);
  unsigned int one_value;
  memcpy( &one_value , one_bit, 2 );
  delete [] one_bit;
  return one_value;
}


// [[Rcpp::export]]
RawVector decode_scel_cpp(CharacterVector file, CharacterVector output,NumericVector freq, bool disp) {
  const char *const name = file[0];
  ifstream fl(name);
  fl.seekg( 0, ios::end );
  size_t len = fl.tellg();
  unsigned char *ret = new unsigned char[len];
  fl.seekg(0, ios::beg);
  fl.read((char *)ret, len);
fl.close();
  vector<Rbyte> res;
  res.reserve(1000000);
  auto header_byte = copy_next_nbytes(12,0,ret);
  for(size_t ni=0;ni<12;ni++){
    //Rprintf( "%.2x",header_byte[ni] );
    if(header_byte[ni]!= header_scel[ni]){
      stop("not a valid .scel file?");
    }
  }
  delete [] header_byte;

  size_t begin = CN_WORD_START+1;
  Progress p(len,disp);
  p.update(begin);

  unsigned int samePinyinCount;
  unsigned int pyIndexBytesLength;
  unsigned int cnWordLength;
  while(begin<len-1){
    p.update(begin);
    samePinyinCount = get_double(begin-1,ret);
    //Rprintf("%d ss",samePinyinCount );
    //pyIndexBytesLength =ret[begin+2];
    pyIndexBytesLength =get_double(begin+1,ret);

    //Rprintf("%d py",pyIndexBytesLength );
    begin = begin + 4 + pyIndexBytesLength;
    for(size_t nj=1;nj<=samePinyinCount;nj++){
      cnWordLength = ret[begin];
      for(size_t j=1;j<=cnWordLength;j++){
        res.push_back(ret[begin+ 1+j]);
        }
      res.push_back(0x0a);
      res.push_back(0x00);
      begin = begin + 2 + cnWordLength + 12;
    }
  }
  delete [] ret;
  return wrap(res);
}
