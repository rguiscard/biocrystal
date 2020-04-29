require "./codon"
require "./seq"

# pairing nucleotide (DNA) and protein sequence
module Bio
  # This refers to translation direction. 'Reverse' actually means 'reverse complement'
  @[Flags]
  enum TranslationDirection
    Forward = 1
    Reverse = 2
    Both = 3
  end

  class Translation
    property seq : Bio::NucleotideSeq
    getter amino_acid_seq : String = ""
    getter frameshift = 0
    getter direction = Bio::TranslationDirection::Forward
    getter range = 0..0 # range of nucleotide corresponding to translted amino acid

    # amino acid sequence can only be created through #translate! because it need to match position of DNA sequence
    def initialize(@seq)
    end

    # use amino acid fragment to find corresponding nucleotide.
    # It always return sense (coding) strand. It would be reversed if translation is on reverse strand
    def coding_nucleotides_of(fragment : String)
      return "" if @amino_acid_seq.blank?
      n = (@direction.forward? ? @seq.sequence : @seq.reverse_complement.sequence)
      i = @amino_acid_seq.index(fragment)
      if i.nil? == false
        b = i.as(Int32)*3+@range.begin
        r = b...(b+fragment.size*3)
        n[r]
      else
        ""
      end
    end

    def coding_nucleotides_of(fragment : Range)
      return "" if @amino_acid_seq.blank?
      s = @amino_acid_seq[fragment]
      coding_nucleotides_of(s)
    end

    def coding_nucleotides
      return "" if @amino_acid_seq.blank?
      coding_nucleotides_of(@amino_acid_seq)
    end

    def longest_open_reading_frame!(frameshifts = [0,1,2], direction = Bio::TranslationDirection::Both)
      tr = longest_open_reading_frame(frameshifts, direction)
      @frameshift = tr[0]
      @direction = Bio::TranslationDirection.parse(tr[1])
      @amino_acid_seq = tr[2]
      @range = tr[3]
      self
    end

    # return longest translation in tuple {frameshift, direction, seq, range}
    def longest_open_reading_frame(frameshifts = [0,1,2], direction = Bio::TranslationDirection::Both)
      trs = translations(frameshifts, direction)
      start = "m"
      stop = "*"
      letters = Bio::AminoAcid.alphabets
      letters.delete(start)
      letters.delete(stop)
      regex = Regex.new("[#{letters.join("")}]+", Regex::Options::IGNORE_CASE)
      orfs = trs.map do |tr|
        r = 0..0
        s = ""
        tr[2].scan(regex) do |match|
          if match[0]? && (match.end.as(Int32)-match.begin.as(Int32)) > r.size
            r = (tr[0]+match.begin.as(Int32)*3)...(tr[0]+match.end.as(Int32)*3)
            s = match[0]
          end
        end
        {tr[0], tr[1], s, r}
      end

      orf = orfs.max_by(&.[](2).size)

      orf
    end

    # display translation with all possibility (frameshift=0,1,2 and both direction)
    # return array of tuple {frameshift : Int32, direction : Bio::TranslationDirection, amino_acid_seq : String}
    # returned array is ordered by frameshift first, then direct (forward and reverse)
    # This does not write into translation
    def translations(frameshifts = [0,1,2], direction = Bio::TranslationDirection::Both)
      trs = [] of {Int32, String, String}
      if direction.forward?
        frameshifts.each do |frameshift|
          s = Bio::StandardCodon.translate(@seq.sequence[frameshift..-1]).upcase
          trs << {frameshift, Bio::TranslationDirection::Forward.to_s, s}
        end
      end
      if direction.reverse?
        frameshifts.each do |frameshift|
          s = Bio::StandardCodon.translate(@seq.reverse_complement.sequence[frameshift..-1]).upcase
          trs << {frameshift, Bio::TranslationDirection::Reverse.to_s, s}
        end
      end
      trs
    end

    # frameshift means the beginning of translation. It can be any number as long as it is less than size of DNA sequence
    # if reverse is true, it will reverse first, then do frameshift
    def translate(frameshift = 0, direction = Bio::TranslationDirection::Forward)
      case direction
      when .reverse?
        s = Bio::StandardCodon.translate(@seq.reverse_complement.sequence[frameshift..-1])
      else
        s = Bio::StandardCodon.translate(@seq.sequence[frameshift..-1])
      end
      s
    end

    def translate!(frameshift = 0, direction = Bio::TranslationDirection::Forward)
      @amino_acid_seq = translate(frameshift, direction)
      @frameshift = frameshift
      @direction = direction
      @range = frameshift...(frameshift+@amino_acid_seq.size*3)
      self
    end

    def nucleotide_seq
      @seq.sequence
    end
    
    def aa_seq
      amino_acid_seq
    end
  end
end