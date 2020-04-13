require "./spec_helper"

module Bio
  describe Seq do

    it "initiates Seq with sequence" do
      seq = Bio::Seq.new(sequence: "ATGC")
      seq.sequence.should eq "ATGC"
    end

    it "has Symbol" do
      seq = Bio::DNASeq.new(sequence: "ATGC")
      seq.sequence.should eq "ATGC"
      seq.symbol.should eq Bio::DNA
    end

    it "is valid" do
      seq = Bio::DNASeq.new(sequence: "ATGC")
      seq.valid?.should eq true
    end
    
    it "is invalid" do
      seq = Bio::DNASeq.new(sequence: "AUGC")
      seq.valid?.should eq false
    end
  end
end
