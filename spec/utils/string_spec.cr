require "../spec_helper"

describe String do
  it "can find common substring" do
    s = "This is an apple tree."
    q = "I like apple more than banana."
    s.intersect(q).should eq " apple "
  end
end
