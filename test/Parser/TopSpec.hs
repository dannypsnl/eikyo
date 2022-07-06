module Parser.TopSpec where

import Eikyo.Ast
import Eikyo.Parser
import SpecHelper
import Test.Hspec.Megaparsec
import Text.Megaparsec

spec :: Spec
spec = describe "parse top level" $ do
  context "module" $ do
    it "empty one" $ do
      let input = [str|module hello|]
      parse pModule "" `shouldSucceedOn` input
    it "with some declarations" $ do
      let input =
            [str|module hello
            
            type Bool
              true
              false
            
            struct Nice
              try : Bool

            fun add(x : int, y : int) : int
              x + y
            |]
      parse pModule "" `shouldSucceedOn` input
  context "structure" $ do
    it "Person" $ do
      let input =
            [str|struct Person
                   name: String
                   age: Int
            |]
      parse pStruct "" `shouldSucceedOn` input
  context "fun" $ do
    it "simply typed" $ do
      let input =
            [str|fun add(x : int, y : int) : int
                   x + y
            |]
      parse pFun "" `shouldSucceedOn` input
    it "statement" $ do
      let input =
            [str|fun foo() : int
                   foo()
                   let x : int = 1
                   let y = 2
                   foo()
            |]
      parse pFun "" `shouldSucceedOn` input
  context "data type" $ do
    it "Bool" $ do
      let input =
            [str|type Bool
                   true
                   false
            |]
      parse pDataType "" `shouldSucceedOn` input
    it "Nat" $ do
      let input =
            [str|type Nat
                   zero
                   succ{n : Nat}
            |]
      parse pDataType "" `shouldSucceedOn` input
    it "List" $ do
      let input =
            [str|type List[a]
                   nil
                   cons{head : a, tail : List[a]}
            |]
      parse pDataType "" input
        `shouldParse` DataType
          { name = "List",
            type_vars = [TyVar "a"],
            constructors =
              [ Constructor {name = "nil", fields = []},
                Constructor {name = "cons", fields = [Bind {name = "head", ty = TyVar "a"}, Bind {name = "tail", ty = TyConstuctor "List" [TyVar "a"]}]}
              ]
          }
