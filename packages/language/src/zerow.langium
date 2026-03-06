grammar Zerow

// Program Structure
entry Program:
    units+=UnitDeclaration*
    statements+=Statement*
    returns+=ReturnStatement;

// Unit declarations

UnitDeclaration:
    'unit' name=ID
;

// Statements:

Statement:
    VariableDeclaration | Assignment
;

VariableDeclaration:
    'declare' name=ID 'equals' expression=Expression
;

Assignment:
    'Assign' expression=Expression 'to' variable=[VariableDeclaration]
;

ReturnStatement:
    'returns' expression=Expression 
;

// Expressions

Expression:
    AdditiveExpression
;

AdditiveExpression:
    MultiplicativeExpression
    ({BinaryExpression.left=current}
        operator= ('add' | 'sub')
        right = MultiplicativeExpression
    )*
;

MultiplicativeExpression:
    PrimaryExpression
    ({BinaryExpression.left=current}
        operator=('mul' | 'div')
        right=PrimaryExpression
    )*
;

PrimaryExpression:
      Literal
    | {NegExpression} 'neg' expression=PrimaryExpression
    | {VariableReference} variable=[VariableDeclaration]
    | '(' Expression ')'
;


// Literals

Literal: 
    value=INT '[' unit=[UnitDeclaration] ']'
;

// Abstract syntax tree Interfaces

// Left and right expression with operator
interface BinaryExpression {
    left: Expression
    operator: string
    right: Expression
}

// Negation node
interface NegExpression {
    expression: Expression
}

// Variable reference node
interface VariableReference {
    variable: @VariableDeclaration
}

// Terminals


hidden terminal WS: /\s+/;
terminal ID: /[_a-zA-Z][\w_]*/;
terminal INT returns number: /[0-9]+/;

hidden terminal ML_COMMENT: /\/\*[\s\S]*?\*\//;
hidden terminal SL_COMMENT: /\/\/[^\n\r]*/;
