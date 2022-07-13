module Eikyo.Backend.Interpreter (runModule) where

import Eikyo.Ast

runModule :: Module -> IO ()
runModule mod = do
  putStrLn $ show $ mod
  putStrLn "Running..."
