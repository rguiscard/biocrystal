require "./spec_helper"

module Bio
  describe Translation do
    it "translate from Bio::DNASeq to protein" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = seq.translate
      tr.nucleotide_seq.should eq "atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA"
      tr.amino_acid_seq.should eq "MACWPQLRLLLWKN*".downcase
    end

    it "translate with frameshift" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = seq.translate(frameshift: 3)
      tr.nucleotide_seq.should eq "atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA"
      tr.amino_acid_seq.should eq "ACWPQLRLLLWKN*".downcase
    end

    it "reverse translate from Bio::DNASeq to protein" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = seq.translate(reverse: true)
      tr.nucleotide_seq.should eq "atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA"
      tr.amino_acid_seq.should eq "SVLPQQQPQLRPTSH".downcase
    end

    it "reverse translate with frameshift" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = seq.translate(frameshift: 3, reverse: true)
      tr.nucleotide_seq.should eq "atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA"
      tr.amino_acid_seq.should eq "VLPQQQPQLRPTSH".downcase
    end
  end
end
