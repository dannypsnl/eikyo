module Main where

import qualified Data.Text as T
import Eikyo.Command
import Eikyo.Compiler
import Eikyo.Parser
import System.Console.CmdArgs
import Text.Megaparsec

main :: IO ()
main = do
  eikyo_mode <- cmdArgsRun mode
  case eikyo_mode of
    Compile {file = app_file} -> do
      putStrLn $ "Compiling " ++ app_file ++ "..."
      contents <- T.pack <$> readFile app_file
      case runParser pModule app_file contents of
        Left bundle -> putStr (errorBundlePretty bundle)
        Right mod -> do
          putStrLn "Parsing done..."
          compile mod
          putStrLn "Compile done..."
    Build -> do
      putStrLn "Building"
