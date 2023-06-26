require 'kimurai'

class CineColombiaSpider < Kimurai::Base
    @name = 'movies_spider'
    @engine = :selenium_firefox
    def self.process(url)
      @start_urls = [url]
      self.crawl!
    end
  
    def parse(response, url:, data: {})
      cines = response.xpath("//section[@class='collapsible show-times-collapse']")
      teatros = cines.map {|cine| cine.css('h3.show-times-collapse__title').children.to_s}
      tipo = cines.map {|x| x.css('div.show-times-group__attrs')}
      tipos = tipo.map.with_index { |x, i| {teatros[i] => x.map{ |y| y.children.map{|z| z.children.empty? ? z['alt'] : z.children.to_s}.join(" ")}}}
      horario = cines.map {|x| x.css('div.show-times-group__times')}
      horarios = horario.map.with_index {|a, i| {teatros[i] => a.css('div.show-times-group__times').map.with_index {|b, j| {tipos[i][teatros[i]][j] => b.css('span').map {|c| c.children.to_s}}}}}
      hash_tree = Hash[horario.map.with_index { |a, i| [teatros[i], Hash[tipos[i][teatros[i]].map.with_index { |b, j| [b, a.css('div.show-times-group__times')[j].css('span').map { |c| c.children.to_s }] }]] }]
      save_to "cine_colombia.json", hash_tree, format: :pretty_json, position: false
    end

end