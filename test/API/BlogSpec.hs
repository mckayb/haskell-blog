module API.BlogSpec where

import Prelude (IO, (+), ($))
import Test.Hspec (Spec, hspec, describe, context, it, shouldBe)

spec :: Spec
spec =
  describe "Server" $ do
    context "Endpoint A" $
      it "Should return stuff" $
        1 + 2 `shouldBe` 3
    context "Endpoint B" $
      it "Should return more stuff" $
        2 + 3 `shouldBe` 5

main :: IO ()
main = hspec spec