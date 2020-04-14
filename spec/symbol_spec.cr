require "./spec_helper"

module Bio
  describe Symbol do

    it "has DNA_T" do
      Bio::DNA.alphabet('A').should eq :"DNA_A"
    end

    it "has not DNA_U" do
      Bio::DNA.alphabet('U').should be_nil
    end

  end
end
