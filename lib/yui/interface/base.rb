module YUI
  module Interface
    class Base

      def transfer(from_stream, to_stream)
        while buffer = from_stream.read(4096)
          to_stream.write(buffer)
        end
        from_stream.close
        to_stream.close
      end

    end
  end
end

