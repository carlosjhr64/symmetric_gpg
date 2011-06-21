# A gpg command line wrapper for symmetric encryption
module SymmetricGPG
# Files wraps gpg's classic form "take this file and encrypt it"
class Files < Data
  PNE = "Plain does not exist."
  PNC = "Plain not created."
  PE  = "Plain exists."
  ENE = "Encrypted does not exist."
  ENC = "Encrypted not created."
  EE  = "Encrypted exists."


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

  protected

  # If you see the Shreds class, you'll see why these were broken out.
  def _encrypt
    cryptor_files(@encrypting)
  end

  def _decrypt
    cryptor_files(@decrypting)
  end

  def _encrypted_exist?
    File.exist?(@encrypted)
  end

  def _plain_exist?
    File.exist?(@plain)
  end

  def _plain_not_exist
    raise PNE if !_plain_exist?
  end

  def _encrypted_exist
    raise EE if !@force && _encrypted_exist?
  end

  def _encrypted_not_created
    raise ENC if !_encrypted_exist?
  end

  def _encrypted_not_exist
    raise ENE if !_encrypted_exist?
  end

  def _plain_exist
    raise PE if !@force && _plain_exist?
  end

  def _plain_not_created
    raise PNC if !_plain_exist?
  end

  public

  def encrypt
    # validations
    nils!
    _plain_not_exist
    _encrypted_exist

    # actions
    _encrypt

    # confirmation
    _encrypted_not_created
    @errors.nil?
  end
  alias enc encrypt

  def decrypt
    # validations
    nils!
    _encrypted_not_exist
    _plain_exist

    # action
    _decrypt

    # confirmation
    _plain_not_created
    @errors.nil?
  end
  alias dec decrypt

end
end
