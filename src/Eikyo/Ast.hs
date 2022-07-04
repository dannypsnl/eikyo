module Eikyo.Ast (
  DataType(..),
  Constructor(..),
) where
import Data.Text

data DataType = DataType
  { name :: Text
  , constructors :: [Constructor]
  } deriving (Eq, Show)

data Constructor = Constructor
  { name :: Text
--   , fields :: [Field]
  } deriving (Eq, Show)