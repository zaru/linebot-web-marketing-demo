module Filters
  class Database
    def self.call(word)
      word = Word.where(word: word).first
      return nil if word.nil?
      "#{word.answer}\n#{word.url}"
    end
  end
end