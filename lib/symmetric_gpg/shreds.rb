# A gpg command line wrapper for symmetric encryption
module SymmetricGPG
# Shreds symmetrically encripts a file and shreds it via ruby-gem shredder command line utility.
class Shreds < Files
  SHREDDER	= 'shredder'
  SHREDDING	= '--io --shred'
  SEWING	= '--relay --io --sew'

  ENC = "Shred files not created (or incomplete)."
  ENE = "Shred files do not exist (or incomplete)."
  EE  = "At least one shred files exists."

  attr_accessor :shredder, :shredding, :sewing
  def initialize(*parameters)
   super
   @shredder	= SHREDDER
   @shredding	= SHREDDING
   @sewing	= SEWING
  end

  protected

  def _encrypted_exist?
    @encrypted.inject(false){|boolean,shred| boolean || File.exist?(shred)}
  end

  def _encrypt
    shreds = @encrypted.join("' '")
    Open3.popen3( "#{@cryptor} #{@encrypting} | #{@shredder} #{@shredding} '#{shreds}'"){|stdin,stdout,stderr|
      stdin.puts @passphrase
      stdin.write File.read(@plain)
      stdin.close_write
      read_errors(stderr)
    }
  end
  alias shred _encrypt

  def _decrypt
    shreds = @encrypted.join("' '")
    yes = (@force)? '--yes': ''
    Open3.popen3( "#{@shredder} #{@sewing} '#{shreds}' | #{@cryptor} #{yes} --output '#{@plain}' #{@decrypting}"){|stdin,stdout,stderr|
      stdin.puts @passphrase
      read_errors(stderr)
    }
  end
  alias sew _decrypt

  public :sew, :shred

end
end
