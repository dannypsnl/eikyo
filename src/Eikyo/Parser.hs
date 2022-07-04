module Eikyo.Parser (
    pDataType
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
pDataType = do
    void (string "type")
    void space
    name <- T.pack <$> some alphaNumChar
    let constructors = []
    return $ DataType{..}