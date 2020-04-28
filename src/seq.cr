require "./symbol"
require "./translation"

# Nucleotide and amino acid sequence mainly in string.
module Bio
  class Seq
    property sequence : String
    property identifier : String
    property symbol = Bio::Symbol

    def initialize(@sequence, identifier = "")
      @identifier = identifier
    end

    def clone
      self.class.new(@sequence, identifier=@identifier.dup)
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
      self
    end
  end

  class AminoAcidSeq < Seq
    property symbol = Bio::AminoAcid
  end

  abstract class NucleotideSeq < Seq
    # return an instance of Translation containing original nucleotide sequence and translated protein sequence
    def translate(frameshift = 0, direction = Bio::TranslationDirection::Forward)
      translation = Bio::Translation.new(seq: self)
      translation.translate!(frameshift, direction)
      translation
    end

    # Overlap extend with seq.
    # Also check reverse_complement by default
    def overlap_extend(seq : Bio::NucleotideSeq, reverse_complement = true)
      extension = seq.compact!
      forward_overlap = self.sequence.intersect(extension.sequence)
      reverse_overlap = ""
      overlap = forward_overlap

      if reverse_complement
        reverse_overlap = self.sequence.intersect(extension.reverse_complement.sequence)
      end

      if forward_overlap.size < reverse_overlap.size
        extension = extension.reverse_complement
        overlap = reverse_overlap
      end

      return self if overlap.blank?

      partitions = self.sequence.partition(overlap)
      clone = self.clone
      if extension.sequence.downcase.starts_with?(overlap.downcase)
        clone.sequence = partitions[0]+" "+extension.sequence
      elsif extension.sequence.downcase.ends_with?(overlap.downcase)
        clone.sequence = extension.sequence+" "+partitions[2]
      else
        # Overlap is in the middle of extension. Unable to extend.
      end
      clone.compact!
    end

    def reverse!
      @sequence = @sequence.reverse
      self
    end

    def reverse
      clone = self.clone
      clone.reverse!
    end

    def forward_complement!
      @sequence = @sequence.tr("ATUGCatugc", "TAACGtaacg")
      self
    end

    def forward_complement
      clone = self.clone
      clone.forward_complement!
    end

    def reverse_complement!
      self.reverse!.forward_complement!
    end

    def reverse_complement
      clone = self.clone
      clone.reverse!.forward_complement!
    end
  end

  class DNASeq < NucleotideSeq
    property symbol = Bio::DNA
  end

  class RNASeq < NucleotideSeq
    property symbol = Bio::RNA
  end
end
