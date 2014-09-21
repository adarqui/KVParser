{-# LANGUAGE OverloadedStrings #-}
import Data.KVParser
import Control.Monad
import System.Environment
import qualified Data.ByteString.Char8 as C

parseFile filename = do
 v <- C.readFile filename
 let m = map kv'parse $ C.lines v
 forM_ m print
 
main :: IO ()
main = do
 argv <- getArgs
 case argv of
  (filename:[]) -> parseFile filename
  _ -> error "usage: ./parse <filename>"
