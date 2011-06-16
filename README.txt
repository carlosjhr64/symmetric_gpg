### SYNOPSIS ###

require 'symmetric_gpg'

# Constructor
sgpg = SymmetricGPG.new('A good passphrase, not this one.')

# FILES...
# Encript plain file, Text.txt, to encripted file, Text.enc.
sgpg.encrypt('Text.txt','Text.enc', true) # true means it's OK to overwrite
# Decript encripted file, Text.enc, to decripted file, Text.dec.
sgpg.decrypt('Text.enc','Text.dec', true) # true means it's OK to overwrite
# Text.dec should be identical to Text.txt

# STRINGS...
plain = "The rain in spain rains mainly in the plane."
encripted = sgpg.encstr(plain)
puts
puts "Garbled:"
puts encripted # garbled text
puts
decripted = sgpg.decstr(encripted)
puts "Plain:"
puts decripted # "The rain in spain rains mainly in the plane."
puts

# AND IOS...
# plain reader io to encripted writter io
reader = File.open('Text.txt','r')
writer = File.open('Text.enc2','w')
# "plain to encripted pipe"
sgpg.p2ep(reader,writer)
writer.close
reader.close
# encripted reader io to plain writter io
reader = File.open('Text.enc2','r')
writer = File.open('Text.dec2','w')
# "encripted to plain pipe"
sgpg.e2pp(reader,writer)
writer.close
reader.close
