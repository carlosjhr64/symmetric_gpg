# A gpg command line wrapper for symmetric encryption
module SymmetricGPG
# Encrypts/decrypts strings
class Strings < Data

  def initialize(*parameters)
    super
  end

  # For Strings, plain and encripted can be found to be nil.
  # nil! in super will then use this version of nil? to raise exceptions.
  def nils?
    [@passphrase, @force, @cryptor, @encrypting, @decrypting].each do |attribute|
      return true if attribute.nil?
    end
    return false
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
    nils!
    @encrypted = cryptor_str_pipe(@encrypting)
  end

  def decrypt
    nils!
    @plain = cryptor_str_pipe(@decrypting)
  end

end
end
