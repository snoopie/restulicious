module Restulicious
  module Adapter
    class Default

      def initialize(klazz, key)
        @klazz = klazz
        @key   = key
      end

      def get(url, params, &block)
        request = ::Typhoeus::Request.new(url,
          method:        :get,
          headers:       { Accept: "application/json" },
          timeout:       100000, # milliseconds
          cache_timeout: 60, # seconds
          params:        params)
        hydra.queue(request)
        handle_response(request, &block)
      end

      def post(url, params, &block)
        request = ::Typhoeus::Request.new(url,
          method:        :post,
          headers:       { Accept: "application/json" },
          timeout:       100000, # milliseconds
          cache_timeout: 60, # seconds
          body:          params.to_json)
        hydra.queue(request)
        handle_response(request, &block)
      end

      def on_success(&block)
        @on_success = block
      end

      def on_complete(&block)
        @on_complete = block
      end

      def on_failure(&block)
        @on_failure = block
      end

      private

      def parser(response)
        Restulicious.config.parser_class.new(@klazz, @key, response.body)
      end

      def hydra
        Restulicious.config.hydra
      end

      def handle_response(request, &block)
        if @on_success
          request.on_success do |response|
            @on_success.call(parser(response).result)
          end
        end
        if @on_complete
          request.on_complete do |response|
            @on_complete.call(parser(response).result)
          end
        end
        if @on_failure
          request.on_failure do |response|
            @on_failure.call(parser(response).result)
          end
        end
        if block_given?
          request.on_complete do |response|
            block.call(parser(response).result)
          end
        elsif !@on_success && !@on_complete
          hydra.run
          parser(request.response).result
        end
      end
    end
  end
end

