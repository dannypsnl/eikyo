module Lib
    ( someFunc
    ) where
import Text.Megaparsec hiding (State)
import Eikyo.Parser

someFunc :: IO ()
someFunc = parseTest pDataType "type foo"
