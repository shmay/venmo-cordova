require 'nokogiri'

@dir = Dir.pwd
path = 'src/ios'
fullpath = @dir + '/' + path

Dir.chdir(fullpath)

@xml = Nokogiri::XML(File.read("#{@dir}/plugin.xml"))
@children = @xml.root.css('platform[name=ios]').children

@str = ""

def link_file(entry, doc, type)
  path = '.' + Dir.pwd.gsub("#{@dir}", '') + '/' + entry
  str = "\t\t\t<#{type}-file src=\"#{path}\" />\n"
  p('link_file: ' + path)
  @str += str
end

def navigate_dir(entry, doc)
  p 'navigate_dir: ' + entry
  Dir.chdir(entry)

  Dir.entries('.').each do |entry|
    if File.directory?(entry) && entry != '.' && entry != '..'
      navigate_dir(entry, doc)
    elsif entry =~ /\.h$/
      link_file(entry, doc, 'header')
    elsif entry =~ /\.m$/
      link_file(entry, doc, 'source')
    end
  end

  Dir.chdir('..')
end

navigate_dir("#{@dir}/VENCore/VENCore", @xml)
navigate_dir("#{@dir}/venmo-ios-sdk/venmo-sdk", @xml)
navigate_dir("#{@dir}/sskeychain/SSKeychain", @xml)
navigate_dir("#{@dir}/CMDQueryStringSerialization/Pod", @xml)

@xml.root.css('platform[name=ios]')[0].add_child @str

p @str

File.open("#{@dir}/blah.txt", 'w') do |f|
  f.puts @str
end
