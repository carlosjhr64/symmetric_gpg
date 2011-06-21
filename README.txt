#
# This software is GPL.
#

#################################
#         Version 1.3.0         #
# Is not zero.                  #
# It's one with mo' features.   #
# gem 'symmetric_gpg', '~> 1.3' #
#################################
#           SYNOPSIS            #
#################################
#
# New in this version is SymmetricGPG::Shreds,
# which uses Shredder:
#    https://rubygems.org/gems/shredder
# Works like SymmetricGPG::Files, described below, but
# is constructed and used as follows:
#   shreds = SymmetricGPG::Shreds.new( passphrase, sew, [shred1,shred2,...] )
#   shreds.encrypt # encrypts sew into shreds shred1,shred2,...
#   shreds.decrypt # decrypts shreds shred1,shred2,... into sew.
# See:
#    https://sites.google.com/site/carlosjhr64/rubygems/symmetricgpg
# for an example utility, gpg_shredder.
#

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
if !files.encrypt then
  # No exceptions where raised, but I get a bad certificate warning.
  puts "Warnings(A): #{files.errors}"
end
# Ok, let's decrypt README.enc
files.plain = 'README.dec'
if !files.decrypt then
  # I don't get any warnings here.
  puts "Warnings(B): #{files.errors}"
end
# README.dec should be identical to README.txt
raise "Bad encryption/decryption" if `diff README.dec README.txt`.length != 0

#
# Strings
#
# It's a good idea to set the passphrase right away in the constructor.
strings = SymmetricGPG::Strings.new('Not this one either.')
strings.plain = 'The rain in spain rains mainly in the plane.'
# The methods #encrypt and #decrypt usually return @errors.nil?, but
# for Symetric::Strings it returns the encrypted or decrypted string value.
encrypted = strings.encrypt
# One can still check for warnings.
if strings.errors then
  # I get a bad certificate warning.
  puts "Warnings(C): #{strings.errors}"
end
# Note that the encrypted attribute is also set.
raise "Bad encrypted attribute" if encrypted != strings.encrypted
# And it's garbled
puts "Garbled:"
puts encrypted
# No cheat, set plain to ":" and decrypt back, see that it works.
strings.plain = ':'
puts "Plain#{strings.plain}"
strings.decrypt
# Again, one can check for warnings
if strings.errors then
  # I get none.
  puts "Warnings(D): #{strings.errors}"
end
puts strings.plain


#
# IOs
#
plain = File.open('README.txt','r')
encrypted = File.open('README.enc2','wb')
# All constructors can set the four main attributes.
ios = SymmetricGPG::IOs.new('Maybe... nope! Be random.', plain, encrypted, true) # ok to overwrite
if !ios.encrypt then
  # Again, I get a certificate warning here.
  puts "Warnings(E): #{ios.errors}"
end
encrypted.close
plain.close
# README.enc2 is encrypted.  Now decrypt it back.
ios.encrypted = File.open('README.enc2','r')
ios.plain = File.open('README.dec2','wb')
if !ios.decrypt then
  # And I don't get any warnings here.
  puts "Warnings(F): #{ios.errors}"
end
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
