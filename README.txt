#
# This software is GPL.
#

#################################
#         Version 1.1.0         #
# Is not zero.                  #
# Not even exactly one.         #
# gem 'symmetric_gpg', '~> 1.1' #
#################################
#           SYNOPSIS            #
#################################

require 'symmetric_gpg'

#
# Files
#
# Constructor with no parameters...
files = SymmetricGPG::Files.new
# ...needs to have it's parameters set via accessors.
files.passphrase = 'A good passphrase, not this one.'
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
# Strings
#
# But it's a good idea to set the passphrase right away.
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
# IOs
#
plain = File.open('README.txt','r')
encrypted = File.open('README.enc2','wb')
# All constructors can set the four main attributes.
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
