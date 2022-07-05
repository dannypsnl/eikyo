module ParserSpec where

import Eikyo.Ast
import Eikyo.Parser
import SpecHelper
import Test.Hspec.Megaparsec
import Text.Megaparsec

spec :: Spec
spec = describe "parse top level" $ do
  context "data type" $ do
    it "Bool" $ do
      let input =
            "type Bool\n\
            \  true   \n\
            \  false    "
      parse pDataType "" input
        `shouldParse` ( DataType
                          { name = "Bool",
                            type_vars = [],
                            constructors =
                              [ Constructor {name = "true", fields = []},
                                Constructor {name = "false", fields = []}
                              ]
                          }
                      )
    it "Nat" $ do
      let input =
            "type Nat     \n\
            \  zero       \n\
            \  succ{n : Nat}"
      parse pDataType "" input
        `shouldParse` ( DataType
                          { name = "Nat",
                            type_vars = [],
                            constructors =
                              [ Constructor {name = "zero", fields = []},
                                Constructor
                                  { name = "succ",
                                    fields =
                                      [ Field {name = "n", ty = TyVar "Nat"}
                                      ]
                                  }
                              ]
                          }
                      )
    it "List" $ do
      let input =
            "type List[a]                  \n\
            \  nil                         \n\
            \  cons{head : a, tail : List[a]}"
      parse pDataType "" input
        `shouldParse` ( DataType
                          { name = "List",
                            type_vars = [TyVar "a"],
                            constructors =
                              [ Constructor {name = "nil", fields = []},
                                Constructor
                                  { name = "cons",
                                    fields =
                                      [ Field {name = "head", ty = TyVar "a"},
                                        Field {name = "tail", ty = TyConstuctor "List" [TyVar "a"]}
                                      ]
                                  }
                              ]
                          }
                      )
