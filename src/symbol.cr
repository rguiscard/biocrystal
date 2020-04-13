module Bio
  class Symbol
    def self.alphabets
      [] of Char
    end
  end

  class DNA < Symbol
    def self.alphabets
      ['a', 't', 'g', 'c']
    end
  end

  class RNA < Symbol
    def self.alphabets
      ['a', 'u', 'g', 'c']
    end
  end

  class AminoAcid < Symbol
    def self.alphabets
      ['a', 'r', 'n', 'd', 'c', 'q', 'e', 'g', 'h', 'i', 'l', 'k', 'm', 'f', 'p', 's', 't', 'w', 'y', 'v']
    end
  end
end
