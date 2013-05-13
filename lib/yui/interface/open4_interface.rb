require "yui/interface/base"

module YUI
  module Interface
    class Open4Interface < Base

      require "open4"

      def compress(command, stream)
        output = true
        error = nil

        status = Open4.popen4(command) do |pid, stdin, stdout, stderr|
          begin
            stdin.binmode
            transfer(stream, stdin)

            if block_given?
              yield stdout
            else
              output = stdout.read
            end

          rescue Exception => e
            raise YUI::Compressor::RuntimeError, "compression failed"
          end

          error = stderr.read
        end

        if status.exitstatus.zero?
          output
        else
          raise YUI::Compressor::RuntimeError, "compression failed - %s" % error
        end
      end

    end
  end
end
