{-# OPTIONS -Wno-unused-local-binds #-}
module Main where

--import Sound.SC3.Server.Command.Generic
--import qualified Sound.SC3.Server.Command.Generic as Generic {- hsc3 -}
--import qualified Sound.SC3.Server.Command.Completion as CM {- hsc3 -}
import Sound.SC3 {- hsc3 -}
import Sound.OSC.Transport.Monad
import Sound.SC3.Server.Command.Generic (withCM)
--import Control.Monad.IO.Class

ss :: UGen -> UGen
ss f = sinOsc AR f 0 * 0.1

auditionBoth :: UGen -> IO ()
auditionBoth x = do
  audition (out 0 x)
  audition (out 1 x)

main :: IO ()
main = do
  withSC3 reset
  -- withSC3 $ do
  --   sendMessage (g_new [(1, AddToTail, 0)])
  --   sendMessage (g_new [(2, AddToTail, 0)])
  --let s = synthdef "test" ((sinOscFB AR 200 0.1) * (sinOsc KR 4 0))
  --auditionBoth $ (sinOscFB AR 200 0.1) * (sinOsc KR 4 0)
  -- auditionBoth $ (sinOscFB AR 100 0.1) * (sinOsc KR 2 0)
  -- auditionBoth $ (sinOscFB AR 400 0.5) * (sinOsc KR 1 0)
  --playSynthdef (1 :: Node_Id, AddToTail, 0, [("", 0.0)]) s
  let g = out 0 (sinOsc AR 460 0 * (sinOsc KR 1 0))
  let g2 = out 1 (sinOsc AR 460 0 * (sinOsc KR 4 0))
  let m = d_recv (synthdef "sin" g)
  let m2 = d_recv (synthdef "sin2" g2)
  let cm = s_new "sin" 100 AddToTail 1 []
  let cm2 = s_new "sin2" 100 AddToTail 1 []
  --print m
  withSC3 (sendMessage (withCM m cm))
  withSC3 (sendMessage (withCM m2 cm2))
  putStrLn "Done"
