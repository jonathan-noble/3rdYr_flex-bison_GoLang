//
//
//
// Here you need to change the file on the line 20 to the name of the file you are going to use as input.
//
//
//
//
//
//
#include <iostream>
#include "calc++-driver.hh"


int
main (int argc, char *argv[])
{
  int res = 0;
  calcxx_driver driver;
  driver.parse("hello.go");


  for (int i = 1; i < argc; ++i)
    if (argv[i] == std::string ("-p"))
      driver.trace_parsing = true;
    else if (argv[i] == std::string ("-s"))
      driver.trace_scanning = true;
    else
      res = 1;
  return res;
}

