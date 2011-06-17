# A gpg command line wrapper for symmetric encription
class SymmetricGPG
###############
### STRINGS ###
###############
class Strings

  def initialize(*parameters)
    super
  end

  def self.write_read(instring,pipe)
    Thread.new{ pipe.write instring; pipe.close_write }
    pipe.read
  end

  def cryptor_str_pipe(type)
    instring = (type != @encrypting)? @encrypted : @plain
    outstring = nil
    IO.popen( "#{CRYPTOR} #{type} 2> /dev/null", 'w+' ){|pipe|
      pipe.puts @passphrase
      outstring = Strings.write_read(instring,pipe)
    }
    return outstring
  end

  def encrypt
    @encrypted = SymmetricGPG.cryptor_str_pipe(@encrypting,@plain)
  end

  def decrypt
    @plain = SymmetricGPG.cryptor_str_pipe(@decrypting,@encrypted)
  end

end
end
