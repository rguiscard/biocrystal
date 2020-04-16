module Bio::CMD
    class Parasail
      CMD = "parasail_aligner"

      property align_func : String = "sw_trace_striped_16"
      property input_file : String | Bio::Seq = "" # this is the database
      property input_query : String | Bio::Seq = "" # this is the query
      property output_format : String = "EMBOSS"

      def run
        temp_file = nil
        if input_file.is_a?(Bio::Seq)
          # Need to write this one into temp file
          temp_file = File.tempfile("input_file", ".fasta")
          temp_file.puts Bio::IO::Fasta.to_fasta(input_file.as(Bio::Seq))
          temp_file.close
          @input_file = temp_file.path
        end
        args = ["-a", @align_func, "-f", @input_file.as(String), "-O", @output_format]
        stdout = ::IO::Memory.new
        stderr = ::IO::Memory.new
        status = case @input_query
        when String
          args << "-q"
          args << @input_query.as(String)
          Process.run(CMD, args: args, input: Process::Redirect::Inherit, output: stdout, error: stderr)
        when Bio::Seq
          process = Process.new(CMD, args: args, input: Process::Redirect::Pipe, output: stdout, error: stderr)
          process.input << Bio::IO::Fasta.to_fasta(@input_query.as(Bio::Seq))
          process.wait
        else
          Process::Status.new(1)
        end

        if temp_file.is_a?(File)
          temp_file.as(File).delete
        end

        if status.success?
          {status.exit_code, stdout.to_s}
        else
          {status.exit_code, stderr.to_s}
        end
      end 

      def run (input_query : String)
        @input_query = input_query
        run
      end

      def run (seq : Bio::Seq)
        @input_query = seq
        run
      end
    end
end