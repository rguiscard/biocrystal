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