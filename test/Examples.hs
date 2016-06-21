{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Examples where

import Data.RDF
import Data.Map (Map)
import qualified Data.Map as Map
import qualified Data.Text as T
import Data.FileEmbed
import qualified Data.ByteString.Char8 as BS

examples :: [(FilePath, BS.ByteString)]
examples = $(embedDir "test/examples")

getExample :: FilePath -> String
getExample ex = case (lookup ex examples) of
  Just s -> BS.unpack s
  Nothing -> error $ ex ++ " not found"

singlePage :: TriplesList
singlePage = mkRdf triples baseurl prefixes
  where baseurl = Just (BaseUrl "")
        prefixes = PrefixMappings $ Map.fromList [ ("dcterms", "http://purl.org/dc/terms/")
                                                 , ("ov", "http://open.vocab.org/terms/")
                                                 , ("prov", "http://www.w3.org/ns/prov#")
                                                 , ("rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
                                                 , ("scalar", "http://scalar.usc.edu/2012/01/scalar-ns#")
                                                 , ("sioc", "http://rdfs.org/sioc/ns#") ]
        triples = [ Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index") (UNode "scalar:citation") (LNode (PlainL "method=instancesof/content;methodNumNodes=1;"))
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index") (UNode "dcterms:hasVersion") (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1")
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index") (UNode "scalar:version") (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1"),Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index") (UNode "scalar:urn") (UNode "urn:scalar:content:297474")
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index") (UNode "dcterms:created") (LNode (PlainL "2016-06-20T12:41:52-07:00"))
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index") (UNode "prov:wasAttributedTo") (UNode "http://scalar.usc.edu/works/scalar-export-test/users/11802")
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index") (UNode "scalar:isLive") (LNode (PlainL "1"))
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index") (UNode "rdf:type") (UNode "http://scalar.usc.edu/2012/01/scalar-ns#Composite")
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1") (UNode "rdf:type") (UNode "http://scalar.usc.edu/2012/01/scalar-ns#Version")
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1") (UNode "dcterms:isVersionOf") (UNode "http://scalar.usc.edu/works/scalar-export-test/index")
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1") (UNode "scalar:urn") (UNode "urn:scalar:version:791282")
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1") (UNode "dcterms:created") (LNode (PlainL "2016-06-20T12:41:52-07:00"))
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1") (UNode "prov:wasAttributedTo") (UNode "http://scalar.usc.edu/works/scalar-export-test/users/11802")
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1") (UNode "scalar:defaultView") (LNode (PlainL "plain"))
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1") (UNode "sioc:content") (LNode (PlainL "This is a test book for the <a href=\"https://github.com/corajr/scalar-export\">scalar-export</a>&nbsp;package. It contains different formatting, such as <strong>bold</strong> and&nbsp;<em>italics</em>."))
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1") (UNode "dcterms:title") (LNode (PlainL "Introduction"))
                  , Triple (UNode "http://scalar.usc.edu/works/scalar-export-test/index.1") (UNode "ov:versionnumber") (LNode (PlainL "1"))
                  ]

singlePageContent :: T.Text
singlePageContent = "This is a test book for the <a href=\"https://github.com/corajr/scalar-export\">scalar-export</a>&nbsp;package. It contains different formatting, such as <strong>bold</strong> and&nbsp;<em>italics</em>."

