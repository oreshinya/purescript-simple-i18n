module Test.Main where

import Prelude

import Effect (Effect)
import Record.Extra (type (:::), SNil)
import Simple.I18n.Translation (Translation, fromRecord)
import Simple.I18n.Translator (Translator, createTranslator, currentLang, label, setLang, translate)
import Type.Proxy (Proxy(..))
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

type Labels =
    ( "apple"
  ::: "banana"
  ::: "grape"
  ::: SNil
    )

en :: Translation Labels
en = fromRecord
  { apple: "Apple"
  , banana: "Banana"
  , grape: "Grape"
  }

ja :: Translation Labels
ja = fromRecord
  { apple: "りんご"
  , banana: "バナナ"
  , grape: "ぶどう"
  }

translator :: Translator Labels
translator = createTranslator (Proxy :: _ "en") { en, ja }

main :: Effect Unit
main = runTest do
  suite "Translate" do
    test "show" do
      Assert.equal "(Translator \"en\")" $ show translator
      let translator' = translator # setLang "ja"
      Assert.equal "(Translator \"ja\")" $ show translator'
    test "Default lang" do
      Assert.equal "en" $ translator # currentLang
      Assert.equal "Apple" $ translator # translate (label :: _ "apple")
      Assert.equal "Banana" $ translator # translate (label :: _ "banana")
      Assert.equal "Grape" $ translator # translate (label :: _ "grape")
    test "After set lang" do
      let translator' = translator # setLang "ja"
      Assert.equal "ja" $ translator' # currentLang
      Assert.equal "りんご" $ translator' # translate (label :: _ "apple")
      Assert.equal "バナナ" $ translator' # translate (label :: _ "banana")
      Assert.equal "ぶどう" $ translator' # translate (label :: _ "grape")
    test "Fallback" do
      let translator' = translator # setLang "unknown"
      Assert.equal "unknown" $ translator' # currentLang
      Assert.equal "Apple" $ translator' # translate (label :: _ "apple")
      Assert.equal "Banana" $ translator' # translate (label :: _ "banana")
      Assert.equal "Grape" $ translator' # translate (label :: _ "grape")
