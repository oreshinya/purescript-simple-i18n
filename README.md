# purescript-simple-i18n

[![Latest release](http://img.shields.io/github/release/oreshinya/purescript-simple-i18n.svg)](https://github.com/oreshinya/purescript-simple-i18n/releases)

Type-safe internationalization utilities.

## Installation

### Bower

```
$ bower install purescript-simple-i18n
```

### Spago

```
$ spago install simple-i18n
```

## Usage

### Define labels

You can define labels **with typelevel string list** for translation.

This force you to translate all labels **without excess and deficiently**.

**NOTE: Labels should be ordered alphabetically.**

```purescript
import Record.Extra (type (:::), SNil)

-- Symbols should be in alphabetic order.
type Labels =
    ( "apple"
  ::: "banana"
  ::: "grape"
  ::: SNil
    )
```

### Define translations

You can define translations with `Simple.I18n.Translation` module.

```purescript
import Simple.I18n.Translation (Translation, fromRecord)

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
```

### Create translator

Next step is creating translator with `Simple.I18n.Translator` module.

Pass fallback language and translations to `createTranslator`.

```purescript
import Simple.I18n.Translator (Translator, createTranslator, label, setLang, translate)

translator :: Translator Labels
translator =
  createTranslator
    (SProxy :: _ "en") -- Fallback language (and default language)
    { en, ja } -- Translations
```

### Change language setting

You can set language with `setLang`.

```purescript
import Prelude

import Simple.I18n.Translator (Translator, createTranslator, label, setLang, translate)

main :: Effect Unit
main = do
  let translator' = translator # setLang "ja"
  -- some codes
```

You might think "Why can `setLang` receive `String` instead of `SProxy`?".

The reason is that we get language setting from outside of PureScript like `navigator.language`, `localStorage`, `subdomain`, `path`, `query parameter`, or others in most cases.

So `String` is enough.

### Translate

You can get translation type-safely.

```purescript
import Prelude

import Simple.I18n.Translator (Translator, createTranslator, label, setLang, translate)

translator :: Translator Labels
translator =
  createTranslator
    (SProxy :: _ "en") -- Fallback language (and default language)
    { en, ja } -- Translations

main :: Effect Unit
main = do
  log $ translator # translate (label :: _ "apple") -- "Apple"
  let translator' = translator # setLang "ja"
  log $ translator' # translate (label :: _ "apple") -- "りんご"
  -- some codes
```

## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-simple-i18n).

## LICENSE

MIT
