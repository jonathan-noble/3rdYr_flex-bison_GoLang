/***********************
 * Example of C++ in Bison (yacc)
 * Compare Bison Manual, Section 10.1.6 A Complete C++ Example
 * https://www.gnu.org/software/bison/manual/html_node/A-Complete-C_002b_002b-Example.html
 * The Makefile has been simplified radically, but otherwise
 * everything here comes from the Bison source code (see also).
 * (This comment added by Prof. R. C. Moore, fbi.h-da.de)
 *
 * This is the yacc (bison) file, i.e. grammar file.
 * See also calc++-scanner.ll for the lexical scanner
 * (flex input).
 *
 ***********************/

%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0.2"
%defines
%define parser_class_name {calcxx_parser}

%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires
{
# include <string>
class calcxx_driver;
class ASTNode;
}

// The parsing context.
%param { calcxx_driver& driver }

%locations
%initial-action
{
  // Initialize the initial location.
  @$.begin.filename = @$.end.filename = &driver.file;
};

%define parse.trace
%define parse.error verbose

%code
{
# include "calc++-driver.hh"
}

%define api.token.prefix {TOK_}
%token
  END  0  "end of file"
  LCURLY "{"
  RCURLY "}"
  LPAREN  "("
  RPAREN  ")"
  QUOTATIONMARK "\""

;

%token <std::string> IDENTIFIER "identifier"
%token <std::string> IMPORT "import"
%token <std::string> PACKAGE "package"
%token <std::string> MAIN "main"
%token <std::string> FUNCTION "func"

%type <ASTNode*> src
%type <ASTNode*> imports
%type <ASTNode*> list
%type <ASTNode*> fill

%printer { yyoutput << $$; } <*>;


// Start of the expression
%%
%start src;


// Rules declared below
src:
  PACKAGE MAIN     src {  driver.createNode( TokenType:: Package,   // creating a node which has 3 children and its value
										  	 	driver.createNode(TokenType:: Package, NULL, NULL, NULL, "package"),
											  	driver.createNode(TokenType:: Main, NULL, NULL, NULL, "main"),
											   	$3,          // only used for expression values placed depending on their position
											 	""); }
|  IMPORT imports  src {  driver.createNode( TokenType:: Import,
  										  	driver.createNode(TokenType:: Import, NULL, NULL, NULL, "import"),
  									  		$2,
  									  		$3,
  											""); }
| FUNCTION IDENTIFIER LPAREN RPAREN LCURLY fill RCURLY {  driver.createNode( TokenType:: Function,
													driver.createNode(TokenType:: Function, NULL, NULL, NULL,"func"),
													driver.createNode(TokenType:: String, NULL, NULL, NULL, $2),
													driver.createNode(TokenType:: Fill, NULL, $6, NULL, ""),
                          ""); }
|   END {}
;


imports:
  QUOTATIONMARK IDENTIFIER QUOTATIONMARK { $$ = driver.createNode(TokenType:: Import,
												 NULL,
												 driver.createNode(TokenType::String,NULL,NULL,NULL,$2),
												 NULL,
												 ""); }
| LPAREN list RPAREN { $$ = driver.createNode( TokenType::List,
  											NULL,
  											$2 ,
  											NULL,
  											""); }
;


list: {}
|  QUOTATIONMARK IDENTIFIER QUOTATIONMARK list { $$ = driver.createNode(TokenType:: List,
													 	driver.createNode( TokenType:: List,
								 						NULL,
								 						driver.createNode(TokenType::String, NULL, NULL, NULL, $2),
								 						NULL,
								 						""),
          								 	$4,
          								 	NULL,
          								 	""); }
;

fill:
	{driver.createNode(TokenType::Empty, NULL, NULL, NULL, "");}
;

%%


void
yy::calcxx_parser::error (const location_type& l,
                          const std::string& m)
{
  driver.error (l, m);
}
