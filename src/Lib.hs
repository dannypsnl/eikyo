module Lib
    ( someFunc
    ) where
import Text.Megaparsec hiding (State)
import Eikyo.Parser

someFunc :: IO ()
someFunc = do
    parseTest pDataType "type bool\n\
                        \  true\n\
                        \  false"
    -- parseTest identifier "  true"
