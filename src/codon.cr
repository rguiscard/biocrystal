module Bio
  # https://www.ncbi.nlm.nih.gov/Taxonomy/taxonomyhome.html/index.cgi?chapter=cgencodes
  abstract class Codon
    # return amino acid based on nucleotide sequence.
    # it always start from first character.
    # use Bio::NucleotideSeq#translate for flexibility
    def self.translate(seq : Bio::NucleotideSeq | String)
      if seq.is_a?(Bio::NucleotideSeq)
        s = seq.as(Bio::NucleotideSeq).sequence
      else
        s = seq
      end
      # be sure it is multiple of 3
      n = s.size // 3
      s = s[0...n*3]
      s.as(String).gsub(/.{3}/) { |x|
        @@codons[x.downcase]
      }
    end
  end

  class StandardCodon < Codon
    @@id = 1
    @@name = "Standard"
    @@codons = {
      "ttt" => 'f', "ttc" => 'f', "tta" => 'l', "ttg" => 'l',
      "tct" => 's', "tcc" => 's', "tca" => 's', "tcg" => 's',
      "tat" => 'y', "tac" => 'y', "taa" => '*', "tag" => '*',
      "tgt" => 'c', "tgc" => 'c', "tga" => '*', "tgg" => 'w',
      "ctt" => 'l', "ctc" => 'l', "cta" => 'l', "ctg" => 'l',
      "cct" => 'p', "ccc" => 'p', "cca" => 'p', "ccg" => 'p',
      "cat" => 'h', "cac" => 'h', "caa" => 'q', "cag" => 'q',
      "cgt" => 'r', "cgc" => 'r', "cga" => 'r', "cgg" => 'r',
      "att" => 'i', "atc" => 'i', "ata" => 'i', "atg" => 'm',
      "act" => 't', "acc" => 't', "aca" => 't', "acg" => 't',
      "aat" => 'n', "aac" => 'n', "aaa" => 'k', "aag" => 'k',
      "agt" => 's', "agc" => 's', "aga" => 'r', "agg" => 'r',
      "gtt" => 'v', "gtc" => 'v', "gta" => 'v', "gtg" => 'v',
      "gct" => 'a', "gcc" => 'a', "gca" => 'a', "gcg" => 'a',
      "gat" => 'd', "gac" => 'd', "gaa" => 'e', "gag" => 'e',
      "ggt" => 'g', "ggc" => 'g', "gga" => 'g', "ggg" => 'g'
    }
  end

  class NCBI2Codon < Codon
    @@id = 2
    @@name = "Vertebrate Mitochondrial"
    @@codons = {
      "ttt" => 'f', "ttc" => 'f', "tta" => 'l', "ttg" => 'l',
      "tct" => 's', "tcc" => 's', "tca" => 's', "tcg" => 's',
      "tat" => 'y', "tac" => 'y', "taa" => '*', "tag" => '*',
      "tgt" => 'c', "tgc" => 'c', "tga" => 'w', "tgg" => 'w',
      "ctt" => 'l', "ctc" => 'l', "cta" => 'l', "ctg" => 'l',
      "cct" => 'p', "ccc" => 'p', "cca" => 'p', "ccg" => 'p',
      "cat" => 'h', "cac" => 'h', "caa" => 'q', "cag" => 'q',
      "cgt" => 'r', "cgc" => 'r', "cga" => 'r', "cgg" => 'r',
      "att" => 'i', "atc" => 'i', "ata" => 'm', "atg" => 'm',
      "act" => 't', "acc" => 't', "aca" => 't', "acg" => 't',
      "aat" => 'n', "aac" => 'n', "aaa" => 'k', "aag" => 'k',
      "agt" => 's', "agc" => 's', "aga" => '*', "agg" => '*',
      "gtt" => 'v', "gtc" => 'v', "gta" => 'v', "gtg" => 'v',
      "gct" => 'a', "gcc" => 'a', "gca" => 'a', "gcg" => 'a',
      "gat" => 'd', "gac" => 'd', "gaa" => 'e', "gag" => 'e',
      "ggt" => 'g', "ggc" => 'g', "gga" => 'g', "ggg" => 'g'
    }
  end
end
