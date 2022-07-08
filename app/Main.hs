module Main where

import Eikyo.Command
import System.Console.CmdArgs

main :: IO ()
main = cmdArgsRun mode >>= dispatchCommands
