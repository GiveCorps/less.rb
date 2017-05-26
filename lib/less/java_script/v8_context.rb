require 'pathname'

module Less
  module JavaScript
    class V8Context

      def self.instance
        return new
      end

      def initialize(globals = nil)
        @v8_context = MiniRacer::Context.new
        globals.each { |key, val| @v8_context[key] = val } if globals
      end

      def unwrap
        @v8_context
      end

      def exec(&block)
        yield
      end

      def eval(source, options = nil) # passing options not supported
        source = source.encode('UTF-8') if source.respond_to?(:encode)
        @v8_context.eval("(#{source})")
      end

      def call(properties, *args)
        args.last.is_a?(::Hash) ? args.pop : nil # extract_options!
        @v8_context.eval(properties).call(*args)
      end

      def method_missing(symbol, *args)
        if @v8_context.respond_to?(symbol)
          @v8_context.send(symbol, *args)
        else
          super
        end
      end

    end
  end
end
