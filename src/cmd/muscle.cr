module Bio::CMD
  class Muscle
    CMD = "muscle"

    property input : String | Array(Bio::Seq) = ""
    property output_format : String = "-fasta"

    # Align multiple sequences.
    # input can be either path to fasta file or array of Bio::Seq instance
    def run
      args = [] of String
      args << "-quiet"
      args << @output_format
      stdout = ::IO::Memory.new
      stderr = ::IO::Memory.new

      status = case @input
      when String
        args << "-in"
        args << @input.as(String)
        Process.run(CMD, args: args, input: Process::Redirect::Inherit, output: stdout, error: stderr)
      when Array(Bio::Seq)
        process = Process.new(CMD, args: args, input: Process::Redirect::Pipe, output: stdout, error: stderr)
        seqs = @input.as(Array(Bio::Seq)).map do |seq|
          Bio::IO::Fasta.to_fasta(seq)
        end.join("\n")
        process.input << seqs
        process.wait
      else
        Process::Status.new(1)
      end

      if status.success?
        {status.exit_code, stdout.to_s}
      else
        {status.exit_code, stderr.to_s}
      end
    end 
  end
end