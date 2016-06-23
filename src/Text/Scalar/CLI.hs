{-# LANGUAGE NamedFieldPuns #-}
module Text.Scalar.CLI where

import System.IO (hPutStr, hPutStrLn, hPrint, stderr)

import Text.Scalar
import Text.Pandoc.Options
import Text.Pandoc.Readers.Scalar
import Text.Pandoc (Pandoc, writeJSON)

import qualified Data.Text as T
import Options.Applicative

data CliArgs = CliArgs
  { maybePath :: Maybe String
  , inputFile :: String
  }

cliArgs :: Parser CliArgs
cliArgs = CliArgs
  <$> (optional $ strOption ( short 'p'
                           <> metavar "PATH"
                           <> help "The Scalar page with the path to follow (defaults to index)"))
  <*> argument str (metavar "INPUT")

run :: CliArgs -> IO ()
run (CliArgs {inputFile, maybePath}) = do
  let orderBy = case maybePath of
        Just path -> Path $ T.pack path
        Nothing -> IndexPath
      scalarOpts = def {orderPagesBy = orderBy}
  pandoc <- case inputFile of
    "-" -> parseStdin scalarOpts
    _ -> readAndParseScalarFile inputFile scalarOpts
  case pandoc of
    Left err -> hPutStr stderr "Error: " >> case err of
      ScalarError strErr -> hPutStrLn stderr strErr
      _ -> hPrint stderr err
    Right doc -> putStrLn $ writeJSON def doc

parseStdin :: ScalarOptions -> IO (ScalarM Pandoc)
parseStdin opts = getContents >>= return . readScalar def opts

main :: IO ()
main = execParser opts >>= run
  where
    opts = info (helper <*> cliArgs)
      ( fullDesc
     <> progDesc "Reads INPUT and outputs pandoc's native format to stdout"
     <> header "scalar-convert - export ANVC Scalar RDF/XML with pandoc" )
