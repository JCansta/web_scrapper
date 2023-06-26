require 'kimurai'

class RoyalFilmsSpider < Kimurai::Base
    @name = 'movies_spider'
    @engine = :selenium_firefox
    def self.process(url)
      @start_urls = [url]
      self.crawl!
    end
  
    def parse(response, url:, data: {})
        byebug
        sleep(2)
        cines = response.xpath("//ul[@class='schedules clickable']")
        funciones = cines.reduce({}) do |cine, funcion|
            cine.merge!(funcion.css('li.header').children.children.first.to_s.split.join(' ') => funcion.css('li.row').reduce({}) do |row, horas|
                row.merge!(horas.children[1].children.to_s.split.join => horas.children.children[3, horas.children.children.count - 4].reduce([]) do |hora, z|
                    horas.push(z.children.to_s.split.join)
                end)
            end)
        end
    
        save_to "royal.json", funciones, format: :pretty_json, position: false
    end

end