module Main where

import Lib (experiment, Experiment(..), Mode(..))

main :: IO ()
main =
  -- experiment ForkIO (ThrowError 3)
  -- experiment WithAsync (ThrowError 3)
  -- experiment WithLinkedAsync (ThrowError 3)
  experiment ForkIO Infinite
