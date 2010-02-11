import Text.RegExp

import System        ( getArgs )
import System.Random ( randomRIO )

evilRegExp :: Int -> RegExp Char
evilRegExp n = foldr (.*.) epsilon $ replicate n (epsilon.+.a) ++ replicate n a
 where a = symbol 'a'

regExp :: Int -> RegExp Char
regExp n = star aOrB .*. symbol 'a'
       .*. foldr (.*.) epsilon (replicate n aOrB)
       .*. symbol 'a' .*. star aOrB
 where aOrB = symbol 'a' .+. symbol 'b'

aNbN :: RegExp Char
aNbN = epsilon .+. (symbol 'a' .*. aNbN .*. symbol 'b')
 where
  r .*. s = Labeled (isEmpty r && isEmpty s) Inactive (r:*:s)
  r .+. s = Labeled (isEmpty r || isEmpty s) Inactive (r:+:s)

aNbNcN :: RegExp Char
aNbNcN = epsilon .+. abc 1
 where
  abc n   = symbol 'a' .*. (pow 'b' n .*. pow 'c' n .+. abc (n+1))
  pow a n = foldr (.*.) epsilon (replicate n (symbol a))

  r .*. s = Labeled (isEmpty r && isEmpty s) Inactive (r:*:s)
  r .+. s = Labeled (isEmpty r || isEmpty s) Inactive (r:+:s)

main = do -- n <- (read.head) `fmap` getArgs
          s <- head `fmap` getArgs

          print $ accept aNbNcN s

--           s <- randomAB (n*n)
--           putStrLn s
--           mapM_ print $ accepting (regExp n) s
--           print $ accept (regExp n) s

--           mapM_ print $ accepting (evilRegExp n) (replicate (2*n) 'a')
--           print $ accept (evilRegExp n) (replicate (2*n) 'a')

randomAB :: Int -> IO String
randomAB 0 = return ""
randomAB n = do c <- randomRIO ('a','b')
                s <- randomAB (n-1)
                return (c:s)

-- crashes for n > 357
-- sedTest n = do s <- randomAB (n*n) 
--                system $ "echo \""++s++"\" | sed s/"
--                      ++ "\\(a\\|b\\)*a" ++ concat (replicate n "\\(a\\|b\\)")
--                      ++ "a\\(a\\|b\\)*/x/ > /dev/null"
