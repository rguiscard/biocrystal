require "./codon"
require "./seq"

# pairing nucleotide (DNA) and protein sequence
module Bio
  # This refers to translation direction. 'Reverse' actually means 'reverse complement'
  enum TranslationDirection
    Forward
    Reverse
    Both
  end

  class Translation
    property seq : Bio::NucleotideSeq
    getter amino_acid_seq : String = ""
    getter frameshift = 0
    getter direction = Bio::TranslationDirection::Forward

    # amino acid sequence can only be created through #translate! because it need to match position of DNA sequence
    def initialize(@seq)
    end

    # frameshift means the beginning of translation. It can be any number as long as it is less than size of DNA sequence
    # if reverse is true, it will reverse first, then do frameshift
    def translate!(frameshift = 0, direction = Bio::TranslationDirection::Forward)
      @frameshift = frameshift
      @direction = direction
      case @direction
      when .reverse?
        @amino_acid_seq = Bio::StandardCodon.translate(@seq.reverse_complement.sequence[frameshift..-1])
      else
        @amino_acid_seq = Bio::StandardCodon.translate(@seq.sequence[frameshift..-1])
      end
    end

    def nucleotide_seq
      @seq.sequence
    end
  end
end