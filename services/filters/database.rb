module Filters
  class Database
    def self.call(word)
      new_word = Word.where(word: word).first
      if new_word.nil?
        new_word = Word.where('word LIKE ?', "%#{word}%").first
      end
      return nil if new_word.nil?
      "#{new_word.answer}\n#{new_word.url}"
    end
  end
end