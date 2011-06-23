#
# This software is GPL.
#

#################################
#         Version 2.0.1 (ooops!)#
#     brutally hacks 1.3.0      #
# gem 'symmetric_gpg', '~> 2.0' #
#################################
#           SYNOPSIS            #
#################################
#
# New in version 1.3 was SymmetricGPG::Shreds,
# which uses Shredder:
#    https://rubygems.org/gems/shredder
# Works like SymmetricGPG::Files, described below, but
# is constructed and used as follows:
#   shreds = SymmetricGPG::Shreds.new( passphrase, sew, [shred1,shred2,...] ) # where sew is a filename.
#   shreds.encrypt # encrypts sew into shreds shred1,shred2,...
#   shreds.decrypt # decrypts shreds shred1,shred2,... into sew.
# See:
#    https://sites.google.com/site/carlosjhr64/rubygems/symmetricgpg
# for an example utility, gpg_shredder.
# Version 2.0 adds ways to get and put strings from and into shreds.
#    shreds = SymmetricGPG::Shreds.new( passphrase, sew, [shred1,shred2,...] ) # where sew is "a given string".
#    # Note that these below breaks previous api, thus the major version jump.
#    shreds.shred
#    sew = shreds.sew
# The distinction of sew as a String instead of a filename is made by the choice of methods.
# As a filename, it's #encrypt and #decrypt.  As a string it's #shred and #sew.

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

# # If you have shredder, you can try this:
# require 'symmetric_gpg'
# string = "A is for Apple."
# shreds = SymmetricGPG::Shreds.new("Shreddelicious!", string, ['shred.1','shred.2'])
# shreds.shred # Should encrypt and then shred the string into shred.1 and shred.2.
# shreds.plain = nil # no cheat!
# plain = shreds.sew # should get the shredded string back.
# raise "No... I did not the the string back." if !(plain == string)
# puts plain
