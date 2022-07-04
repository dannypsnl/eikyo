{-# LANGUAGE TupleSections #-}
module Eikyo.Parser (
    pDataType,
    identifier
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

pDataType :: Parser DataType
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
    return Constructor {..}

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
