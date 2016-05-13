module Filters
  class Wikipedia
    def self.call(word)
      data = WikipediaApi.new(word)
      return nil if data.description.nil?
      data.description[0, 150] + "…\n" + data.url
    end
  end
end