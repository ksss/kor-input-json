require 'json'

module Kor
  module Input
    class Json
      def initialize(io)
        @io = io
        @single = false
        @keys = []
        @jsons = []
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
      end

      def head
        if @single
          @jsons = JSON.parse(@io.read)
        else
          while line = @io.gets
            line.strip!
            @jsons << JSON.parse(line)
          end
        end
        @keys = @jsons.map do |json|
          json.keys
        end
        @keys.flatten!.uniq!
        @keys
      end

      def gets
        @fiber.resume
      rescue FiberError
        nil
      end
    end

    require "kor/input/json/version"
  end
end
