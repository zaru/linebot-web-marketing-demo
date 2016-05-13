module Filters
  class Ai
    def self.call(word)
      docomo = DocomoAi.new(word)
      docomo.answer
    end
  end
end