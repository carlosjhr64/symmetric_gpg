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
    Open3.popen3( "#{@cryptor} #{yes} --output '#{outfile}' #{type} '#{infile}'"){|stdin,stdout,stderr|
      stdin.puts @passphrase
      read_errors(stderr)
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
    @errors.nil?
  end
  alias enc encrypt

  def decrypt
    # validations
    nils!
    raise "Encrypted file does not exist." if !File.exist?(@encrypted)
    raise "Plain file exists." if !@force && File.exist?(@plain)

    # action
    cryptor_files(@decrypting)

    # confirmation
    raise "Plain file not created." if !File.exist?(@plain)
    @errors.nil?
  end
  alias dec decrypt

end
end
