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
      tr = seq.translate(direction: Bio::TranslationDirection::Reverse)
      tr.nucleotide_seq.should eq "atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA"
      tr.amino_acid_seq.should eq "SVLPQQQPQLRPTSH".downcase
    end

    it "reverse translate with frameshift" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = seq.translate(frameshift: 3, direction: Bio::TranslationDirection::Reverse)
      tr.nucleotide_seq.should eq "atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA"
      tr.amino_acid_seq.should eq "VLPQQQPQLRPTSH".downcase
    end

    it "display all possible translation" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = Bio::Translation.new(seq)
      tr.translations.first.should eq({0, "Forward", "MACWPQLRLLLWKN*"})
    end

    it "finds longest translation" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = Bio::Translation.new(seq)
      tr.longest_open_reading_frame.should eq({0, "Reverse", "SVLPQQQPQLRPTSH", 0...45})
    end
    
    it "finds and set open reading frame" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = Bio::Translation.new(seq)
      tr.longest_open_reading_frame!
      tr.frameshift.should eq 0
      tr.direction.should eq Bio::TranslationDirection::Reverse
      tr.aa_seq.should eq "SVLPQQQPQLRPTSH"
    end

    it "translate with frameshift and set range" do
      seq = Bio::DNASeq.new("atggcttgtt")
      tr = seq.translate
      tr.amino_acid_seq.should eq "MAC".downcase
      tr.range.should eq 0...9
    end

    
    it "translate with frameshift and set range" do
      seq = Bio::DNASeq.new("atggcttgtt")
      tr = seq.translate(frameshift: 1, direction: Bio::TranslationDirection::Reverse)
      tr.amino_acid_seq.should eq "TSH".downcase
      tr.range.should eq 1...10
    end

    it "open reading frame with frameshift and set range" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = Bio::Translation.new(seq)
      tr.longest_open_reading_frame!
      tr.aa_seq.should eq "SVLPQQQPQLRPTSH"
      tr.range.should eq 0...45
    end

    it "open reading frame with frameshift and set range" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = Bio::Translation.new(seq)
      tr.longest_open_reading_frame!(frameshifts: [4])
      tr.aa_seq.should eq "FFHSSNLS"
      tr.range.should eq 4...28
    end

    it "find coding nucleotides" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = Bio::Translation.new(seq)
      tr.longest_open_reading_frame!(frameshifts: [4])
      tr.aa_seq.should eq "FFHSSNLS"
      tr.range.should eq 4...28
      tr.coding_nucleotides_of(2...5).should eq "cacagcagc"
    end

    it "find coding nucleotides" do
      seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
      tr = Bio::Translation.new(seq)
      tr.longest_open_reading_frame!(frameshifts: [4])
      tr.aa_seq.should eq "FFHSSNLS"
      tr.range.should eq 4...28
      tr.coding_nucleotides.should eq "ttcttccacagcagcaacctcagc"
    end
  end
end
