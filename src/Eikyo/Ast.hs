module Eikyo.Ast
  ( Module (..),
    TopDecl (..),
    Constructor (..),
    Field (..),
    Type (..),
  )
where

import Data.Text

data Module = Module
  { name :: Text,
    decls :: [TopDecl]
  }
  deriving (Show, Eq)

data TopDecl = DataType
  { name :: Text,
    type_vars :: [Type],
    constructors :: [Constructor]
  }
  deriving (Show, Eq)

data Constructor = Constructor
  { name :: Text,
    fields :: [Field]
  }
  deriving (Show, Eq)

data Field = Field
  { name :: Text,
    ty :: Type
  }
  deriving (Show, Eq)

data Type
  = TyVar Text
  | TyConstuctor Text [Type]
  | TyFun [Type] Type
  | TyTuple [Type]
  deriving (Show, Eq)
