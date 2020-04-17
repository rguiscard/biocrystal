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