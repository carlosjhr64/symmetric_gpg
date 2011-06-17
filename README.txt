#
# This software is GPL.
#

#######################
#    Version 1.0.0    #
#      not zero       #
#######################
#      SYNOPSIS       #
#######################

require 'symmetric_gpg'

#
# Files Constructor
#
# Constructor has to have at least the passphrase.
files = SymmetricGPG::Files.new('A good passphrase, not this one.')
# Then set the rest via accessors
files.plain = 'README.txt'
files.encrypted = 'README.enc'
files.force = true # ok to overwrite pre-existing file
# Encrypt plain to encrypted
files.encrypt
# Ok, let's decrypt README.enc
files.plain = 'README.dec'
files.decrypt
# README.dec should be identical to README.txt
raise "Bad encryption/decryption" if `diff README.dec README.txt`.length != 0

#
# Strings Constructor
#
strings = SymmetricGPG::Strings.new('Not this one either.')
strings.plain = 'The rain in spain rains mainly in the plane.'
encrypted = strings.encrypt
# Note that the encrypted attribute is also set.
raise "Bad encrypted attribute" if encrypted != strings.encrypted
# And it's garbled
puts "Garbled:"
puts encrypted
# No cheat, set plain to ":" and decrypt back, see that it works.
strings.plain = ':'
puts "Plain#{strings.plain}"
strings.decrypt
puts strings.plain


#
# IOs Constructor
#
# All constructors can set the four main attributes.
plain = File.open('README.txt','r')
encrypted = File.open('README.enc2','wb')
ios = SymmetricGPG::IOs.new('Maybe... nope! Be random.', plain, encrypted, true) # ok to overwrite
ios.encrypt
encrypted.close
plain.close
# README.enc2 is encrypted.  Now decrypt it back.
ios.encrypted = File.open('README.enc2','r')
ios.plain = File.open('README.dec2','wb')
ios.decrypt
ios.plain.close
ios.encrypted.close
# README.dec2 should be identical to README.txt
raise "Bad encryption/decryption" if `diff README.dec2 README.txt`.length != 0

# Note that stdin and/or stdout can be used
File.open('README.enc2','r') do |encrypted|
  ios.encrypted = encrypted
  ios.plain = $stdout
  ios.decrypt
end
# And of course you can use StringIO.

puts "OK!"
