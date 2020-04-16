require "../spec_helper"

module Bio::CMD
  describe Parasail do
    it "can align two protein sequences" do
      input = Path.new("data", "P0DTC2.fasta")
      query = Path.new("data", "P59594.fasta")
       
      parasail = Bio::CMD::Parasail.new
      parasail.input_file = input.expand.to_s
      parasail.input_query = query.expand.to_s
      results = parasail.run
      results[0].should eq 0
      #puts results[1]
    end

    it "can align two protein sequences in files" do
        input = Path.new("data", "P0DTC2.fasta")
        query = Path.new("data", "P59594.fasta")
         
        parasail = Bio::CMD::Parasail.new
        parasail.input_file = input.expand.to_s
        results = parasail.run(query.expand.to_s)
        results[0].should eq 0
        # puts results[1]
    end

    it "can align one protein sequences to a fasta file" do
      input = Path.new("data", "P0DTC2.fasta")
      query = Path.new("data", "P59594.fasta")

      parasail = Bio::CMD::Parasail.new
      parasail.input_file = input.expand.to_s

      Bio::IO::Fasta.open(query) do |file|
        seq = file.gets_aa
        results = parasail.run(seq[0])
        results[0].should eq 0
        # puts results[1]
      end
    end

    it "can align two protein sequences" do
      input = Path.new("data", "P0DTC2.fasta")
      query = Path.new("data", "P59594.fasta")

      fi = Bio::IO::Fasta.open(input)
      i = fi.gets_aa
      fi.close

      fq = Bio::IO::Fasta.open(query)
      q = fq.gets_aa
      fq.close

      parasail = Bio::CMD::Parasail.new
      parasail.input_file = i[0]
      parasail.input_query = q[0]

      results = parasail.run
      results[0].should eq 0
      # puts results[1]
    end
  end
end