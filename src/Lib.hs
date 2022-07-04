{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( someFunc
    ) where
import Text.Megaparsec
import Text.Megaparsec.Char
import Data.Text (Text)
import Data.Void

type Parser = Parsec Void Text

someFunc :: IO ()
someFunc = parseTest (string "foo" :: Parser Text) "foo"
