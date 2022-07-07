{-# LANGUAGE DeriveDataTypeable #-}

module Main where

import System.Console.CmdArgs
import System.Console.CmdArgs.Explicit (HelpFormat (..), helpText, process)

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

main :: IO ()
main = do
  eikyo_mode <- cmdArgsRun mode
  case eikyo_mode of
    Compile {file = f} -> do
      putStrLn $ "Compiling " ++ f ++ "..."
    Build -> do
      putStrLn "Building"
