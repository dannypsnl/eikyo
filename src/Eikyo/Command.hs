{-# LANGUAGE DeriveDataTypeable #-}

module Eikyo.Command (mode, dispatchCommands) where

import qualified Data.Text as T
import Eikyo.Backend.Compiler
import Eikyo.Backend.Interpreter
import Eikyo.Parser
import System.Console.CmdArgs
import Text.Megaparsec

data Eikyo
  = Compile {file :: FilePath}
  | Run {file :: FilePath}
  | Build
  deriving (Data, Typeable, Show, Eq)

compile = Compile {file = def &= typ "FILE" &= argPos 0} &= help "Compile the file"

run = Run {file = def &= typ "FILE" &= argPos 0} &= help "Run the file"

build = Build &= help "(Not yet done) Build the project"

mode =
  cmdArgsMode $
    modes [run, compile, build]
      &= help "Eikyo compiler"
      &= program "eikyo"
      &= summary "Eikyo v0.0\n"

dispatchCommands :: Eikyo -> IO ()
dispatchCommands eikyo_mode = do
  case eikyo_mode of
    Compile {file = app_file} -> do
      putStrLn $ "Parsing " ++ app_file ++ "..."
      contents <- T.pack <$> readFile app_file
      case runParser pModule app_file contents of
        Left bundle -> putStr (errorBundlePretty bundle)
        Right mod -> do
          putStrLn "Parsing done..."
          compileModule mod
    Run {file = app_file} -> do
      contents <- T.pack <$> readFile app_file
      case runParser pModule app_file contents of
        Left bundle -> putStr (errorBundlePretty bundle)
        Right mod -> do
          putStrLn "Parsing done..."
          runModule mod
    Build -> do
      putStrLn "Building"
