module Lib
  ( experiment
  , Experiment(..)
  , Mode(..)
  ) where

import Control.Exception.Base

-- https://hackage.haskell.org/package/base-4.15.0.0/docs/Control-Concurrent.html
import Control.Concurrent (forkIO, killThread, threadDelay, myThreadId)

-- https://hackage.haskell.org/package/async-2.2.3/docs/Control-Concurrent-Async.html
import Control.Concurrent.Async (link, withAsync)

import GHC.Exception (throw)

data ThreadException = ThreadException
    deriving Show

instance Exception ThreadException

withLinkedAsync_ :: IO a -> IO b -> IO b
withLinkedAsync_ f g = withAsync f $ \h -> link h >> g

childThread :: Mode -> Int -> IO ()
childThread m x = do
  threadDelay 1000000 -- wait one second

  threadId <- myThreadId
  print $ "childThread is alive, pid " ++ show threadId

  case m of
    Infinite -> pure ()
    ThrowError count -> if x > count then throw ThreadException else pure ()

  childThread m (x + 1)

loop :: IO ()
loop = do
  threadDelay 1000000
  threadId <- myThreadId
  print $ "mainThread is alive, pid " ++ show threadId
  loop

data Experiment
  = ForkIO
  | WithAsync
  | WithLinkedAsync

data Mode
  = Infinite
  | ThrowError Int

experiment :: Experiment -> Mode -> IO ()
experiment e m =
  case e of
    ForkIO -> do
      _ <- forkIO $ childThread m 0
      loop
    WithAsync -> withAsync (childThread m 0) $ \_ -> loop
    WithLinkedAsync -> withLinkedAsync_ (childThread m 0) $ loop
