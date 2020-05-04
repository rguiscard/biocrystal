### Create DNA sequence
    seq = Bio::DNASeq.new(sequence: "ATGC")
    puts seq.sequence #=> ATGC

### Create protein sequence with identifier
    seq = Bio::AminoAcidSeq.new("MKALSPVRGCYEAVCCLSERSLAIARGRGKGPAAEEPLSLLDDMNHCYSRLRELVPGVPR", identifier="Protein X")
    puts seq.sequence #=> MKALSPVRGCYEAVCCLSERSLAIARGRGKGPAAEEPLSLLDDMNHCYSRLRELVPGVPR

### Validate sequence
    seq = Bio::DNASeq.new(sequence: "ATGCKK")
    puts seq.valid? #=> false

### Remove gap & space
    seq = Bio::DNASeq.new("ATG-GG---C T")
    seq.compact!
    puts seq.sequence #=> ATGGGCT

### Read from Fasta
    path = Path.new("dna.fasta")
    Bio::IO::Fasta.open(path) do |file|
        seqs = file.gets_dna
        puts seqs[0].sequence #=> ATGGGCCCGG...
    end

### Reverse Complement
    seq = Bio::DNASeq.new(sequence: "CGGTAGCGTAGCGTAGCGAGCTGAGCGTGAGCGAG")
    seq.reverse_complement!
    puts seq.sequence #=> "CTCGCTCACGCTCAGCTCGCTACGCTACGCTACCG"

### Overlap extension

It is common to design primer. In order to see the result of PCR extension, use this one. It also work with reverse primer. Spaces are added into sequences for easier reading.

    seq = Bio::DNASeq.new(sequence: "ATGC AAAAACGGGCGATTTATCC GGGTACTTTCGATCCCATTACCAATGGTCATAT")
    forward = Bio::DNASeq.new(sequence: "CATG CCATGG AAAAACGGGCGATTTATCC")
    puts seq.overlap_extend(forward).sequence #=> "CATG CCATGG AAAAACGGGCGATTTATCC GGGTACTTTCGATCCCATTACCAATGGTCATAT"

### Translate a DNA sequence

Translate a Bio::DNASeq to get an instance of Bio::Translation, which will contains both the original DNA sequence but also the translated amino acids.

    seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
    tr = seq.translate
    puts tr.nucleotide_seq #=> "atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA"
    puts tr.amino_acid_seq #=> "MACWPQLRLLLWKN*"

Frameshift and direction of translation can be specified like this:

    seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
    tr = seq.translate(frameshift: 3, direction: Bio::TranslationDirection::Reverse)
    puts tr.nucleotide_seq #=> "atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA"
    puts tr.amino_acid_seq #=> "VLPQQQPQLRPTSH"

### Find open reading frame

Automatically find the longest open reading frame from DNA sequence.

    seq = Bio::DNASeq.new("atggcttgttggcctcagctgaggttgctgctgtggaagaacTGA")
    tr = Bio::Translation.new(seq)
    tr.longest_open_reading_frame!
    puts tr.aa_seq #=> "SVLPQQQPQLRPTSH"
    puts tr.range #=> 0...45
    puts tr.direction #=> Bio::TranslationDirection::Reverse