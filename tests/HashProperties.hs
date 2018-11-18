{-# LANGUAGE OverloadedStrings #-}

module HashProperties (
  testHash
  ) where

import           Util
import           Crypto.Saltine.Core.Hash

import qualified Data.ByteString                      as S
import           Test.Framework.Providers.QuickCheck2
import           Test.Framework
import           Test.QuickCheck

testHash :: Test
testHash = buildTest $ do
  shKey <- newShorthashKey
  shKey2 <- newShorthashKey

  return $ testGroup "...Internal.Hash" [

    testProperty "No two hashes are alike"
    $ \(Message bs1, Message bs2) -> bs1 /= bs2 ==> hash bs1 /= hash bs2,

    testProperty "Hash of empty ByteString is correct"
    $ \(Message bs) -> (bs == S.empty) ==> hash bs == (read hashEmptyBS :: S.ByteString),

    testProperty "No two shorthashes are alike"
    $ \(Message bs1, Message bs2) -> bs1 /= bs2 ==> shorthash shKey bs1 /= shorthash shKey bs2,

    testProperty "Different keys produce different shorthashes"
    $ \(Message bs) -> shorthash shKey bs /= shorthash shKey2 bs

    ]

  where
    hashEmptyBS = "\"\207\131\225\&5~\239\184\189\241T(P\214m\128\a\214 \228\ENQ\vW\NAK\220\131\244\169!\211l\233\206G\208\209<]\133\242\176\255\131\CAN\210\135~\236/c\185\&1\189GAz\129\165\&82z\249'\218>\""
