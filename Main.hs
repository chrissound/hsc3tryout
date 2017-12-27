{-# OPTIONS -Wno-unused-local-binds #-}
{-# OPTIONS -Wno-unused-imports #-}
module Main where

--import Sound.SC3.Server.Command.Generic
--import qualified Sound.SC3.Server.Command.Generic as Generic {- hsc3 -}
--import qualified Sound.SC3.Server.Command.Completion as CM {- hsc3 -}
import Sound.SC3 {- hsc3 -}
import Sound.OSC.Transport.Monad
import Sound.SC3.Server.Command.Generic (withCM)
--import Control.Monad.IO.Class
import Control.Concurrent
import Sound.OSC.Packet

myUgen :: UGen
myUgen = sinOsc AR 460 0 * (sinOsc KR 1 0)

my_s_new :: String -> Synth_Id -> AddAction -> Group_Id -> [(String,Double)] -> Message
my_s_new = s_new

main :: IO ()
main = do
  withSC3 reset
  let s1m = d_recv (synthdef "sin1" $ out 0 myUgen)
  let s2m = d_recv (synthdef "sin2" $ out 1 myUgen)
  withSC3 . sendMessage $ (withCM s1m $ my_s_new "sin1" (-1) AddToTail 0 [])
  withSC3 . sendMessage $ (withCM s2m $ my_s_new "sin2" (-1) AddToTail 1 [])
  print "Completed"
