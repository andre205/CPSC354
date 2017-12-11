module Syntax where

type Program = [Statement] -- a program is a list of statements

type Identifer = String

data Statement
--  = Assignment Identifier Expression
  = If Condition Statement Statement
  | While Condition Statement
  | Msg String
  | Print Expression
  | Println Expression
-- | Read Identifier
  | Skip
  | Block Program


data Condition
  = BoolConst Bool
  | Not Condition
  | BoolBinOp Condition Condition
  | Test Comparison Expression Expression

data BoolBinOp
  = And
  | Or

data Comparison
  = Greater
  | GreaterEq
  | Less
  | LessEqual
  | Equal
  | NEqual

data Expression
    = Var Term
    | Expression AdditiveOp Term

data Term
    = Factor
    | Term MultiplicativeOp Factor

data Factor
    = Identifier
    -- | (Expression)

data UnOp = Neg

data AdditiveOp
  = Plus
  | Minus

data MultiplicativeOp
  = Times
  | Divide
  | Mod




{--

x = 1;
while x > 0 {
  println x;
  x = x - 1
}

--}

-- example :: Program
-- example = [ Assignment "x" (IntConst 10),
--             While (Test (Greater (Var "x") (IntConst 0))
--               (Block
--                 [ Println (Var "x"),
--                   Assignment "x" (BinExpression Minus (Var "x") (IntConst 1))
--                 ]
--               )
--           ]
