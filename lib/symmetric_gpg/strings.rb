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
    @passphrase.nil?
  end

  def self.write_read(instring,stdin,stdout)
    Thread.new{ stdin.write instring; stdin.close_write }
    stdout.read
  end

  def cryptor_str_pipe(type)
    instring = (type != @encrypting)? @encrypted : @plain
    outstring = nil
    Open3.popen3( "#{CRYPTOR} #{type}" ){|stdin,stdout,stderr|
      stdin.puts @passphrase
      outstring = Strings.write_read(instring,stdin,stdout)
      read_errors(stderr)
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
