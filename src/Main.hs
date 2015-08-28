{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
module Main where

import Turtle
import System.Environment
import Data.Text hiding (empty, map)
import Data.Text.IO
import Prelude hiding (putStrLn, unlines)
import System.Win32.Registry
import Control.Monad
import Control.Exception
import Control.Concurrent

main = do
    origPath <- getExecutablePath

    -- TODO escalate to Admin first via UAC
    -- TODO use Turtle's "format" instead?
    -- TODO clean up this exception handling
    r <- (try $ do
            h_magnet <- regCreateKey hKEY_CLASSES_ROOT "magnet"
            regSetStringValue h_magnet "URL Protocol" ""
            h_shell <- regCreateKey h_magnet "shell"
            h_open <- regCreateKey h_shell "open"
            regSetValue h_open "command" $ "\"" <> origPath <> "\" %*"
            h_command <- regCreateKey h_open "command"
            putStrLn "reg setup succeeded"
        ) :: IO (Either SomeException ())

    args <- getArgs >>= return . map pack

    path <- getEnv "PATH"
    setEnv "PATH" $ path <> ";/Program Files (x86)/PuTTY"

    shell "plink keb@mullvad \"cat | xargs -l transmission-remote -a\"" $ (return . unlines) args
    --threadDelay 5000000

