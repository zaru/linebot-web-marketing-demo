class WordPipeline
  attr_reader :filters

  def initialize(filters)
    @filters = filters
  end

  def call(word)
    @filters.each do |filter|
      new_word = filter.call word
      return new_word unless new_word.nil?
    end
  end
end