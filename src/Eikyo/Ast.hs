module Eikyo.Ast (
  Module(..),
  TopDecl(..),
  Constructor(..),
  Field(..),
) where
import Data.Text

data Module = Module
  { name :: Text
  , decls :: [TopDecl]
  } deriving (Show, Eq)

data TopDecl = DataType
  { name :: Text
  , constructors :: [Constructor]
  } deriving (Show, Eq)

data Constructor = Constructor
  { name :: Text
  , fields :: Maybe [Field]
  } deriving (Show, Eq)

data Field = Field
  { name :: Text
  , ty :: Text
  } deriving (Show, Eq)
