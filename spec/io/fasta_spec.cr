require "../spec_helper"

module Bio::IO
  describe Fasta do
    it "can read file" do
      path = Path.new("data", "dna.fasta")
      File.exists?(path).should be_true
    end

    it "can read fasta file" do
      path = Path.new("data", "dna.fasta")
      Bio::IO::Fasta.open(path) do |file|
        seqs = file.gets_seq
        seqs.size.should eq 2
      end
    end

    it "can read DNA fasta file" do
      path = Path.new("data", "dna.fasta")
      Bio::IO::Fasta.open(path) do |file|
        seqs = file.gets_dna
        seqs.size.should eq 2
        seqs[0].valid?.should be_true
      end
    end

    it "can read protein fasta file" do
      path = Path.new("data", "protein.fasta")
      Bio::IO::Fasta.open(path) do |file|
        seqs = file.gets_aa
        seqs.size.should eq 3
        seqs[0].valid?.should be_true
      end
    end

    it "can read protein fasta file as dna but be invalid" do
      path = Path.new("data", "protein.fasta")
      Bio::IO::Fasta.open(path) do |file|
        seqs = file.gets_dna
        seqs.size.should eq 3
        seqs[0].valid?.should be_false
      end
    end
  end
end