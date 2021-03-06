{-# LANGUAGE TupleSections #-}

module Eikyo.Parser
  ( pModule,
    pDataType,
    pStruct,
    pFun,
    pStatement,
  )
where

import Control.Monad
import Control.Monad.Combinators.Expr
import Data.Text (Text)
import qualified Data.Text as T
import Data.Void
import Eikyo.Ast
import Text.Megaparsec hiding (State)
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L
import Text.Megaparsec.Error

type Parser = Parsec Void Text

pModule :: Parser Module
pModule = do
  void (symbol "module")
  name <- identifier
  scn
  decls <- many pDecl
  return Module {..}

pDecl :: Parser TopDecl
pDecl =
  (lexeme . try) $
    ( pDataType
        <|> pStruct
        <|> pFun
    )

pFun :: Parser TopDecl
pFun = L.indentBlock scn indentBlock
  where
    pArg = pBind
    indentBlock = do
      void (symbol "fun")
      name <- identifier
      args <- parens (sepBy pArg (symbol ","))
      void (symbol ":")
      return_ty <- pType
      return (L.IndentMany Nothing (return . \body -> Fun {..}) pStatement)

pStatement :: Parser Statement
pStatement =
  (try)
    pLet
    <|> Expr <$> pExpr
  where
    pLet = do
      void $ symbol "let"
      name <- identifier
      ty <- optional $ (symbol ":" *> pType)
      void $ symbol "="
      expr <- pExpr
      return $ Let name ty expr

pExpr = makeExprParser pTerm operatorTable <?> "expression"

pTerm =
  choice
    [ parens pExpr,
      pInteger,
      pVariable
    ]
    <?> "term"
  where
    pInteger :: Parser Expr
    pInteger = EInt <$> lexeme L.decimal <?> "integer"
    pVariable :: Parser Expr
    pVariable = EVar <$> identifier <?> "variable"

operatorTable :: [[Operator Parser Expr]]
operatorTable =
  [ [ binary "*" EMul,
      binary "/" EDiv
    ],
    [ binary "+" EAdd,
      binary "-" ESub
    ],
    [Postfix pFuncCall]
  ]

pFuncCall :: Parser (Expr -> Expr)
pFuncCall = do
  args <- parens $ sepBy pExpr (symbol ",")
  return $ \funcExpr -> ECall funcExpr args

binary :: Text -> (Expr -> Expr -> Expr) -> Operator Parser Expr
binary name f = InfixL (f <$ symbol name)

prefix, postfix :: Text -> (Expr -> Expr) -> Operator Parser Expr
prefix name f = Prefix (f <$ symbol name)
postfix name f = Postfix (f <$ symbol name)

pStruct :: Parser TopDecl
pStruct = L.indentBlock scn indentedBlock
  where
    indentedBlock = do
      void (symbol "struct")
      name <- identifier
      type_vars <- concat <$> optional (brackets (sepBy1 pType (symbol ",")))
      return (L.IndentMany Nothing (return . (toDataType name type_vars)) pBind)
    toDataType name type_vars fields =
      DataType {constructors = [Constructor {..}], ..}

pDataType :: Parser TopDecl
pDataType = L.indentBlock scn indentedBlock
  where
    indentedBlock = do
      void (symbol "type")
      name <- identifier
      type_vars <- concat <$> optional (brackets (sepBy1 pType (symbol ",")))
      return (L.IndentMany Nothing (return . (toDataType name type_vars)) pConstructor)
    toDataType name type_vars constructors = DataType {..}

pConstructor :: Parser Constructor
pConstructor = do
  name <- identifier
  fields <- concat <$> optional pFields
  return Constructor {..}

pFields :: Parser [Bind]
pFields = braces $ sepBy1 pBind (symbol ",")

pBind :: Parser Bind
pBind = do
  name <- identifier
  void (symbol ":")
  ty <- pType
  return Bind {..}

pType :: Parser Type
pType =
  try (TyConstuctor <$> identifier <*> (brackets (sepBy1 pType (symbol ","))))
    <|> try (TyWith <$> pType <*> (braces (sepBy1 pMark (symbol ","))))
    <|> try (TyVar <$> identifier)

pMark :: Parser Mark
pMark =
  try
    ( do
        symbol "+"
        Ensures <$> identifier
    )
    <|> try
      ( do
          symbol "?+"
          EnsuresTry <$> identifier
      )
    <|> try
      ( do
          symbol "-"
          Takes <$> identifier
      )
    <|> try
      ( do
          symbol "?-"
          TakesTry <$> identifier
      )
    <|> try (Requires <$> identifier)

-- Tokens
lineComment :: Parser ()
lineComment = L.skipLineComment "#"

scn :: Parser ()
scn = L.space space1 lineComment empty

sc :: Parser ()
sc = L.space hspace1 lineComment empty

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

symbol :: Text -> Parser Text
symbol = L.symbol sc

parens :: Parser a -> Parser a
parens = between (symbol "(") (symbol ")")

brackets :: Parser a -> Parser a
brackets = between (symbol "[") (symbol "]")

braces :: Parser a -> Parser a
braces = between (symbol "{") (symbol "}")

identifier :: Parser Text
identifier =
  lexeme
    ( try (symbol $ T.pack "()")
        <|> (T.pack <$> try ((:) <$> startChar <*> some followChar))
    )
    <?> "identifier"
  where
    startChar = letterChar <|> symbolChar
    followChar = startChar <|> digitChar <|> (char '-')
