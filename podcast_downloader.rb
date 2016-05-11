require 'open-uri'
require 'json'
require 'progressbar'

date = '2016_05_11'
url = 'http://streaming.rajawaliradio.com/mqod/jsonp.php?date='+date+'&callback=&format=MP3'
pbar = nil

json = JSON.parse(open(url).read.tr('()',''))
json.each do |j|
  filename = j["acara"]+".mp3" 
  File.open(j["acara"]+".mp3", "wb") do |saved_file|
    open(URI.escape(j["link"]).gsub('[','%5B').gsub(']','%5D'), "rb", :content_length_proc => lambda { |t|
    if t && 0 < t
      pbar = ProgressBar.new(j["acara"], t)
      pbar.file_transfer_mode
    end
    },

    :progress_proc => lambda {|s|
      pbar.set s if pbar
    }) do |read_file|
      saved_file.write(read_file.read)
    end
  end
  puts "\n"
end
