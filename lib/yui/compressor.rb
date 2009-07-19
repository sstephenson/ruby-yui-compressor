require "open3"
require "stringio"

module YUI
  class Compressor
    class Error < StandardError; end
    class NoOptionError < Error; end
    class RuntimeError < Error;  end
    
    attr_reader :options
    
    DEFAULT_OPTIONS = {
      :type       => :js,
      :charset    => "utf-8",
      :line_break => nil,
      :munge      => false,
      :optimize   => true,
      :preserve_semicolons => false
    }
    
    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
    end
    
    def compress(stream_or_string)
      streamify(stream_or_string) do |stream|
        Open3.popen3(*command) do |stdin, stdout, stderr|
          begin
            while buffer = stream.read(4096)
              stdin.write(buffer)
            end
            stdin.close
          
            if block_given?
              yield stdout
            else
              stdout.read
            end
            
          rescue Exception => e
            raise RuntimeError, "compression failed"
          end
        end
      end
    end
    
    protected
      def streamify(stream_or_string)
        if stream_or_string.respond_to?(:read)
          yield stream_or_string
        else
          yield StringIO.new(stream_or_string.to_s)
        end
      end
      
      def command
        @command ||= ["java", "-jar", jar_file, *command_options]
      end
      
      def jar_file
        File.join(File.dirname(__FILE__), *%w".. .. vendor yuicompressor-2.4.2.jar")
      end

      def command_options
        options.inject([]) do |command_options, (name, argument)|
          method = "command_option_for_#{name}"
          if respond_to?(method)
            command_options.concat(send(method, argument))
          else
            raise NoOptionError, "undefined option #{name.inspect}"
          end
        end
      end
      
      def command_option_for_type(type)
        ["--type", type.to_s]
      end

      def command_option_for_charset(charset)
        ["--charset", charset.to_s]
      end
      
      def command_option_for_line_break(line_break)
        line_break ? ["--line-break", line_break.to_s] : []
      end
      
      def command_option_for_munge(munge)
        munge ? [] : ["--nomunge"]
      end
      
      def command_option_for_optimize(optimize)
        optimize ? [] : ["--disable-optimizations"]
      end
      
      def command_option_for_preserve_semicolons(preserve_semicolons)
        preserve_semicolons ? ["--preserve-semi"] : []
      end
  end
end
