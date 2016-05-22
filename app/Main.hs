{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Network.Wai.Middleware.Static
import Control.Monad.IO.Class

import Airports
import AutoComplete

main = scotty 3000 mainApp

mainApp = do
  middleware $ staticPolicy (noDots >-> addBase "static")
  get "/" renderMain
  get "/query/:word" renderSuggestions

renderMain = do
  setHeader "Content-Type" "text/html"
  file "static/index.html"

renderSuggestions = do
  word  <- param "word"
  terms <- liftIO $ decodeAirports getAirportsFromFile parseAirport
  json $ getSuggestions word terms
