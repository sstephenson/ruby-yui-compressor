require 'yui/interface/base'

module YUI
  module Interface
    class IoInterface < Base

      def compress(command, stream)
        output = true
        error = nil

        IO.popen4(command) do |pid, stdin, stdout, stderr|
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

        if $?.exitstatus.zero?
          output
        else
          raise YUI::Compressor::RuntimeError, "compression failed - %s" % error
        end
      end

    end
  end
end
