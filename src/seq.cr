require "./symbol"

# Nucleotide and amino acid sequence mainly in string.
module Bio
  class Seq
    property sequence : String
    property identifier : String
    property symbol = Bio::Symbol

    def initialize(@sequence, identifier = "")
      @identifier = identifier
    end

    # Check sequence is valid as all letters are in alphabets
    # Those special alphabet can be kept: :gap, :space, :newline
    def valid?(ignore = [] of Symbol)
      sequence.chars.all?{ |char|
        if (char == '-') && ignore.includes?(:gap)
          return true
        elsif (char == ' ') && ignore.includes?(:space)
          return true    
        elsif ((char == '\n') || (char == '\r')) && ignore.includes?(:newline)
           return true    
        else
          @symbol.alphabets.includes?(char.downcase)
        end
      }
    end

    # Remove spaces, newline and gap
    # Those special alphabet can be kept: :gap, :space, :newline
    def compact!(keep = [] of Symbol)

      if keep.includes?(:gap) == false
        @sequence = @sequence.gsub('-', "")
      end

      if keep.includes?(:space) == false
        @sequence = @sequence.gsub(' ', "")
      end

      if keep.includes?(:newline) == false
        @sequence = @sequence.gsub(/[\n\r]+/, "")
      end
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
