module Parser.StatementSpec where

import Eikyo.Ast
import Eikyo.Parser
import SpecHelper
import Test.Hspec.Megaparsec
import Text.Megaparsec

spec :: Spec
spec = describe "parse statement" $ do
  context "let" $ do
    it "without type" $ do
      let input = [str|let x = 1|]
      parse pStatement "" input `shouldParse` Let "x" Nothing (EInt 1)
    it "with type" $ do
      let input = [str|let x : int = 1|]
      parse pStatement "" input `shouldParse` Let "x" (Just $ TyVar "int") (EInt 1)
