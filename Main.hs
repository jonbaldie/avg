import System.Environment (getArgs)
import System.Process (system)
import Data.Time.Clock (diffUTCTime, getCurrentTime)

main :: IO ()
main = getArgs >>= \ (command:times:_) ->
  let n = read times :: Int
  in getCurrentTime >>= \ startTime ->
    mapM_ (\_ -> system command) [1..n] >>
    getCurrentTime >>= \ endTime ->
    let totalElapsedTime = diffUTCTime endTime startTime
        averageElapsedTime = totalElapsedTime / fromIntegral n
    in putStrLn $ "Average elapsed time: " ++ show averageElapsedTime

