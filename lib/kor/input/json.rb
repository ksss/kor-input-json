require 'json'

module Kor
  module Input
    class Json
      DEFAULT_GUESS_TIME = 5

      def initialize(io)
        @io = io
        @single = false
        @keys = []
        @jsons = []
        @count = 0
        @guess_time = DEFAULT_GUESS_TIME
        @fiber = Fiber.new do
          @jsons.each do |json|
            Fiber.yield @keys.map{ |k| json[k] }
          end
          # gets should be return nil when last
          Fiber.yield nil
        end
      end

      def parse(opt)
        opt.on("--single", "parse single JSON") do |arg|
          @single = true
        end
        opt.on("--guess-time=NUM", "load lines this time for guess. no guess if under 0 (default #{DEFAULT_GUESS_TIME})") do |arg|
          @guess_time = arg.to_i
        end
      end

      def head
        if @single
          @jsons = JSON.parse(@io.read)
        else
          while line = @io.gets
            line.strip!
            @jsons << JSON.parse(line)
            if 0 < @guess_time && @guess_time <= @jsons.length
              break
            end
          end
        end
        @keys = @jsons.map do |json|
          json.keys
        end
        @keys.flatten!.uniq!
        @keys
      end

      def gets
        if @guess_time <= 0 || @count < @guess_time
          @count += 1
          return resume
        end

        if line = @io.gets
          line.strip!
          json = JSON.parse(line)
          @keys.map { |k| json[k] }
        else
          nil
        end
      end

      private

      def resume
        @fiber.resume
      rescue FiberError
        nil
      end
    end

    require "kor/input/json/version"
  end
end
