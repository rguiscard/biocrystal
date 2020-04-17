require "./spec_helper"

module Bio
  describe Seq do

    it "can extend overlap string in the front" do
      seq = Bio::DNASeq.new(sequence: "ATGCAAAAACGGGCGATTTATCCGGGTACTTTCGATCCCATTACCAATGGTCATAT")
      forward = Bio::DNASeq.new(sequence: "CATG CCATGGAAAAACGGGCGATTTATCC")
      seq.overlap_extend(forward).sequence.should eq "CATGCCATGGAAAAACGGGCGATTTATCCGGGTACTTTCGATCCCATTACCAATGGTCATAT"
    end

    it "can extend overlap string in the back" do
      seq = Bio::DNASeq.new(sequence: "GGTGAAAGAGGTGGCGCGCCATCAGGGCGATGTCACCCATTTCCTGCCGGAGAATGTCCATCAGGCGCTGATGGCGAAGTTAGCG")
      backward = Bio::DNASeq.new(sequence: "CG GGATCCCTA CGCTAACTTCGCCATCAGC")
      seq.overlap_extend(backward).sequence.should eq "GGTGAAAGAGGTGGCGCGCCATCAGGGCGATGTCACCCATTTCCTGCCGGAGAATGTCCATCAGGCGCTGATGGCGAAGTTAGCGTAGGGATCCCG"
    end 

    it "can reverse DNA sequence" do
      seq = Bio::DNASeq.new(sequence: "CGGTAGCGTAGCGTAGCGAGCTGAGCGTGAGCGAG")
      seq.reverse!
      seq.sequence.should eq "GAGCGAGTGCGAGTCGAGCGATGCGATGCGATGGC"
    end

    it "can get reverse DNA sequence" do
      seq = Bio::DNASeq.new(sequence: "CGGTAGCGTAGCGTAGCGAGCTGAGCGTGAGCGAG")
      seq.reverse.sequence.should eq "GAGCGAGTGCGAGTCGAGCGATGCGATGCGATGGC"
    end

    it "can forward complement DNA sequence" do
      seq = Bio::DNASeq.new(sequence: "CGGTAGCGTAGCGTAGCGAGCTGAGCGTGAGCGAG")
      seq.forward_complement!
      seq.sequence.should eq "GCCATCGCATCGCATCGCTCGACTCGCACTCGCTC"
    end

    it "can reverse complement DNA sequence" do
      seq = Bio::DNASeq.new(sequence: "CGGTAGCGTAGCGTAGCGAGCTGAGCGTGAGCGAG")
      seq.reverse_complement!
      seq.sequence.should eq "CTCGCTCACGCTCAGCTCGCTACGCTACGCTACCG"
    end

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
