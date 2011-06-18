# A gpg command line wrapper for symmetric encryption
module SymmetricGPG
# Files wraps gpg's classic form "take this file and encript it"
class Files < Data

  def initialize(*parameters)
   super
  end

  def cryptor_files(type)
    infile,outfile = (type == @encrypting)? [@plain,@encrypted] : [@encrypted,@plain]
    yes = (@force)? '--yes': ''
    IO.popen( "#{@cryptor} #{yes} --output '#{outfile}' #{type} '#{infile}' 2> /dev/null", 'w' ){|pipe|
      pipe.puts @passphrase
      pipe.flush
    }
  end

  def encrypt
    # validations
    nils!
    raise "Plain file does not exist." if !File.exist?(@plain)
    raise "Encrypted file exists." if !@force && File.exist?(@encrypted)

    # actions
    cryptor_files(@encrypting)

    # confirmation
    raise "Encrypted file not created." if !File.exist?(@encrypted)
    true
  end
  alias enc encrypt

  def decrypt
    # validations
    nils!
    raise "Encrypted file is nil or does not exist." if !File.exist?(@encrypted)
    raise "Plain file is nil or exists." if !@force && File.exist?(@plain)

    # action
    cryptor_files(@decrypting)

    # confirmation
    raise "Plain file not created." if !File.exist?(@plain)
    true
  end
  alias dec decrypt

end
end
