module AExprParser where

import Control.Applicative
import Text.Megaparsec
import Text.Megaparsec.Char -- various basic parsers
import qualified Text.Megaparsec.Char.Lexer as L
import Text.Megaparsec.Expr

-- The abstract syntax of expressions
data AExpr
  = Var String
  | IntConst Integer
  | Add AExpr AExpr
  | Sub AExpr AExpr
  | Mul AExpr AExpr
  | Div AExpr AExpr
  | Mod AExpr AExpr
  | Neg AExpr
  deriving (Show)

examplesAExpr :: [(String, AExpr)]
examplesAExpr = [
    ("x", Var "x"),
    ("x + 5", Add (Var "x") (IntConst 5)),
    ("(x - 4)*(x + 4)", Mul (Sub (Var "x") (IntConst 4)) (Add (Var "x") (IntConst 4))),
    ("x + 6*z", Add (Var "x") (Mul (IntConst 6) (Var "z")))
  ]


type Parser = Parsec () String

-- The <?> Combinator informs a parser how to label a failed parser

expr = makeExprParser factor opTable <?> "expression"

-- parenthesized expressions are missing
factor = choice [ intConst
                , identifier
                , between lparen rparen expr
                ] <?> "factor"

opTable = [ [ prefix  '-'  Neg
            , prefix  '+'  id ] -- including a prefix + sign
          , [ binary  '*'  Mul
            , binary  '/'  Div
            , binary  '%'  Mod]
          , [ binary  '+'  Add
            , binary  '-'  Sub  ] ]

-- These help declare operators
-- They don't handle white space.
binary  opName f = InfixL  (f <$ lexeme (char opName))
prefix  opName f = Prefix  (f <$ lexeme (char opName))

spaceConsumer :: Parser ()
spaceConsumer = L.space space1 lineCmnt blockCmnt
  where
    lineCmnt  = L.skipLineComment "//"
    blockCmnt = L.skipBlockComment "/*" "*/"

-- Define a wrapper that consumes space after a parser
lexeme :: Parser a -> Parser a
lexeme = L.lexeme spaceConsumer

lparen = lexeme (char '(')
rparen = lexeme (char ')')

identifier :: Parser AExpr
identifier = Var <$> (lexeme . try) p
  where
    p = (:) <$> letterChar <*> many alphaNumChar

intConst :: Parser AExpr
intConst = fmap IntConst intConst'
  where
    intConst' = (lexeme . try) ic
    ic = do
          x <- L.decimal -- parse a literal
          notFollowedBy letterChar -- fail if followed by a letter
          return x -- return the  result if we haven't failed

tryit :: String -> Either (ParseError (Token String) ()) AExpr
tryit  = parse expr "(--)"




-- import Text.Megaparsec -- the main combinator library
-- import Text.Megaparsec.Char -- various basic parsers for characters
-- import qualified Text.Megaparsec.Char.Lexer as L -- This avoids name clashes with Prelude.
-- import Control.Monad (void,guard)
--
-- type Parser = Parsec () String
--
-- -- space1 is a parser from Text.Megaparsec.Char that will consume one or more whitespaces
-- -- L.space is a combinator that combines its first argument to consume space characters and its 2nd and 3rd arguments to specify how comments are formed.
-- -- L.skipLineComment matches its 1st argument then ignores everything to end of line
-- -- L.skipblockComment matches begin- and end-comment strings and ignores everything between
--
-- spaceConsumer :: Parser ()
-- spaceConsumer = L.space space1 lineCmnt blockCmnt
--   where
--     lineCmnt  = L.skipLineComment "//"
--     blockCmnt = L.skipBlockComment "/*" "*/"
--
-- -- Define a wrapper that consumes space after a parser
-- lexeme :: Parser a -> Parser a
-- lexeme = L.lexeme spaceConsumer
--
-- identifier :: Parser String
-- identifier = (lexeme . try) $ (:) <$> letterChar <*> many alphaNumChar
--
-- data MoBettaToken = Identifier String | Constant Integer deriving (Show)
--
-- identifier' :: Parser MoBettaToken
-- identifier' = fmap Identifier identifier
--
-- intConst' :: Parser MoBettaToken
-- intConst' = fmap Constant intConst
--
-- intConst :: Parser Integer
-- intConst = (lexeme . try) ic
--   where
--     ic = do
--       x <- L.decimal -- parse a literal
--       notFollowedBy letterChar -- fail if followed by a letter
--       return x -- return the  result if we haven't failed
--
-- keywordString :: Parser String
-- keywordString = (lexeme . try) kw
--   where
--     kw = do
--       x <- L.charLiteral
--       return x
--
-- -- symbol :: String -> Parser String
-- -- symbol s = try $ lexeme $ do
-- --     u <- many1 (oneOf "<>=+-^%/*!|")
-- --     guard (s == u)
-- --     return s
