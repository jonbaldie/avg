import Data.Time.Clock (diffUTCTime, getCurrentTime)
import System.Environment (getArgs)
import System.Exit (ExitCode (ExitFailure, ExitSuccess), exitFailure)
import System.Process (system)
import Text.Read (readMaybe)

main :: IO ()
main = do
  args <- getArgs
  case parseArgs args of
    Left err -> dieWith err
    Right (command, iterations) -> runAverage command iterations

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

runAverage :: String -> Int -> IO ()
runAverage command iterations = do
  startTime <- getCurrentTime
  runIterations command iterations
  endTime <- getCurrentTime
  let totalElapsedTime = diffUTCTime endTime startTime
      averageElapsedTime = totalElapsedTime / fromIntegral iterations
  putStrLn $ "Average elapsed time: " ++ show averageElapsedTime

runIterations :: String -> Int -> IO ()
runIterations command iterations = mapM_ runOnce [1 .. iterations]
  where
    runOnce _ = do
      exitCode <- system command
      case exitCode of
        ExitSuccess -> pure ()
        ExitFailure code -> dieWith $ "Command failed with exit code " ++ show code

dieWith :: String -> IO a
dieWith message = do
  putStrLn message
  exitFailure
