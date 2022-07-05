module Lib
  ( someFunc,
  )
where

import Eikyo.Parser
import Text.Megaparsec hiding (State)

someFunc :: IO ()
someFunc = do
  parseTest
    pModule
    "module data\n\
    \           \n\
    \type bool  \n\
    \  true     \n\
    \  false      "
  parseTest
    pDataType
    "type bool\n\
    \  true\n\
    \  false"
  parseTest
    pDataType
    "type nat\n\
    \  zero\n\
    \  suc{n : nat}"
  parseTest
    pDataType
    "type list[a]\n\
    \  nil\n\
    \  cons{head : a, tail : list[a]}"
