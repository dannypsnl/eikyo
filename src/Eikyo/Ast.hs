module Eikyo.Ast
  ( Module (..),
    TopDecl (..),
    Constructor (..),
    Statement (..),
    Expr (..),
    Bind (..),
    Type (..),
    Mark (..),
  )
where

import Data.Text

data Module = Module
  { name :: Text,
    decls :: [TopDecl]
  }
  deriving (Show, Eq)

data TopDecl
  = DataType
      { name :: Text,
        type_vars :: [Type],
        constructors :: [Constructor]
      }
  | Fun
      { name :: Text,
        args :: [Bind],
        return_ty :: Type,
        body :: [Statement]
      }
  deriving (Show, Eq)

data Statement
  = Expr Expr
  | Let Text (Maybe Type) Expr
  deriving (Show, Eq)

data Expr
  = EInt Integer
  | EVar Text
  | EAdd Expr Expr
  | ESub Expr Expr
  | EMul Expr Expr
  | EDiv Expr Expr
  | ECall Expr [Expr]
  deriving (Show, Eq)

data Constructor = Constructor
  { name :: Text,
    fields :: [Bind]
  }
  deriving (Show, Eq)

data Bind = Bind
  { name :: Text,
    ty :: Type
  }
  deriving (Show, Eq)

data Type
  = TyVar Text
  | TyConstuctor Text [Type]
  | TyFun [Type] Type
  | TyWith Type [Mark]
  deriving (Show, Eq)

data Mark
  = Requires Text
  | -- +
    Ensures Text
  | -- ?+
    EnsuresTry Text
  | -- -
    Takes Text
  | -- ?-
    TakesTry Text
  deriving (Show, Eq)