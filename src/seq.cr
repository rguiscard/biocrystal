require "./symbol"

# Nucleotide and amino acid sequence mainly in string.
module Bio
  class Seq
    property sequence : String
    property symbol = Bio::Symbol

    def initialize(@sequence)
    end

    def valid?
      sequence.chars.all?{|char| @symbol.alphabets.includes?(char.downcase)}
    end
  end

  class AminoAcidSeq < Seq
    property symbol = Bio::AminoAcid
  end

  class NucleotideSeq < Seq
  end

  class DNASeq < NucleotideSeq
    property symbol = Bio::DNA
  end

  class RNASeq < NucleotideSeq
    property symbol = Bio::RNA
  end
end
