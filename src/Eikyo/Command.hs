{-# LANGUAGE DeriveDataTypeable #-}

module Eikyo.Command (mode, dispatchCommands) where

import qualified Data.Text as T
import Eikyo.Compiler
import Eikyo.Parser
import System.Console.CmdArgs
import Text.Megaparsec

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

dispatchCommands :: Eikyo -> IO ()
dispatchCommands eikyo_mode = do
  case eikyo_mode of
    Compile {file = app_file} -> do
      putStrLn $ "Compiling " ++ app_file ++ "..."
      contents <- T.pack <$> readFile app_file
      case runParser pModule app_file contents of
        Left bundle -> putStr (errorBundlePretty bundle)
        Right mod -> do
          putStrLn "Parsing done..."
          compileModule mod
    Build -> do
      putStrLn "Building"
