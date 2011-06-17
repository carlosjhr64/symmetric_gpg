# A gpg command line wrapper for symmetric encryption
module SymmetricGPG
#############
### FILES ###
#############
class Files < Data

  def initialize(*parameters)
   super
  end

  def cryptor_files(type)
    infile,outfile = (type != @encrypting)? [@encrypted,@plain] : [@plain,@encrypted]
    yes = (@force)? '--yes': ''
    IO.popen( "#{@cryptor} #{yes} --output '#{outfile}' #{type} '#{infile}' 2> /dev/null", 'w' ){|pipe|
      pipe.puts @passphrase
      pipe.flush
    }
  end

  def encrypt
    # validations
    raise "Plain file is nil or does not exist." if @plain.nil? || !File.exist?(@plain)
    raise "Encrypted file is nil or exists." if @encrypted.nil? || (!@force && File.exist?(@encrypted))

    # actions
    cryptor_files(@encrypting)

    # confirmation
    raise "Encrypted file not created." if !File.exist?(@encrypted)
    true
  end
  alias enc encrypt

  def decrypt
    # validations
    raise "Encrypted file is nil or does not exist." if @encrypted.nil? || !File.exist?(@encrypted)
    raise "Plain file is nil or exists." if @plain.nil? || (!@force && File.exist?(@plain))

    # action
    cryptor_files(@decrypting)

    # confirmation
    raise "Plain file not created." if !File.exist?(@plain)
    true
  end
  alias dec decrypt

end
end