require "../spec_helper"

module Bio::IO
  describe Fasta do
    it "can convert one seq to fasta string" do
      seq = Bio::DNASeq.new("ATCGCCGAT")
      fasta = Bio::IO::Fasta.to_fasta(seq).lines
      fasta[0].should eq "> "
      fasta[1].should eq "ATCGCCGAT"
    end

    it "can convert many seqs to fasta string" do
      seqs = [Bio::DNASeq.new("ATCGCCGAT", identifier = "Protein I")]
      seqs << Bio::DNASeq.new("GGCGGTGTGAA", identifier= "Protein II")
      fasta = Bio::IO::Fasta.to_fasta(seqs).lines
      fasta[0].should eq "> Protein I"
      fasta[1].should eq "ATCGCCGAT"
      fasta[2].should eq "> Protein II"
      fasta[3].should eq "GGCGGTGTGAA"
    end

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