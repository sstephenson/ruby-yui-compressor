require "open3"
require "stringio"

module YUI
  class Compressor
    class Error < StandardError; end
    class OptionError   < Error; end
    class RuntimeError  < Error; end
    
    attr_reader :options, :command
    
    def self.default_options
      { :charset => "utf-8", :line_break => nil }
    end

    def self.compressor_type
      raise Error, "create a CssCompressor or JavaScriptCompressor instead"
    end

    def initialize(options = {})
      @options = self.class.default_options.merge(options)
      @command = [path_to_java, "-jar", path_to_jar_file, *(command_option_for_type + command_options)]
    end
    
    def compress(stream_or_string)
      streamify(stream_or_string) do |stream|
        Open3.popen3(*command) do |stdin, stdout, stderr|
          begin
            transfer(stream, stdin)
            
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
      def command_options
        options.inject([]) do |command_options, (name, argument)|
          method = "command_option_for_#{name}"
          if respond_to?(method)
            command_options.concat(send(method, argument))
          else
            raise OptionError, "undefined option #{name.inspect}"
          end
        end
      end

      def path_to_java
        options.delete(:java) || "java"
      end

      def path_to_jar_file
        options.delete(:jar_file) || File.join(File.dirname(__FILE__), *%w".. .. vendor yuicompressor-2.4.2.jar")
      end

      def streamify(stream_or_string)
        if stream_or_string.respond_to?(:read)
          yield stream_or_string
        else
          yield StringIO.new(stream_or_string.to_s)
        end
      end
      
      def transfer(from_stream, to_stream)
        while buffer = from_stream.read(4096)
          to_stream.write(buffer)
        end
        to_stream.close
      end
      
      def command_option_for_type
        ["--type", self.class.compressor_type.to_s]
      end

      def command_option_for_charset(charset)
        ["--charset", charset.to_s]
      end
      
      def command_option_for_line_break(line_break)
        line_break ? ["--line-break", line_break.to_s] : []
      end
      
  end
  
  class CssCompressor < Compressor
    def self.compressor_type
      "css"
    end
  end
  
  class JavaScriptCompressor < Compressor
    def self.compressor_type
      "js"
    end
    
    def self.default_options
      super.merge(
        :munge    => false,
        :optimize => true,
        :preserve_semicolons => false
      )
    end
    
    protected
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
