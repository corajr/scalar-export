module Text.Scalar.Types ( URI
                         , VersionURI
                         , unVersionURI
                         , mkVersionURI
                         , Page(..)
                         , Scalar(..)
                         ) where

import qualified Data.Text as T

type URI = T.Text

newtype VersionURI = VersionURI { unVersionURI :: URI }
  deriving (Eq, Show)

mkVersionURI :: URI -> VersionURI
mkVersionURI = VersionURI

data Page = Page
  { pageVersionURI :: VersionURI
  , pageContent :: T.Text
  } deriving (Eq, Show)

data Scalar = Scalar
  { pages :: [Page]
  } deriving (Eq, Show)