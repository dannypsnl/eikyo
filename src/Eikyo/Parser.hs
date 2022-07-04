{-# LANGUAGE TupleSections #-}
module Eikyo.Parser (
    pModule,
    pDataType,
) where
import Control.Monad
import Text.Megaparsec hiding (State)
import Text.Megaparsec.Char
import Data.Text (Text)
import Data.Void
import qualified Data.Text as T
import qualified Text.Megaparsec.Char.Lexer as L
import Eikyo.Ast

type Parser = Parsec Void Text

pModule :: Parser Module
pModule = do
    void (symbol "module")
    name <- identifier
    decls <- many pDecl
    return Module{..}

pDecl :: Parser TopDecl
pDecl = lexeme pDataType

pDataType :: Parser TopDecl
pDataType = L.indentBlock scn indentedBlock
  where
    indentedBlock = do
      void (symbol "type")
      name <- identifier
      return (L.IndentMany Nothing (return . (toDataType name)) pConstructor)
    toDataType name constructors = DataType{..}

pConstructor :: Parser Constructor
pConstructor = do
    name <- identifier
    fields <- optional pFields
    return Constructor {..}

pFields :: Parser [Field]
pFields = do
    void (symbol "{")
    fields <- sepBy1 pField (symbol ",")
    void (symbol "}")
    return fields
pField :: Parser Field
pField = do
    name <- identifier
    void (symbol ":")
    ty <- pType
    return Field{..}

pType :: Parser Type
pType = do
    name <- identifier
    return (TyConst name)

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

integer :: Parser Integer
integer = lexeme L.decimal

identifier :: Parser Text
identifier = T.pack <$> (lexeme . try) (some alphaNumChar) <?> "identifier"
