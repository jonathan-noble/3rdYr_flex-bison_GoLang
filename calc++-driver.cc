#include "calc++-driver.hh"
#include "calc++-parser.hh"

calcxx_driver::calcxx_driver ()
  : trace_scanning (false), trace_parsing (false)
{
}

calcxx_driver::~calcxx_driver ()
{
}

int
calcxx_driver::parse (const std::string &f)
{
  file = f;
  scan_begin ();
  yy::calcxx_parser parser (*this);
  parser.set_debug_level (trace_parsing);
  int res = parser.parse ();
  scan_end ();
  return res;
}

void
calcxx_driver::error (const yy::location& l, const std::string& m)
{
  std::cerr << l << ": " << m << std::endl;
}

void
calcxx_driver::error (const std::string& m)
{
  std::cerr << m << std::endl;
}


/* createNode function similar to the first lab which has three children(: left, middle, right) and contains a string value*/
ASTNode* calcxx_driver::createNode(TokenType type, ASTNode* left, ASTNode* middle, ASTNode* right, std::string value){
    ASTNode* node = new ASTNode;
    node->type = type;
    node->left = left;
    node->middle = middle;
    node->right = right;
    node->value = value;

    return node;
}

// ASTNode Constructor
ASTNode::ASTNode(){
  left= NULL;
  right= NULL;
  middle= NULL;
}
