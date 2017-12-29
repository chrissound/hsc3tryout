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
import  Music.Pitch (a, b, c)


myUgen :: UGen -> UGen
myUgen f = sinOsc
  AR
  (
    (sinOsc KR 0.25 0)
    * ((sinOsc KR 12 0) * 55)
    + f)
  0
  * (sinOsc KR 4 0)

my_s_new :: String -> Synth_Id -> AddAction -> Group_Id -> [(String,Double)] -> Message
my_s_new = s_new

main :: IO ()
main = do
  print (a :: Pitch)
  print "Started"
  withSC3 reset
  let s1m = d_recv (synthdef "sin1" $ out 0 (myUgen 880))
  let s2m = d_recv (synthdef "sin2" $ out 1 (myUgen 820))
  print "Part 1"
  withSC3 . sendMessage $ (withCM s1m $ my_s_new "sin1" (-1) AddToTail 1 [])
  withSC3 . sendMessage $ (withCM s2m $ my_s_new "sin2" (-1) AddToTail 1 [])
  threadDelay 500000
  print "Part 2"
  withSC3 . sendMessage $ g_freeAll [1]
  threadDelay 500000
  print "Part 3"
  withSC3 . sendMessage $ (withCM s1m $ my_s_new "sin1" (-1) AddToTail 1 [])
  withSC3 . sendMessage $ (withCM s2m $ my_s_new "sin2" (-1) AddToTail 1 [])
  threadDelay 500000
  print "Part 4"
  withSC3 . sendMessage $ g_freeAll [1]
  threadDelay 500000
  print "Part 3"
  withSC3 . sendMessage $ (withCM s1m $ my_s_new "sin1" (-1) AddToTail 1 [])
  withSC3 . sendMessage $ (withCM s2m $ my_s_new "sin2" (-1) AddToTail 1 [])
  threadDelay 500000
  print "Part 4"
  withSC3 . sendMessage $ g_freeAll [1]
  threadDelay 1000000
  print "Completed"
