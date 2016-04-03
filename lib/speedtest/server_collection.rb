module Speedtest
  class ServerCollection
    include Enumerable

    def initialize
      @collection = []
    end

    def <<(item)
      @collection << item
    end

    def [](i)
      @collection[i]
    end

    def each(&block)
      @collection.each(&block)
    end

    def best_for(origin)
      sort { |a, b| a.distance_from(origin) <=> b.distance_from(origin) }.
        take(10).
        sort { |a, b| a.ping <=> b.ping }.
        first
    end
  end
end
