require 'date'
require 'find'

project_version = File.expand_path( File.dirname(__FILE__) ).split(/\//).last
project, version = nil, nil
if project_version=~/^(\w+)-(\d+\.\d+\.\d+)$/ then
  project, version = $1, $2
else
  raise 'need versioned directory'
end

spec = Gem::Specification.new do |s|
  s.name = project
  s.version = version
  s.date = Date.today.to_s

  s.homepage = 'https://sites.google.com/site/carlosjhr64/rubygems/symmetricgpg'

  s.summary = 'Another gpg (symmetric) wrapper.'
  s.description = <<EOT
A ruby wrapper for linux's gpg command -- for symmetric encryption.
Encrypt/Decrypt files, strings, and ios.
EOT

  s.authors = ['carlosjhr64@gmail.com']
  s.email = 'carlosjhr64@gmail.com'

  files = []
  $stderr.puts "RBs"
  Find.find('./lib'){|fn|
    if fn=~/\.rb$/ then
      $stderr.puts fn
      files.push(fn)
    end
  }
# if File.exists?('./pngs') then
#   $stderr.puts "PNGs"
#   Find.find('./pngs'){|fn|
#     if fn=~/\.png$/ then
#       $stderr.puts fn
#       files.push(fn)
#     end
#   }
# end
  $stderr.puts "TXTs"
  Find.find('.'){|fn|
    Find.prune if !(fn=='.') && File.directory?(fn)
    if fn=~/\.txt$/ then
      $stderr.puts fn
      files.push(fn)
    end
  }

  s.files = files

# if File.exists?('./bin')
#   $stderr.puts "BINs"
#   executables = []
#   Find.find('./bin'){|fn|
#     if File.file?(fn) then
#       $stderr.puts fn
#       executables.push(fn.sub(/^.*\//,''))
#     end
#   }
#   s.executables = executables
#   s.default_executable = project
# end

# s.add_dependency('gtk2applib','~> 15.3')
# s.add_dependency('youtuber','~> 1.6')
# s.requirements << 'net/https'

end
