require "./spec_helper"
require "spec"

include Day4

describe Day4 do
  describe "is_accessible" do
    example = [
      "..@",
      "@@@",
      "@@@",
    ]

    it "Finds accessible indexes" do
      is_accessible(example, 0, 0).should be_true
      is_accessible(example, 1, 1).should be_false
      is_accessible(example, 2, 1).should be_false
    end
  end
end
