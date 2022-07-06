{-# LANGUAGE TupleSections #-}

module Eikyo.Parser
  ( pModule,
    pDataType,
    pStruct,
    pFun,
  )
where

import Control.Monad
import Data.Text (Text)
import qualified Data.Text as T
import Data.Void
import Eikyo.Ast
import Text.Megaparsec hiding (State)
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

type Parser = Parsec Void Text

pModule :: Parser Module
pModule = do
  void (symbol "module")
  name <- identifier
  decls <- many pDecl
  return Module {..}

pDecl :: Parser TopDecl
pDecl = lexeme $ (try pDataType <|> try pStruct)

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
      return (L.IndentMany Nothing (return . \body -> Fun{..}) pStatement)

pStatement :: Parser Statement
pStatement = try (ReturnExpr <$> pExpr)
pExpr :: Parser Expr
pExpr = lexeme $
      try (EInt <$> integer)
  <|> try (EVar <$> identifier)
  -- <|> try (EAdd <$> pExpr <$ (symbol "+") $> <*> pExpr)

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
    <|> try (TyVar <$> identifier)

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

integer :: Parser Integer
integer = lexeme L.decimal

identifier :: Parser Text
identifier = T.pack <$> (lexeme . try) (some alphaNumChar) <?> "identifier"
