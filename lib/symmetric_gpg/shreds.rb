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

  def _enc
    shreds = @encrypted.join("' '")
    yes = (@force)? '--yes': '' # Note: shredder 0.2.0 ignores this.
    Open3.popen3( "#{@cryptor} #{@encrypting} | #{@shredder} #{yes} #{@shredding} '#{shreds}'"){|stdin,stdout,stderr|
      stdin.puts @passphrase
      stdin.write yield
      stdin.close_write
      read_errors(stderr)
    }
  end

  def _encrypt
    _enc{ File.read(@plain) }
  end

  def _dec(output='')
    shreds = @encrypted.join("' '")
    yes = (@force)? '--yes': ''
    Open3.popen3( "#{@shredder} #{@sewing} '#{shreds}' | #{@cryptor} #{yes} #{output} #{@decrypting}"){|stdin,stdout,stderr|
      stdin.puts @passphrase
      yield(stdout) if block_given?
      read_errors(stderr)
    }
  end

  def _decrypt
    _dec("--output '#{@plain}'")
  end

  public

  def shred
    _enc{ @plain }
  end

  def sew
    _dec{|stdout| @plain = stdout.read }
    return @plain
  end

end
end
