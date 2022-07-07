module Eikyo.Compiler (compile) where

import Eikyo.Ast

compile :: Module -> IO ()
compile mod = do
  putStrLn "Compiling..."
  putStrLn $ show $ mod
  putStrLn "Compiled."
