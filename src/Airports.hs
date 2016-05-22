{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Airports where

import qualified Data.ByteString.Lazy as BL
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE

import Data.Aeson as A hiding (json)
import GHC.Generics
data Airport = Airport { code    :: T.Text
                       , name    :: T.Text
                       , country :: T.Text
                       } deriving (Show, Generic)

instance ToJSON Airport where
  toJSON a = object [ "name"    .= name a
                    , "code"    .= code a
                    , "country" .= country a]

instance FromJSON Airport where
    parseJSON = withObject "airport" $ \o ->
        Airport <$> o .: "code"
                <*> o .: "name"
                <*> o .: "country"


decodeAirports getTerms parseTerm = do
    x <- eitherDecode <$> getTerms
    case x of
        Left  err   -> return []
        Right terms -> return $ map parseTerm terms

getAirportsFromFile = BL.readFile "src/airports.json"

parseAirport a@(Airport code name country) = (TE.encodeUtf8 name, a)