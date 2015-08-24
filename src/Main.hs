{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
module Main where

import Turtle
import Text.Shakespeare.Text
import System.Environment
import Data.Text.IO
import Prelude hiding (putStrLn)

main = do
    origPath <- getExecutablePath
    let regFile = [sbt|REGEDIT4
                      |
                      |[HKEY_CLASSES_ROOT\magnet]
                      |"URL Protocol"=""
                      |
                      |[HKEY_CLASSES_ROOT\magnet\shell]
                      |
                      |[HKEY_CLASSES_ROOT\magnet\shell\open]
                      |
                      |[HKEY_CLASSES_ROOT\magnet\shell\open\command]
                      |@="\"#{origPath}\" %1"
                      |]
    putStrLn regFile
