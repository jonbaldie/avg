-- Self-contained mutation test module for MuCheck.
-- parseArgs is duplicated here (not imported from Main.hs) because MuCheck
-- uses hint to interpret each mutated copy of this file in isolation, so
-- all code under test must live in the same module as the test functions.
module Spec where

import Test.MuCheck.TestAdapter.AssertCheck (assertCheck, AssertStatus)
import Text.Read (readMaybe)

parseArgs :: [String] -> Either String (String, Int)
parseArgs [command, rawIterations] = do
  iterations <-
    case readMaybe rawIterations of
      Nothing -> Left $ "Invalid iteration count: " ++ rawIterations
      Just n
        | n <= 0 -> Left "Iteration count must be a positive integer"
        | otherwise -> Right n
  Right (command, iterations)
parseArgs _ = Left "Usage: avg \"<command>\" <iterations>"

{-# ANN noArgs "Test" #-}
noArgs :: AssertStatus
noArgs = assertCheck $ parseArgs [] == Left "Usage: avg \"<command>\" <iterations>"

{-# ANN tooFewArgs "Test" #-}
tooFewArgs :: AssertStatus
tooFewArgs = assertCheck $ parseArgs ["cmd"] == Left "Usage: avg \"<command>\" <iterations>"

{-# ANN tooManyArgs "Test" #-}
tooManyArgs :: AssertStatus
tooManyArgs = assertCheck $ parseArgs ["a", "b", "c"] == Left "Usage: avg \"<command>\" <iterations>"

{-# ANN validArgs "Test" #-}
validArgs :: AssertStatus
validArgs = assertCheck $ parseArgs ["cmd", "5"] == Right ("cmd", 5)

{-# ANN invalidIterCount "Test" #-}
invalidIterCount :: AssertStatus
invalidIterCount = assertCheck $ parseArgs ["cmd", "nope"] == Left "Invalid iteration count: nope"

{-# ANN zeroIterCount "Test" #-}
zeroIterCount :: AssertStatus
zeroIterCount = assertCheck $ parseArgs ["cmd", "0"] == Left "Iteration count must be a positive integer"

{-# ANN negIterCount "Test" #-}
negIterCount :: AssertStatus
negIterCount = assertCheck $ parseArgs ["cmd", "-2"] == Left "Iteration count must be a positive integer"
