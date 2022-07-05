module ParserSpec where
import SpecHelper
import Test.Hspec.Megaparsec
import Text.Megaparsec
import Eikyo.Ast
import Eikyo.Parser

spec :: Spec
spec = describe "parse top level" $ do
  context "data type" $ do
    it "Bool" $ do
      let input = "type Bool\n\
                  \  true   \n\
                  \  false    "
      parse pDataType "" input `shouldParse` (DataType {name = "Bool", constructors = [
        Constructor {name = "true", fields = Nothing},
        Constructor {name = "false", fields = Nothing}
      ]})
    it "Nat" $ do
      let input = "type Nat\n\
                  \  zero   \n\
                  \  succ{n : Nat}    "
      parse pDataType "" input `shouldParse` (DataType {name = "Nat", constructors = [
        Constructor {name = "zero", fields = Nothing},
        Constructor {name = "succ", fields = Just [
            Field {name = "n", ty = TyConst "Nat"}
        ]}
      ]})
