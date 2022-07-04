{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}
-- {-# LANGUAGE OverloadedRecordDot, OverloadedRecordUpdate, RebindableSyntax #-}
module Lib
    ( someFunc
    ) where
import Control.Monad
import Text.Megaparsec hiding (State)
import Text.Megaparsec.Char
import Data.Text (Text)
import Data.Void
import qualified Data.Text as T
import qualified Text.Megaparsec.Char.Lexer as L

type Parser = Parsec Void Text

someFunc :: IO ()
someFunc = parseTest pDataType "type foo"

data DataType = DataType
    { name :: Text
    -- , constructors :: [Field]
    } deriving (Eq, Show)

pDataType :: Parser DataType
pDataType = do
    void (string "type")
    void space
    name <- T.pack <$> some alphaNumChar
    return $ DataType{..}