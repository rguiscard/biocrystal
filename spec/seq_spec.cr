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

    it "is invalid because space and gap" do
      seq = Bio::DNASeq.new(sequence: "A-TG C")
      seq.valid?.should eq false
    end

    it "is valid after considering space and gap" do
      seq = Bio::DNASeq.new(sequence: "A-TG C")
      seq.valid?(ignore: [:gap, :space]).should eq true
    end

    it "compacts sequence" do
      seq = Bio::DNASeq.new(sequence: "A-TG  C")
      seq.compact!
      seq.valid?.should eq true
      seq.sequence.should eq "ATGC"
    end

    it "keep gap" do
      seq = Bio::DNASeq.new(sequence: "A-TG  C")
      seq.compact!(keep: [:gap])
      seq.sequence.should eq "A-TGC"
    end

    it "keep space" do
      seq = Bio::DNASeq.new(sequence: "A-TG  C")
      seq.compact!(keep: [:space])
      seq.sequence.should eq "ATG  C"
    end

    it "keep newline" do
      seq = Bio::DNASeq.new(sequence: "A-TG\rC")
      seq.compact!(keep: [:newline])
      seq.sequence.should eq "ATG\rC"
    end
  end
end
