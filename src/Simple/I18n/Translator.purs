module Simple.I18n.Translator
  ( Translator
  , createTranslator
  , currentLang
  , setLang
  , label
  , translate
  ) where

import Prelude

import Data.Maybe (fromMaybe)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Foreign.Object (Object, fromHomogeneous, lookup)
import Prim.Row (class Cons)
import Record (get)
import Record.Extra (class SListToRowList, SList)
import Simple.I18n.Translation (Translation, toRecord)
import Type.Proxy (Proxy(..))
import Type.Row.Homogeneous (class Homogeneous)
import Type.RowList (class ListToRow)

-- | A type of translator.
newtype Translator (xs :: SList) = Translator
  { currentLang :: String
  , fallbackTranslation :: Translation xs
  , translations :: Object (Translation xs)
  }

instance showTranslator :: Show (Translator xs) where
  show (Translator r) = "(Translator " <> show r.currentLang <> ")"

-- | Create a `Translator` from a proxy as fallback language and a homogeneous record with `Translation` fields.
createTranslator
  :: forall fallbacklang xs r tail
   . IsSymbol fallbacklang
  => Homogeneous r (Translation xs)
  => Cons fallbacklang (Translation xs) tail r
  => Proxy fallbacklang
  -> Record r
  -> Translator xs
createTranslator flangP r = Translator
  { currentLang: reflectSymbol flangP
  , fallbackTranslation: get flangP r
  , translations: fromHomogeneous r
  }

-- | Get current language.
currentLang :: forall xs. Translator xs -> String
currentLang (Translator r) = r.currentLang

-- | Set language.
setLang :: forall xs. String -> Translator xs -> Translator xs
setLang lang (Translator r) =
  Translator r { currentLang = lang }

-- | A label for translation.
label :: forall label. Proxy label
label = Proxy

-- | Get a translated string of a passed label.
translate
  :: forall label xs rl r tail
   . IsSymbol label
  => ListToRow rl r
  => SListToRowList xs rl
  => Homogeneous r String
  => Cons label String tail r
  => Proxy label
  -> Translator xs
  -> String
translate proxy (Translator r) =
  get proxy $ (toRecord translation :: Record r)
  where
    translation =
      fromMaybe r.fallbackTranslation
        $ lookup r.currentLang r.translations
