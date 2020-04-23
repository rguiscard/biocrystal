require "./spec_helper"

module Bio
  describe Codon do
    it "translate DNA to protein" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      Bio::StandardCodon.translate(seq).should eq "MACWPQLRLLLWKN*".downcase
    end
  end
end
