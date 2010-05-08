{-# OPTIONS_GHC -XTemplateHaskell #-}
module Berp.Base.StdTypes.String (string, stringClass, emptyString) where

import Berp.Base.Prims (primitive)
import Berp.Base.Monad (constantIO)
import Berp.Base.Prims (binOp)
import Berp.Base.SemanticTypes (Eval, Procedure, Object (..))
import Berp.Base.Identity (newIdentity)
import {-# SOURCE #-} Berp.Base.StdTypes.Bool (bool)
import Berp.Base.Attributes (mkAttributes)
import Berp.Base.StdNames
import {-# SOURCE #-} Berp.Base.StdTypes.Type (newType)
import {-# SOURCE #-} Berp.Base.StdTypes.ObjectBase (objectBase)

emptyString :: Object
emptyString = string "" 

{-# NOINLINE string #-}
string :: String -> Object
string str = constantIO $ do 
   identity <- newIdentity
   return $ 
      String
      { object_identity = identity
      , object_string = str 
      }

{-# NOINLINE stringClass #-}
stringClass :: Object
stringClass = constantIO $ do
   identity <- newIdentity
   dict <- attributes
   newType [string "str", objectBase, dict]

attributes :: IO Object 
attributes = mkAttributes 
   [ (eqName, eq)
   , (strName, str)
   , (addName, add)
   ]
        
eq :: Object 
eq = primitive 2 $ \[x,y] -> binOp x y object_string (==) (Prelude.return . bool)

str :: Object 
str = primitive 1 $ \[x] -> Prelude.return x 

add :: Object 
add = primitive 2 $ \[x,y] -> binOp x y object_string (++) (Prelude.return . string)
