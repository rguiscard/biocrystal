module Bio::IO
  class Fasta < File
    # Read sequence at once in tuple (header : String, seq : String)
    def gets_seq
      gets('>')
      results = [] of {String, String}
      while rec = gets('>', chomp: true)
        if n = rec.index(/[\r\n]+/)
          header = rec[0..n-1].strip
          seq = rec[n+1..-1].gsub(/[\r\n]+/, "").strip
          results << {header, seq}
        end
      end
      results
    end

    # Return array of Bio::DNASeq. It may not be valid.
    def gets_dna
      gets_seq.map { |seq| Bio::DNASeq.new(seq[1], identifier=seq[0]) }
    end

    # Return array of Bio::RNASeq. It may not be valid.
    def gets_rna
      gets_seq.map { |seq| Bio::RNASeq.new(seq[1], identifier=seq[0]) }
    end
    
    # Return array of Bio::AminoAcidSeq. It may not be valid.
    def gets_amino_acid
      gets_seq.map { |seq| Bio::AminoAcidSeq.new(seq[1], identifier=seq[0]) }
    end

    # short form for read_amino_acid
    def gets_aa
      gets_amino_acid
    end

    # Convert Bio::Seq to fasta format in String
    def self.to_fasta(seqs : Bio::Seq | Array(Bio::Seq))
      if seqs.is_a?(Bio::Seq)
        seqs = [seqs]
      end
      seqs.map { |seq|
        "> #{seq.identifier}\n#{seq.sequence}"
      }.join(separator = "\n")
    end
  end
end