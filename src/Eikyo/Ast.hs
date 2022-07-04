module Eikyo.Ast (
  Module(..),
  TopDecl(..),
  Constructor(..),
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
--   , fields :: [Field]
  } deriving (Show, Eq)