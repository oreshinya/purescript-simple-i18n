module Simple.I18n.Translation
  ( Translation
  , fromRecord
  , toRecord
  ) where

import Prelude

import Foreign.Object (Object, fromHomogeneous)
import Prim.RowList (class RowToList)
import Record.Extra (class SListToRowList, SList)
import Type.Row.Homogeneous (class Homogeneous)
import Type.RowList (class ListToRow)
import Unsafe.Coerce (unsafeCoerce)

-- | A representation of translated words.
-- |
-- | `SList` parameter is a label list.
-- |
-- | **NOTE: Labels are ordered alphabetically.**
newtype Translation (xs :: SList) = Translation (Object String)

-- | Create a `Translation` from a homogeneous record with `String` fields.
fromRecord
  :: forall r rl xs
   . RowToList r rl
  => SListToRowList xs rl
  => Homogeneous r String
  => Record r
  -> Translation xs
fromRecord = Translation <<< fromHomogeneous

toRecord
  :: forall rl r xs
   . ListToRow rl r
  => SListToRowList xs rl
  => Homogeneous r String
  => Translation xs
  -> Record r
toRecord (Translation obj) = unsafeCoerce obj
