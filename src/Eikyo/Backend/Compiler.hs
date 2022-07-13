module Eikyo.Backend.Compiler (compileModule) where

import Eikyo.Ast

compileModule :: Module -> IO ()
compileModule mod = do
  putStrLn "Compiling..."
  putStrLn $ show $ mod
  putStrLn "Compiled."
