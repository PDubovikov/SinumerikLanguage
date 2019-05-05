grammar Sinumerik;

parse
 : block EOF
 ;

block
 : ( statement | functionDecl)*
 ;

statement
 : assignment
// | coordinateStatement
 | gcodeStatement
 | functionCall
 | ifStatement
 | forStatement
 | whileStatement
 | ifGotostat
 | gotoStatement
 | metkaStart
 | crlfStatement
 ;

assignment
 : Identifier indexes? '=' expression
 | Def typeDef varlist indexes? '='? expression?
 ;

functionCall
 : Identifier '(' exprList? ')'             #identifierFunctionCall
 | Println '(' expression? ')'              #printlnFunctionCall
 | Print '(' expression ')'                 #printFunctionCall
 | Assert '(' expression ')'                #assertFunctionCall
 | Size '(' expression ')'                  #sizeFunctionCall
 | Sin '(' expression ')'                   #sinFunctionCall
 | Cos '(' expression ')'                   #cosFunctionCall
 | Tan '(' expression ')'                   #tanFunctionCall
 | ASin '(' expression ')'                  #asinFunctionCall
 | ACos '(' expression ')'                  #acosFunctionCall
 | ATan '(' expression ')'                  #atanFunctionCall
 | ATan2 '(' expression ',' expression ')'  #atan2FunctionCall
 | Sqrt '(' expression ')'                  #sqrtFunctionCall
 | Trunc '(' expression ')'                 #truncFunctionCall
 | Abs '(' expression ')'                   #absFunctionCall
 | Pot '(' expression ')'                   #potFunctionCall
 | Round '(' expression ')'                 #roundFunctionCall
 | ModeAC '(' expression ')'                #modeacFunctionCall
 | ModeIC '(' expression ')'                #modeicFunctionCall
 | Trans                                    #transFunctionCall
 | Atrans                                   #atransFunctionCall
 | Rot                                      #rotFunctionCall
 | Arot                                     #arotFunctionCall
 | Scale                                    #scaleFunctionCall
 | AScale                                   #ascaleFunctionCall
 | Mirror                                   #mirrorFunctionCall
 | Amirror                                  #amirrorFunctionCall
 | Oriwks                                   #oriwksFunctionCall
 | Oriaxes                                  #oriaxesFunctionCall
 | Traori                                   #traoriFunctionCall
 | Xaxis '=' expression                     #xcoordFunctionCall
 | Yaxis '=' expression                     #ycoordFunctionCall
 | Zaxis '=' expression                     #zcoordFunctionCall
 | Aaxis '=' expression                     #acoordFunctionCall
 | Baxis '=' expression                     #bcoordFunctionCall
 | Caxis '=' expression                     #ccoordFunctionCall
 | Uaxis '=' expression                     #ucoordFunctionCall
 | Vaxis '=' expression                     #vcoordFunctionCall
 | Waxis '=' expression                     #wcoordFunctionCall
 | Ivect '=' expression                     #ivectFunctionCall
 | Jvect '=' expression                     #jvectFunctionCall
 | Kvect '=' expression                     #kvectFunctionCall
 | Radius '=' expression                    #radiusFunctionCall
// | GFunc                        #gmodeFunctionCall
 | MFunc '='? Number?                       #mmodeFunctionCall
 | FFunc '=' expression                     #feedFunctionCall
 | SFunc '=' expression                     #speedFunctionCall
 | TFunc                                    #toolNumberFunctionCall
 | DFunc                                    #toolIDFunctionCall
 | SubProg '(' exprList? ')'                #subprogramFunctionCall
 ;


ifStatement
 : ifStat elseStat? EndIf
 ;

ifStat
 : If expression statement*
 ;

 ifGotostat
 : If expression GotoB metkaDest
 | If expression GotoF metkaDest
 | If expression Goto metkaDest
 ;

elseStat
 : Else statement*
 ;

functionDecl
 : Proc Identifier '(' idList? ')' block EndProc
 ;

forStatement
 : For Identifier '=' expression To expression block EndFor
 ;

whileStatement
 : While expression block EndWhile
 ;

 gotoStatement
 : GotoB Identifier
 | GotoF Identifier
 | Goto Identifier
 ;

idList
 : typeDef Identifier ( ',' typeDef Identifier )*
 ;

exprList
 : expression ( ',' expression )*
 ;

expression
 : '-' expression                                       #unaryMinusExpression
 | 'NOT' expression                                     #notExpression
 | <assoc=right> expression '^' expression              #powerExpression
 | expression op=( '*' | '/' | '%' ) expression         #multExpression
 | expression op=( '+' | '-' ) expression               #addExpression
 | expression op=( '>=' | '<=' | '>' | '<' ) expression #compExpression
 | expression op=( '==' | '!=' ) expression             #eqExpression
 | expression And expression                            #andExpression
 | expression Or expression                             #orExpression
 | expression '?' expression ':' expression             #ternaryExpression
 | Number                                               #numberExpression
 | Bool                                                 #boolExpression
 | Null                                                 #nullExpression
 | functionCall indexes?                                #functionCallExpression
 | list indexes?                                        #listExpression
 | Identifier indexes?                                  #identifierExpression
 | String indexes?                                      #stringExpression
 | '(' expression ')' indexes?                          #expressionExpression
 | Input '(' String? ')'                                #inputExpression
 ;

//coordinateStatement
// : Xaxis '-'? Number                                     #xcoordCoordinates
// | Yaxis '-'? Number                                     #ycoordCoordinates
// | Zaxis '-'? Number                                     #zcoordCoordinates
// | Aaxis '-'? Number                                     #acoordCoordinates
// | Baxis '-'? Number                                     #bcoordCoordinates
// | Caxis '-'? Number                                     #ccoordCoordinates
// | Uaxis '-'? Number                                     #ucoordCoordinates
// | Vaxis '-'? Number                                     #vcoordCoordinates
// | Waxis '-'? Number                                     #wcoordCoordinates
// ;

gcodeStatement
: GCodeText (GCodeText CR?)*
;

list
 : '[' exprList? ']'
 ;

varlist
   : Identifier (',' Identifier)*
   ;

typeDef
    : 'INT'
    | 'STRING'
    | 'REAL'
    | 'BOOL'
    | 'CHAR'
    | 'AXIS'
    | 'FRAME'
    ;

indexes
 : ( '[' expression ']' )+
 ;

metkaStart
  : Labelstart
  ;

metkaDest
  : Identifier
  ;

Println  : 'println';
Print    : 'print';
Input    : 'input';
Assert   : 'assert';
Size     : 'size';
Sin      : 'SIN';
ASin     : 'ASIN';
Cos      : 'COS';
ACos     : 'ACOS';
Tan      : 'TAN';
ATan     : 'ATAN';
ATan2    : 'ATAN2';
Abs      : 'ABS';
Sqrt     : 'SQRT';
Trunc    : 'TRUNC';
Pot      : 'POT';
Round    : 'ROUND';
Def      : 'DEF';
Proc     : 'PROC';
EndProc  : 'RET'|('m'|'M')('17');
If       : 'IF';
EndIf    : 'ENDIF';
Else     : 'ELSE';
Return   : 'return';
For      : 'FOR';
EndFor   : 'ENDFOR';
While    : 'WHILE';
EndWhile : 'ENDWHILE';
GotoB    : 'GOTOB';
GotoF    : 'GOTOF';
Goto     : 'GOTO';
Trans    : 'TRANS';
Atrans   : 'ATRANS';
Rot      : 'ROT';
Arot     : 'AROT';
Mirror   : 'MIRROR';
Amirror  : 'AMIRROR';
Scale    : 'SCALE';
AScale   : 'ASCALE';
Oriwks   : 'ORIWKS';
Oriaxes  : 'ORIAXES';
Traori   : 'TRAORI';
To       : 'TO';
End      : 'end';
SubProg  : ('l'|'L')('0'..'9')+;
Null     : 'null';
//GFunc    : ('g' | 'G')('0'..'9')+;
MFunc    : ('m' | 'M')('0'..'9')+;
FFunc    : ('f' | 'F');
SFunc    : ('s' | 'S');
TFunc    : ('t' | 'T')('0'..'9')+;
DFunc    : ('d' | 'D')('0'..'9')+;
Nnumb    : ('n' | 'N')('0'..'9')+ -> skip;
Xaxis    : 'x' | 'X';
Yaxis    : 'y' | 'Y';
Zaxis    : 'z' | 'Z';
Aaxis    : 'a' | 'A';
Baxis    : 'b' | 'B';
Caxis    : 'c' | 'C';
Uaxis    : 'u' | 'U';
Vaxis    : 'v' | 'V';
Waxis    : 'w' | 'W';
Ivect    : 'i' | 'I';
Jvect    : 'j' | 'J';
Kvect    : 'k' | 'K';
ModeAC   : 'ac'| 'AC';
ModeIC   : 'ic'| 'IC';
Radius   : 'cr'| 'CR';

Or       : 'or'|'OR';
And      : 'and'|'AND';
Equals   : '==';
NEquals  : '!=';
GTEquals : '>=';
LTEquals : '<=';
Pow      : '^';
Excl     : '!';
GT       : '>';
LT       : '<';
Add      : '+';
Subtract : '-';
Multiply : '*';
Divide   : '/';
Modulus  : '%';
OBrace   : '{';
CBrace   : '}';
OBracket : '[';
CBracket : ']';
OParen   : '(';
CParen   : ')';
SColon   : ';';
Assign   : '=';
Comma    : ',';
QMark    : '?';
Colon    : ':';

Bool
 : 'TRUE'
 | 'FALSE'
 ;

Number
 : Int ( '.' Digit* )?
 ;

GCodeText
 : [aAbBcCgGsStTdDmMfFiIjJkKxXyYzZuUvVwW][\t]*[+-]?[0-9]+[.]?[0-9]*
 ;

Identifier
 : [_a-zA-Z][_a-zA-Z][a-zA-Z_0-9]*
 | [rR][0-9]+
 ;

Labelstart
 : [a-zA-Z][a-zA-Z][a-zA-Z_0-9]*[:]
 ;

Mcodes
 : [mM][0-9]+
 ;

String
 : ["] ( ~["\r\n\\] | '\\' ~[\r\n] )* ["]
 | ['] ( ~['\r\n\\] | '\\' ~[\r\n] )* [']
 ;


Comment
 : ( ';' .*? (CR|EOF) ) -> skip
 ;

//Space
// : [ \t\r\n\u000C] -> skip
// ;

WHITESPACE : (' ' | '\t') -> skip ;

crlfStatement
 : CR
 ;

CR
: [\r]?[\n]
;

fragment Int
 : [1-9] Digit*
 | '0'
 ;
  
fragment Digit 
 : [0-9]
 ;