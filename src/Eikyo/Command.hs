{-# LANGUAGE DeriveDataTypeable #-}

module Eikyo.Command (mode, Eikyo (..)) where

import System.Console.CmdArgs

data Eikyo
  = Compile {file :: FilePath}
  | Build
  deriving (Data, Typeable, Show, Eq)

compile = Compile {file = def &= typ "FILE" &= argPos 0} &= help "Compile the file"

build = Build &= help "(Not yet done) Build the project"

mode =
  cmdArgsMode $
    modes [compile, build]
      &= help "Eikyo compiler"
      &= program "eikyo"
      &= summary "Eikyo v0.0\n"
