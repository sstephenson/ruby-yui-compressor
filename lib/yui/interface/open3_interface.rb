require "yui/interface/base"
require "open3"

module YUI
  module Interface
    class Open3Interface < Base

      def compress(command, stream)
        output = true
        error = nil
        thread = nil

        Open3.popen3(command) do |stdin, stdout, stderr, wait_th|
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
          thread = wait_th
        end

        if thread && thread.value && thread.value.exitstatus == 0
          output
        else
          raise YUI::Compressor::RuntimeError, "compression failed - %s" % error
        end
      end

    end
  end
end
