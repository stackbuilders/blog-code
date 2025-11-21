{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module PackageInfo_hasktorch_skeleton (
    name,
    version,
    synopsis,
    copyright,
    homepage,
  ) where

import Data.Version (Version(..))
import Prelude

name :: String
name = "hasktorch_skeleton"
version :: Version
version = Version [0,0,0,0] []

synopsis :: String
synopsis = "See README for more info"
copyright :: String
copyright = "2020 The Hasktorch Team"
homepage :: String
homepage = ""
