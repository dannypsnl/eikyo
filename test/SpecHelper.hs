module SpecHelper
  ( module Test.Hspec,
    str,
  )
where

import qualified Data.Text as T
import Language.Haskell.TH
import Language.Haskell.TH.Quote
import Test.Hspec
import Text.Megaparsec.Pos

str :: QuasiQuoter
str =
  QuasiQuoter
    { quoteExp = stringE,
      quotePat = error "don't allow",
      quoteType = error "don't allow",
      quoteDec = error "don't allow"
    }
