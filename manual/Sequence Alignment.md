## Sequence Alignment

Biocrystal use external tools for sequence alignment.

### [Parasail](https://github.com/jeffdaily/parasail)

It can be compiled and installed with source code. It also provides precompiled binary. Download a [released binary](https://github.com/jeffdaily/parasail/releases) and unpack it. Add parasail library and bin path to environment variables like this
````
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:path_to_your_parasail/lib
export PATH=$PATH:path_to_your_parasail/bin
````
Run `parasail_aligner` and see the usage

Once it works, sequence alignment can be done as this example:
````
input = Path.new("data", "P0DTC2.fasta")
query = Path.new("data", "P59594.fasta")
   
parasail = Bio::CMD::Parasail.new
parasail.input_file = input.expand.to_s
parasail.input_query = query.expand.to_s
results = parasail.run
puts results[0] #=> 0 for success and others for error
puts results[1] #=> alignment results

1 MFVFLVLLPLVS-SQCVNLTTRTQL-PPAYT--NSFTRGVYYPDKVFRSS      46
  ||:||:.|.|.| |.....||...: .|.||  .|..|||||||::|||.
1 MFIFLLFLTLTSGSDLDRCTTFDDVQAPNYTQHTSSMRGVYYPDEIFRSD      50
````

### [Muscle](https://www.drive5.com/muscle/)

Muscle is for multiple sequence alignment. It can be installed via package like this

````
sudo apt-get install muscle
````

Run it like this:

````
seqs = [] of String
[Path.new("P0DTC2.fasta"), Path.new("P59594.fasta")].map do |path|
  Bio::IO::Fasta.open(path.to_s) do |f|
    seqs << f.gets_aa[0]
  end
end
  
muscle = Bio::CMD::Muscle.new
muscle.input = seqs
muscle.output_format = "-clw"
results = muscle.run
puts results[1]
````