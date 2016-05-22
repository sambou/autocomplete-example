module AutoComplete where

import Data.Trie as T (toList, fromList, submap)

getSuggestions word terms = fmap snd getMatches
    where
        getMatches = toList $ submap word makeTrie
        makeTrie   = fromList terms