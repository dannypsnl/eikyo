module Lib
    ( someFunc
    ) where
import Text.Megaparsec hiding (State)
import Eikyo.Parser

someFunc :: IO ()
someFunc = do
    parseTest pModule "module data\n\
                      \\n\
                      \type bool\n\
                      \  true\n\
                      \  false"
    parseTest pDataType "type bool\n\
                        \  true\n\
                        \  false"
    parseTest pDataType "type nat\n\
                        \  zero\n\
                        \  suc{n : nat}"
    parseTest pDataType "type list[a]\n\
                        \  nil\n\
                        \  cons{head : a, tail : list[a]}"
