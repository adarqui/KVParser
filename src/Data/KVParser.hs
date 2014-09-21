{-# LANGUAGE OverloadedStrings #-}
module Data.KVParser (
 kv'parse,
 kv'to'object
) where

import Data.Aeson
import Data.Scientific
import Control.Applicative
import Data.Attoparsec.Char8
import qualified Data.ByteString.Char8 as C
import qualified Data.Text as T
import qualified Data.HashMap as H
import Prelude hiding (takeWhile)

type KV = (String, Value)

anyDigit :: Parser Char
anyDigit = satisfy isDigit

key = do
 (satisfy isAlpha_ascii <|> satisfy isDigit)

kv'key = do
 try (manyTill key (char '='))

kv'types = do
 k <- kv'key
 v <- (kv'str <|> kv'num <|> kv'bool)
 return (k, v)

kv'str = do
 v <- (kv'str'quotes <|> kv'str'noquotes)
 return $ String $ T.pack v

kv'str'noquotes = do
 v <- try (manyTill anyChar (satisfy isSpace))
 return v

kv'str'quotes = do
 v <- try (char '"' >> manyTill anyChar (char '"'))
 return v

kv'num = do
 v <- try (manyTill anyDigit (satisfy isSpace))
 return $ Number $ (read v :: Scientific)

kv'bool = do
 kv'bool'true <|> kv'bool'false

kv'bool'true = do
 v <- try (stringCI "true")
 return $ Bool True

kv'bool'false = do
 v <- try (stringCI "false")
 return $ Bool False

kv'parse :: C.ByteString -> [KV]
kv'parse = kv'parse'helper []

kv'parse'helper :: [KV] -> C.ByteString -> [KV]
kv'parse'helper v s =
 case (C.null s) of
  True -> v
  _ -> let k = parse (try kv'types) s in
   case k of
    (Done i r) -> kv'parse'helper (v ++ [r]) i
    (Partial f) ->case (f "") of
     (Done i r) -> kv'parse'helper (v ++ [r]) i
     _ -> v
    _ -> v

-- Convert a list of key/value elements into a hashmap, for aeson
kv'to'object kv = H.fromList kv
