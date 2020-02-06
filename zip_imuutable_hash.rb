require 'zip'
require 'digest'

class ZipCreator
  def initialize(zip_name)
    @zip_name = zip_name    
  end

  def execute
    path = "../../tmp/#{@zip_name}.zip"
    file = File.open(path, 'w+')

    fuga_path = "../../tmp/fuga.txt"
    fuga = File.open(fuga_path, 'w+')
    File.write(fuga, 'fuga')

    Zip::File.open(path, Zip::File::CREATE) do |zip|
      d = zip.mkdir('piyo')
      d.time = ::Zip::DOSTime.new(1)
      d.extra = ::Zip::ExtraField.new

      d = zip.mkdir('poyo')
      d.time = ::Zip::DOSTime.new(1)
      d.extra = ::Zip::ExtraField.new

      z = zip.add('piyo/fuga.txt', fuga)
      z.time = ::Zip::DOSTime.new(1)
      z.extra = ::Zip::ExtraField.new
    end

    data = File.read(path)
    hash = Digest::SHA256.base64digest(data)
    puts hash

    File.delete(path)
    File.delete(fuga_path)
  end
end

creator = ZipCreator.new('application')
creator.execute

