module Bio
  abstract class Symbol
    # @@symbols = {} of Char => Symbol

    # return symbol of nucleotide or amino acid
    def self.alphabet(letter : Char)
      begin
        return @@symbols[letter.downcase]
      rescue ex : KeyError
        nil
      end
    end

    # return nucleotide or amino acid in array of downcase letter (Char)
    def self.alphabets
      [] of Char
    end
  end

  class DNA < Symbol

    @@symbols = {
      'a' => :"DNA_A",
      't' => :"DNA_T",
      'c' => :"DNA_C",
      'g' => :"DNA_G"
    }

    def self.alphabets
      ['a', 't', 'g', 'c']
    end
  end

  class RNA < Symbol

    @@symbols = {
      'a' => :"RNA_A",
      'u' => :"RNA_u",
      'c' => :"RNA_C",
      'g' => :"RNA_G"
    }
    def self.alphabets
      ['a', 'u', 'g', 'c']
    end
  end

  class AminoAcid < Symbol

    @@symbols = {
      'a' => :"AA_A",
      'r' => :"AA_R",
      'n' => :"AA_N",
      'd' => :"AA_D",
      'c' => :"AA_C",
      'q' => :"AA_Q",
      'e' => :"AA_E",
      'g' => :"AA_G",
      'h' => :"AA_H",
      'i' => :"AA_I",
      'l' => :"AA_L",
      'k' => :"AA_K",
      'm' => :"AA_M",
      'p' => :"AA_P",
      's' => :"AA_S",
      't' => :"AA_T",
      'w' => :"AA_W",
      'y' => :"AA_Y",
      'v' => :"AA_V"
    }

    def self.alphabets
      ['a', 'r', 'n', 'd', 'c', 'q', 'e', 'g', 'h', 'i', 'l', 'k', 'm', 'f', 'p', 's', 't', 'w', 'y', 'v']
    end
  end
end
