require "./spec_helper"

module Bio
  describe Symbol do

    it "has DNA_T" do
      Bio::DNA.a.should eq :"DNA_A"
    end

  end
end
