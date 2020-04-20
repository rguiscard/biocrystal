require "../spec_helper"

module Bio::CMD
  describe Muscle do
    it "can align protein sequences from file" do
      temp_file = File.tempfile("fasta_file", ".fasta")
      [Path.new("data", "P0DTC2.fasta"), Path.new("data", "P59594.fasta")].map do |path|
        File.open(path.to_s) do |f|
          temp_file.puts(f.gets_to_end)
        end
      end
      temp_file.close
       
      muscle = Bio::CMD::Muscle.new
      muscle.input = temp_file.path
      muscle.output_format = "-clw"
      results = muscle.run
      results[0].should eq 0
      # puts results[1]

      if temp_file.is_a?(File)
        temp_file.delete
      end
    end

    it "can align protein sequences from Bio::Seq" do
      seqs = [] of Bio::Seq
      [Path.new("data", "P0DTC2.fasta"), Path.new("data", "P59594.fasta")].map do |path|
        Bio::IO::Fasta.open(path.to_s) do |f|
          seqs << f.gets_aa[0]
        end
      end
      #puts seqs
       
      muscle = Bio::CMD::Muscle.new
      muscle.input = seqs
      muscle.output_format = "-clw"
      results = muscle.run
      results[0].should eq 0
      # puts results[1]
    end
  end
end